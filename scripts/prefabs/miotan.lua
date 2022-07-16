local MakePlayerCharacter = require("prefabs/player_common")

local assets = {
    Asset( "SCRIPT", "scripts/prefabs/player_common.lua" ),

    Asset( "ANIM", "anim/miotan.zip" ),
    Asset( "ANIM", "anim/ghost_miotan_build.zip" ),
}

local prefabs = {
    "pandorachest_reset",
    "statue_transition"
}

local start_inv = {}

for k, v in pairs(TUNING.GAMEMODE_STARTING_ITEMS) do
    start_inv[string.lower(k)] = v.MIOTAN
end
prefabs = FlattenTree({ prefabs, start_inv }, true)

local function set_moisture(table)
    for _, v in pairs(table) do
        if (v.prefab == "nightmarefuel" or
            (v.components.equippable and v.components.equippable:IsEquipped()))
                and v.components.inventoryitem
                and v.components.inventoryitem:IsWet()
                then
            v.components.inventoryitemmoisture:SetMoisture(0)
        end
    end
end

local function find_nightmarefuel(item)
    return item.prefab == "nightmarefuel"
end

local function dry_equipment(inst)
    local inv = inst.components.inventory
    if not inv then return end

    for _, item in ipairs(inv:FindItems(find_nightmarefuel)) do
        if item.components.inventoryitem and item.components.inventoryitem:IsWet() then
            item.components.inventoryitemmoisture:SetMoisture(0)
        end
    end

    local eslots = inv.equipslots
    if eslots then set_moisture(eslots) end

    local boat = inst.components.sailor and inst.components.sailor:GetBoat()
    if boat then
        local boatinv = boat.components.container and boat.components.container.boatequipslots
        local boatslots = boat.components.container and boat.components.container.slots
        if boatinv then set_moisture(boatinv) end
        if boatslots then set_moisture(boatslots) end
    end
end

local function check_has_item(inst, item)
    if item == nil then return end
    local inv = inst.components.inventory
    local inv_boat = inst.components.sailor and inst.components.sailor:GetBoat() and inst.components.sailor:GetBoat().components.container
    return (inv and inv:Has(item, 1)) or (inv_boat and inv_boat:Has(item, 1))
end

local function consume_item(inst, item)
    if item == nil then return end
    local inv = inst.components.inventory
    local inv_boat = inst.components.sailor and inst.components.sailor:GetBoat() and inst.components.sailor:GetBoat().components.container
    if inv and inv:Has(item, 1) then
        inv:ConsumeByName(item, 1)
    elseif inv_boat and inv_boat:Has(item, 1) then
        inv_boat:ConsumeByName(item, 1)
    end
end

local function auto_refuel(inst)
    local FUELTYPE = "nightmarefuel"
    local is_fx_true = false
    local fueled_table = {
        player = {
            armorskeleton   = 1, -- 骨甲
            lantern         = 1, -- 提灯
            lighter         = 1, -- 薇洛的打火机
            minerhat        = 1, -- 头灯
            molehat         = 2, -- 鼹鼠帽
            nightstick      = 1, -- 晨星
            thurible        = 1, -- 香炉
            yellowamulet    = 1, -- 黄符
            purpleamulet    = 1, -- 紫符
            blueamulet      = 1, -- 冰符

            nightpack       = 1, -- 影背包 in Civi the MOgician of Light and Dark
            darkamulet      = 1, -- 黑暗护符 in Civi
            lightamulet     = 1, -- 光明护符 in Civi

            bottlelantern   = 1, -- 瓶灯 in Island Adventures

        },
        boat = { -- Island Adventures
            boat_lantern    = 1, -- 船灯
            ironwind        = 2, -- 螺旋桨
        }
    }
    local finiteuses_table = {
        player = {
            orangestaff     = 2, -- 橙杖
        }
    }

    local player_eslots = inst.components.inventory and inst.components.inventory.equipslots
    local boat = inst.components.sailor and inst.components.sailor:GetBoat() -- Compatible for Island Adventures
    local boatequipslots = boat and boat.components.container and boat.components.container.boatequipslots

    for source, eslots in pairs({player = player_eslots, boat = boatequipslots}) do
        for _, target in pairs(eslots) do
            if fueled_table[source] and fueled_table[source][target.prefab] then
                local mult = fueled_table[source][target.prefab]
                local fueled = target.components.fueled
                if fueled and fueled:GetPercent() + TUNING.LARGE_FUEL * mult / fueled.maxfuel * fueled.bonusmult <= 1 and
                    check_has_item(inst, FUELTYPE)
                then
                    is_fx_true = true
                    fueled:DoDelta(TUNING.LARGE_FUEL * fueled.bonusmult)
                    consume_item(inst, FUELTYPE)
                    if fueled.ontakefuelfn then fueled.ontakefuelfn(target) end
                end
            elseif finiteuses_table[source] and finiteuses_table[source][target.prefab] then
                local uses = finiteuses_table[source][target.prefab]
                local finiteuses = target.components.finiteuses
                if finiteuses and finiteuses:GetUses() + uses <= finiteuses.total and
                    check_has_item(inst, FUELTYPE)
                then
                    is_fx_true = true
                    finiteuses:Use(0 - uses)
                    consume_item(inst, FUELTYPE)
                end
            end
        end
    end

    if is_fx_true then
        SpawnPrefab("pandorachest_reset").entity:SetParent(inst.entity)
    end
