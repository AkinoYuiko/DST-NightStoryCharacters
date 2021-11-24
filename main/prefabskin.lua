GLOBAL.setfenv(1, GLOBAL)
ns_equipment_init_fn = function(inst, slot, skinname, override_build, swap_data)
    if swap_data then
        GlassicAPI.SetFloatData(inst, swap_data)
    end
    GlassicAPI.BasicInitFn(inst, skinname, override_build or skinname, override_build or skinname)
    GlassicAPI.BasicOnequipFn(inst, slot, override_build or skinname)
end

-- Civi
ns_armorskeleton_init_fn = function(inst, build)

    local function onequipfn(inst, data)
        data.owner.AnimState:ClearOverrideSymbol("swap_body")
    end

    GlassicAPI.SetFloatData(inst, { bank = "armor_skeleton", anim = "anim"})

    if not TheWorld.ismastersim then return end

    inst.skinname = build
    inst.AnimState:SetBuild(build)
    if inst.components.inventoryitem then
        inst.components.inventoryitem:ChangeImageName(inst:GetSkinName())
    end

    inst:ListenForEvent("equipped", onequipfn)
    inst.OnSkinChange = function(inst)
        inst:RemoveEventCallback("equipped", onequipfn)
    end
end

-- Mio
-- fix lantern reskin in inventory
local old_lantern_init_fn = lantern_init_fn
lantern_init_fn = function(inst, ...)
    local rt_lantern_init = {old_lantern_init_fn(inst, ...)}
    if inst.components.inventoryitem then
        inst.components.inventoryitem:ChangeImageName(inst:GetSkinName())
    end
    return unpack(rt_lantern_init)
end

local old_lantern_clear_fn = lantern_clear_fn
lantern_clear_fn = function(inst, ...)
    local rt_lantern_clear = {old_lantern_clear_fn(inst, ...)}
    if inst.components.inventoryitem then
        inst.components.inventoryitem:ChangeImageName()
    end
    return unpack(rt_lantern_clear)
end

-- nightstick
if not rawget(_G, "nightstick_clear_fn") then
    nightstick_init_fn = function(inst, skinname, override_build)
		GlassicAPI.SetFloatData(inst, { sym_build = override_build or skinname, sym_name = "swap_nightstick" })
        GlassicAPI.BasicInitFn(inst, skinname, override_build or skinname, override_build or skinname)
        GlassicAPI.BasicOnequipFn(inst, "hand", override_build or skinname, "swap_nightstick")
    end
    nightstick_clear_fn = function(inst)
		GlassicAPI.SetFloatData(inst, { sym_build = "swap_nightstick"})
		basic_clear_fn(inst, "nightstick")
	end
end

-- yellowamulet
if not rawget(_G, "yellowamulet_clear_fn") then
    yellowamulet_clear_fn = function(inst)
        GlassicAPI.SetFloatData(inst, { bank = "amulets", anim = "yellowamulet" })
        basic_clear_fn(inst, "amulets")
    end
end

-- lantern
local function lantern_onremovefx(fx)
    fx._lantern._lit_fx_inst = nil
end

local function lantern_enterlimbo(inst)
    --V2C: wow! superhacks!
    --     we want to drop the FX behind when the item is picked up, but the transform
    --     is cleared before lantern_off is reached, so we need to figure out where we
    --     were just before.
    if inst._lit_fx_inst then
        inst._lit_fx_inst._lastpos = inst._lit_fx_inst:GetPosition()
        local parent = inst.entity:GetParent()
        if parent then
            local x, y, z = parent.Transform:GetWorldPosition()
            local angle = (360 - parent.Transform:GetRotation()) * DEGREES
            local dx = inst._lit_fx_inst._lastpos.x - x
            local dz = inst._lit_fx_inst._lastpos.z - z
            local sinangle, cosangle = math.sin(angle), math.cos(angle)
            inst._lit_fx_inst._lastpos.x = dx * cosangle + dz * sinangle
            inst._lit_fx_inst._lastpos.y = inst._lit_fx_inst._lastpos.y - y
            inst._lit_fx_inst._lastpos.z = dz * cosangle - dx * sinangle
        end
    end
