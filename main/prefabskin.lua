GLOBAL.setfenv(1, GLOBAL)

-- Civi
local armor_skeleton_clear_fn = armorskeleton_clear_fn
function armorskeleton_clear_fn(inst)
    inst.foleysound = "dontstarve/movement/foley/bone"
    armor_skeleton_clear_fn(inst)
end

-- Mio
-- fix lantern reskin in inventory
local _lantern_init_fn = lantern_init_fn
lantern_init_fn = function(inst, ...)
    local ret = { _lantern_init_fn(inst, ...) }
    if inst.components.inventoryitem then
        inst.components.inventoryitem:ChangeImageName(inst:GetSkinName())
    end
    return unpack(ret)
end

local _lantern_clear_fn = lantern_clear_fn
lantern_clear_fn = function(inst, ...)
    local ret = { _lantern_clear_fn(inst, ...) }
    if inst.components.inventoryitem then
        inst.components.inventoryitem:ChangeImageName()
    end
    return unpack(ret)
end

-- yellowamulet
if not rawget(_G, "yellowamulet_clear_fn") then
    yellowamulet_clear_fn = function(inst) basic_clear_fn(inst, "amulets") end
    GlassicAPI.SetOnequipSkinItem("yellowamulet", {"swap_body", "swap_body", "torso_amulets"})
end

-- Dummy
-- Green Amulet
if not rawget(_G, "greenamulet_clear_fn") then
    greenamulet_clear_fn = function(inst) basic_clear_fn(inst, "amulets") end
    GlassicAPI.SetOnequipSkinItem("greenamulet", {"swap_body", "swap_body", "torso_amulets"})
end

-- Raincoat
if not rawget(_G, "raincoat_clear_fn") then
    raincoat_clear_fn = function(inst) basic_clear_fn(inst, "torso_rain") end
    GlassicAPI.SetOnequipSkinItem("raincoat", {"swap_body", "swap_body", "torso_rain"})
end

-- Meat Rack --
local _meatrack_clear_fn = meatrack_clear_fn
meatrack_clear_fn = function(inst)
    inst.AnimState:SetBank("meat_rack")
    return _meatrack_clear_fn(inst)
end

-- Black Lotus --
local function nightsword_update_image(inst, state)
    local skin_build = "nightsword_lotus"
    state = state and ("_" .. state) or ""
    inst.components.inventoryitem:ChangeImageName(skin_build .. state)

    inst.AnimState:PlayAnimation("idle" .. state)

    if inst.components.equippable:IsEquipped() then
        local owner = inst.components.inventoryitem.owner
        owner.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, "swap_nightmaresword" .. state, inst.GUID, "swap_nightmaresword" .. state)
    end

    GlassicAPI.SetFloatData(inst, { sym_build = skin_build, sym_name = "swap_nightmaresword" .. state, anim = "idle" .. state})
    GlassicAPI.UpdateFloaterAnim(inst)
end

local LOTUS_STATES = {
    darkcrystal = "dark",
    lightcrystal = "light",
}
local function nightsword_socketed_crystal(inst)
    nightsword_update_image(inst, LOTUS_STATES[inst.socketed_crystal])
end

ns_nightsword_init_fn = function(inst, build_name)
    if not TheWorld.ismastersim then return end

    local ret = { nightsword_init_fn(inst, build_name) }

    nightsword_socketed_crystal(inst)
    inst:ListenForEvent("equipped", nightsword_socketed_crystal)
    inst:ListenForEvent("itemget", nightsword_socketed_crystal)
    inst:ListenForEvent("itemlose", nightsword_socketed_crystal)
    return unpack(ret)
end

local _nightsword_clear_fn = nightsword_clear_fn
nightsword_clear_fn = function(inst)
    inst.AnimState:PlayAnimation("idle")
    GlassicAPI.SetFloatData(inst, {sym_build = "swap_nightmaresword", bank = "nightmaresword"})
    inst:RemoveEventCallback("equipped", nightsword_socketed_crystal)
    inst:RemoveEventCallback("itemget", nightsword_socketed_crystal)
    inst:RemoveEventCallback("itemlose", nightsword_socketed_crystal)
    return unpack({ _nightsword_clear_fn(inst) })
end


-- [[ Glassic Item Skins ]] --
-- Moon Glass Axe
if not rawget(_G, "moonglassaxe_clear_fn") then
    moonglassaxe_clear_fn = function(inst) basic_clear_fn(inst, "glassaxe") end
    GlassicAPI.SetOnequipSkinItem("moonglassaxe", {"swap_object", "swap_glassaxe", "swap_glassaxe"})
end

-- Moon Glass Hammer
moonglasshammer_clear_fn = function(inst) basic_clear_fn(inst, "glasshammer") end

-- Moon Glass Pickaxe
moonglasspickaxe_clear_fn = function(inst) basic_clear_fn(inst, "glasspickaxe") end

-- Glassic Cutter
glassiccutter_init_fn = function(inst, build_name)
    if not TheWorld.ismastersim then return end
    inst.AnimState:SetSkin(build_name, "glassiccutter")
    inst:OnChangeImage()