end

local function on_boost(inst)
    inst.components.locomotor.runspeed = TUNING.MIOTAN_RUN_SPEED
    inst.components.temperature.mintemp = TUNING.MIOTAN_BOOST_MINTEMP
    if inst.components.eater ~= nil then
        inst.components.eater:SetAbsorptionModifiers(TUNING.MIOTAN_BOOST_ABSORPTION, TUNING.MIOTAN_BOOST_ABSORPTION, TUNING.MIOTAN_BOOST_ABSORPTION)
    end
end

local function on_update(inst, dt)
    inst.boost_time = inst.boost_time - dt
    if inst.boost_time <= 0 then
        inst.boost_time = 0
        if inst.boosted_task ~= nil then
            inst.boosted_task:Cancel()
            inst.boosted_task = nil
        end
        inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED
        inst.components.temperature.mintemp = -20
        if inst.components.eater ~= nil then
            inst.components.eater:SetAbsorptionModifiers(1, 1, 1)
        end
        if inst._dry_task ~= nil then
            inst._dry_task:Cancel()
            inst._dry_task = nil
        end
    else
        --boosteffect(inst)
        auto_refuel(inst)
        if inst._dry_task == nil then
            inst._dry_task = inst:DoPeriodicTask(0, function(inst)
                dry_equipment(inst)
            end)
        end
    end
end

local function on_long_update(inst, dt)
    inst.boost_time = math.max(0, inst.boost_time - dt)
end

local function start_boost(inst, duration)
    inst.boost_time = duration
    if inst.boosted_task == nil then
        inst.boosted_task = inst:DoPeriodicTask(1, on_update, nil, 1)
        inst:DoTaskInTime(0, function(inst) on_update(inst, 0) end) -- Prevent autorefuel function consumes nightmarefuels before actually "eated"
        on_boost(inst)
    end
end

local function on_load(inst, data)
    if data ~= nil and data.boost_time ~= nil then start_boost(inst, data.boost_time) end
end

local function on_save(inst, data)
    data.boost_time = inst.boost_time > 0 and inst.boost_time or nil
end

local function on_became_ghost(inst)
    if inst.boosted_task ~= nil then
        inst.boosted_task:Cancel()
        inst.boosted_task = nil
        inst.boost_time = 0
    end
end

local function on_death(inst)
    if inst.death_task == nil then
        inst.death_task = inst:DoTaskInTime(2, function(inst)
            SpawnPrefab("nightmarefuel").Transform:SetPosition(inst:GetPosition():Get())
            inst.death_task:Cancel()
            inst.death_task = nil
        end)
    end
end

local function on_haunt(inst, doer)
    return not (inst.components.sanity and inst.components.sanity.current == 0)
end

local common_postinit = function(inst)
    inst.soundsname = "willow"
    inst:AddTag("reader")
    inst:AddTag("nightstorychar")
    inst:AddTag("nightmare_twins")
    -- Minimap icon
    inst.MiniMapEntity:SetIcon("miotan.tex")
end

-- This initializes for the host only
local master_postinit = function(inst)
    inst.starting_inventory = start_inv[TheNet:GetServerGameMode()] or start_inv.default

    inst.boost_time = 0
    inst.boosted_task = nil

    inst:AddComponent("reader")

    inst:AddComponent("hauntable")
    inst.components.hauntable.onhaunt = on_haunt
    inst.components.hauntable.hauntvalue = TUNING.HAUNT_INSTANT_REZ
    inst.components.hauntable.no_wipe_value = true

    inst.components.health:SetMaxHealth(TUNING.MIOTAN_STATUS)
    inst.components.hunger:SetMax(TUNING.MIOTAN_STATUS)
    inst.components.sanity:SetMax(TUNING.MIOTAN_STATUS)

    inst.components.sanity.dapperness = TUNING.MIOTAN_SANITY_DAPPERNESS
    inst.components.sanity.night_drain_mult = TUNING.MIOTAN_SANITY_NIGHT_MULT
    inst.components.sanity.neg_aura_mult = TUNING.MIOTAN_SANITY_MULT

    if inst.components.eater then
        inst.components.eater:SetCanEatNightmareFuel()
        inst.components.eater.stale_hunger = TUNING.MIOTAN_STALE_HUNGER_RATE
        inst.components.eater.stale_health = TUNING.MIOTAN_STALE_HEALTH_RATE
        inst.components.eater.spoiled_hunger = TUNING.MIOTAN_SPOILED_HUNGER_RATE
        inst.components.eater.spoiled_health = TUNING.MIOTAN_SPOILED_HUNGER_RATE
    end

    inst:ListenForEvent("ms_becameghost", on_became_ghost)
    inst.OnLongUpdate = on_long_update
    inst.OnSave = on_save
    inst.OnLoad = on_load

    inst.skeleton_prefab = nil
    inst:ListenForEvent("death", on_death)

    inst.StartBoost = start_boost
end

return MakePlayerCharacter("miotan", prefabs, assets, common_postinit, master_postinit)