end

local function lantern_off(inst)
    local fx = inst._lit_fx_inst
    if fx then
        if fx.KillFX then
            inst._lit_fx_inst = nil
            inst:RemoveEventCallback("onremove", lantern_onremovefx, fx)
            fx:RemoveEventCallback("enterlimbo", lantern_enterlimbo, inst)
            fx._lastpos = fx._lastpos or fx:GetPosition()
            fx.entity:SetParent(nil)
            if fx.Follower then
                fx.Follower:FollowSymbol(0, "", 0, 0, 0)
            end
            fx.Transform:SetPosition(fx._lastpos:Get())
            fx:KillFX()
        else
            fx:Remove()
        end
    end
end

local function lantern_on(inst)
    local owner = inst.components.inventoryitem.owner
    if owner then
        if inst._lit_fx_inst and inst._lit_fx_inst.prefab ~= inst._heldfx then
            lantern_off(inst)
        end
        if inst._heldfx then
            if inst._lit_fx_inst == nil then
                inst._lit_fx_inst = SpawnPrefab(inst._heldfx)
                inst._lit_fx_inst._lantern = inst
                if inst._overridesymbols and inst._lit_fx_inst.AnimState then
                    for i, v in ipairs(inst._overridesymbols) do
                        -- inst._lit_fx_inst.AnimState:OverrideItemSkinSymbol(v, inst:GetSkinBuild(), v, inst.GUID, "lantern")
                        inst._lit_fx_inst.AnimState:OverrideSymbol(v, inst:GetSkinBuild(), v)
                    end
                end
                inst._lit_fx_inst.entity:AddFollower()
                inst:ListenForEvent("onremove", lantern_onremovefx, inst._lit_fx_inst)
            end
            inst._lit_fx_inst.entity:SetParent(owner.entity)
            inst._lit_fx_inst.Follower:FollowSymbol(owner.GUID, "swap_object", inst._followoffset and inst._followoffset.x or 0, inst._followoffset and inst._followoffset.y or 0, inst._followoffset and inst._followoffset.z or 0)
        end
    else
        if inst._lit_fx_inst and inst._lit_fx_inst.prefab ~= inst._groundfx then
            lantern_off(inst)
        end
        if inst._groundfx then
            if inst._lit_fx_inst == nil then
                inst._lit_fx_inst = SpawnPrefab(inst._groundfx)
                inst._lit_fx_inst._lantern = inst
                if inst._overridesymbols and inst._lit_fx_inst.AnimState then
                    for i, v in ipairs(inst._overridesymbols) do
                        -- inst._lit_fx_inst.AnimState:OverrideItemSkinSymbol(v, inst:GetSkinBuild(), v, inst.GUID, "lantern")
                        inst._lit_fx_inst.AnimState:OverrideSymbol(v, inst:GetSkinBuild(), v)
                    end
                end
                inst:ListenForEvent("onremove", lantern_onremovefx, inst._lit_fx_inst)
                if inst._lit_fx_inst.KillFX then
                    inst._lit_fx_inst:ListenForEvent("enterlimbo", lantern_enterlimbo, inst)
                end
            end
            inst._lit_fx_inst.entity:SetParent(inst.entity)
        end
    end
end