end
glassiccutter_clear_fn = function(inst)
    inst.AnimState:SetBuild("glassiccutter")
    inst:OnChangeImage()
end

local function onpercentusedchange(inst, data)
    if data.percent <= 0 and not inst:HasTag("usesdepleted") then
        local owner = inst.components.inventoryitem.owner
        if owner then
            owner.components.talker:Say(STRINGS.ANNOUNCE_GLASSIC_BROKE, nil, true)
        end
    end
end

glassic_orangestaff_init_fn = function(inst)
    local build_name = inst:GetSkinBuild()
    orangestaff_init_fn(inst, build_name)

    inst:ListenForEvent("percentusedchange", onpercentusedchange)
end

local _orangestaff_clear_fn = orangestaff_clear_fn
orangestaff_clear_fn = function(inst)
    local ret = { _orangestaff_clear_fn(inst) }

    inst:RemoveEventCallback("percentusedchange", onpercentusedchange)

    return unpack(ret)
end

-- lunarplanthat --
-- local NS_CHARS =
-- {
--     civi = true,
--     miotan = true,
--     dummy = true,
-- }

-- local function check_ns_chars(owner)
--     return NS_CHARS[owner.prefab] and "_lower" or ""
-- end

-- [[ Lunarplant Item Skins ]] --
-- Brightshade Helm
local function show_head(owner)
    owner.AnimState:Show("HEAD")
    if owner:HasTag("player") then
        owner.AnimState:Show("HAIR")
        owner.AnimState:ShowSymbol("face")
        owner.AnimState:ShowSymbol("swap_face")
        owner.AnimState:ShowSymbol("beard")
        owner.AnimState:ShowSymbol("cheeks")
    end
end

local function lunarplanthat_onequip(inst, data)
    local owner = data and data.owner
    if owner == nil then return end
    local skin_build = inst:GetSkinBuild()
    if skin_build then
        show_head(owner)
        if inst.fx ~= nil then
            inst.fx:Remove()
        end
        inst.fx = SpawnPrefab(skin_build .. "_fx")
        inst.fx:AttachToOwner(owner)
    end
end

if not rawget(_G, "lunarplanthat_init_fn") then
    function lunarplanthat_init_fn(inst)
        if not TheWorld.ismastersim then return end

        local ret = { GlassicAPI.BasicInitFn(inst) }

        inst:ListenForEvent("equipped", lunarplanthat_onequip)
        return unpack(ret)
    end
end

if not rawget(_G, "lunarplanthat_clear_fn") then
    function lunarplanthat_clear_fn(inst)
        if not TheWorld.ismastersim then return end

        local ret = { basic_clear_fn(inst, "hat_lunarplant") }

        inst:RemoveEventCallback("equipped", lunarplanthat_onequip)
        return unpack(ret)
    end
end

------------------------------------------------------------------------------

GlassicAPI.SkinHandler.AddModSkins({
    -- Civi
    civi = {
        "civi_none"
    },
    armorskeleton = {
        { name = "armorskeleton_none", exclusive_char = "civi" },
    },
    skeletonhat = {
        { name = "skeletonhat_glass", exclusive_char = "civi" },
    },
    nightsword = {
        { name = "nightsword_lotus", exclusive_char = "civi" },
    },
    -- Mio
    miotan = {
        "miotan_none",
        "miotan_classic"
    },
    lantern = {
        { name = "lantern_mio", exclusive_char = "miotan" }
    },
    -- nightstick = {
    --     { name = "nightstick_crystal", exclusive_char = "miotan" }
    -- },
    -- yellowamulet = {
    --     { name = "yellowamulet_heart", exclusive_char = "miotan" }
    -- },
    -- Dummy
    dummy = {
        "dummy_none"
    },
    -- greenamulet = {
    --     { name = "greenamulet_heart", exclusive_char = "dummy" }
    -- },
    raincoat = {
        { name = "raincoat_peggy", exclusive_char = "dummy" }
    },
    eyebrellahat = {
        { name = "eyebrellahat_peggy", exclusive_char = "dummy" }
    },
    -- Common
    dragonflychest = { "dragonflychest_gingerbread" },
    meatrack = { "meatrack_hermit_red", "meatrack_hermit_white" },
    hivehat = { "hivehat_pigcrown", "hivehat_pigcrown_willow" },
    alterguardianhat = { "alterguardianhat_finger" },
    wx78 = {
        "wx78_potato",
    },
    krampus_sack = { "krampus_sack_invisible"},
    -- Glassic items
    cane = { "cane_glass" },
    -- glassiccutter = { "glassiccutter_dream" },
    goldenaxe = { "goldenaxe_victorian" },
    moonglassaxe = { "moonglassaxe_northern", "moonglassaxe_victorian" },
    moonglasspickaxe = { "moonglasspickaxe_northern" },
    moonglasshammer = { "moonglasshammer_forge" },
    orangestaff = { "orangestaff_glass" },
    lunarplanthat = { "lunarplanthat_trans" },
})