ns_lantern_init_fn = function(inst, build_name, overridesymbols, followoffset, light_color_override)
    if not TheWorld.ismastersim then
        return
    end

    local function onequipfn(inst, data)
        local owner = data.owner
        owner.AnimState:OverrideSymbol("swap_object", build_name, "swap_lantern")
        owner.AnimState:OverrideSymbol("lantern_overlay", build_name, "lantern_overlay")
    end

    local function overrides_light_color(inst)
        if inst._light then
            inst._light.Light:SetColour(unpack(light_color_override))
        end
    end

    inst.skinname = build_name
    inst.components.inventoryitem:ChangeImageName(inst:GetSkinName())
    inst.AnimState:SetBuild(build_name)

    inst:ListenForEvent("equipped", onequipfn)
    inst:ListenForEvent("stoprowing", onequipfn) -- IA compatible after stopping rowing.

    if light_color_override then
        inst:ListenForEvent("lantern_on", overrides_light_color)
    end

    local skin_fx = SKIN_FX_PREFAB[build_name] --build_name is prefab name for lanterns
    if skin_fx then
        inst._heldfx = skin_fx[1]
        inst._groundfx = skin_fx[2]
        if inst._heldfx or inst._groundfx then
            inst._overridesymbols = overridesymbols
            inst._followoffset = followoffset
            inst:ListenForEvent("lantern_on", lantern_on)
            inst:ListenForEvent("lantern_off", lantern_off)
            inst:ListenForEvent("unequipped", lantern_off)
            inst:ListenForEvent("onremove", lantern_off)
        end
    end

    if inst.components.machine.ison then
        lantern_on(inst)
    end

    inst.OnSkinChange = function(inst)
        inst:RemoveEventCallback("equipped", onequipfn)
        inst:RemoveEventCallback("stoprowing", onequipfn) -- IA compatible after stopping rowing.
        if light_color_override then
            inst:RemoveEventCallback("lantern_on", overrides_light_color)
        end
    end
end

-- Dummy

-- Green Amulet
if not rawget(_G, "greenamulet_clear_fn") then
    -- greenamulet_init_fn = function(inst, skinname, override_build)
    --     GlassicAPI.BasicInitFn(inst, skinname, override_build or skinname, override_build or skinname)
    --     GlassicAPI.BasicOnequipFn(inst, "body", override_build or skinname)
    -- end
    greenamulet_clear_fn = function(inst)
        GlassicAPI.SetFloatData(inst, { bank = "amulets", anim = "greenamulet" })
        basic_clear_fn(inst, "amulets")
    end
end

-- Raincoat
if not rawget(_G, "raincoat_clear_fn") then
    -- local swap_data = { bank = "torso_rain", anim = "anim" }
    -- raincoat_init_fn = function(inst, skinname, override_build)
    --     GlassicAPI.SetFloatData(inst, swap_data)
    --     GlassicAPI.BasicInitFn(inst, skinname, override_build or skinname, override_build or skinname)
    --     GlassicAPI.BasicOnequipFn(inst, "body", override_build or skinname)
    -- end
    raincoat_clear_fn = function(inst)
        GlassicAPI.SetFloatData(inst, { bank = "torso_rain", anim = "anim" })
        basic_clear_fn(inst, "torso_rain")
    end
end

-- Meat Rack --
local _meatrack_clear_fn = meatrack_clear_fn
meatrack_clear_fn = function(inst)
    inst.AnimState:SetBank("meat_rack")
    return _meatrack_clear_fn(inst)
end


if not rawget(_G, "hivehat_clear_fn") then
    -- hivehat_init_fn = function(inst, skinname, override_build)
    --     GlassicAPI.BasicInitFn(inst, skinname, override_build or skinname, override_build or skinname)
    --     GlassicAPI.BasicOnequipFn(inst, "hat", override_build or skinname)
    -- end
    hivehat_clear_fn = function(inst)
        inst.AnimState:SetBuild("hat_hive")
        if not TheWorld.ismastersim then return end
        inst.components.inventoryitem:ChangeImageName()
    end
end

-- ns_eyebrella_init_fn = function(inst, skinname, override_build)
--     GlassicAPI.BasicInitFn(inst, skinname, override_build or skinname, override_build or skinname)
--     GlassicAPI.BasicOnequipFn(inst, "hat", override_build or skinname)
-- end

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
    -- Mio
    miotan = {
        "miotan_none",
        "miotan_classic"
    },
    lantern = {
        { name = "lantern_mio", exclusive_char = "miotan" }
    },
    nightstick = {
        { name = "nightstick_crystal", exclusive_char = "miotan" }
    },
    yellowamulet = {
        { name = "yellowamulet_heart", exclusive_char = "miotan" }
    },
    -- Dummy
    dummy = {
        "dummy_none"
    },
    greenamulet = {
        { name = "greenamulet_heart", exclusive_char = "dummy" }
    },
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
})
