local prefabs = {}

table.insert(prefabs, CreatePrefabSkin("armorskeleton_none", {
	base_prefab = "armorskeleton",
	type = "item",
    rarity = "Glassic",
    assets = {
        Asset( "DYNAMIC_ANIM", "anim/dynamic/armorskeleton_none.zip" ),
        Asset( "PKGREF", "anim/dynamic/armorskeleton_none.dyn" ),
    },
    init_fn = function(inst) armorskeleton_init_fn(inst, "armorskeleton_none") end,
	skin_tags = { "ARMORSKELETON" },
}))

table.insert(prefabs, CreatePrefabSkin("skeletonhat_glass", {
	base_prefab = "skeletonhat",
	type = "item",
	rarity = "Glassic",
	assets = {
		Asset( "DYNAMIC_ANIM", "anim/dynamic/skeletonhat_glass.zip" ),
		Asset( "PKGREF", "anim/dynamic/skeletonhat_glass.dyn" ),
	},
	init_fn = function(inst) skeletonhat_init_fn(inst, "skeletonhat_glass") end,
	skin_tags = { "SKELETONHAT" },
}))

table.insert(prefabs, CreatePrefabSkin("lantern_mio", {
    base_prefab = "lantern",
    type = "item",
    build_name_override = "lantern_mio",
    rarity = "Reward",
    assets = {
        -- Asset( "ANIM", "anim/lantern_mio.zip" ),
        Asset( "DYNAMIC_ANIM", "anim/dynamic/lantern_mio.zip" ),
        Asset( "PKGREF", "anim/dynamic/lantern_mio.dyn" ),
    },
    prefabs = { "lantern_mio_fx_held", "lantern_mio_fx_ground", },
    init_fn = function(inst) ns_lantern_init_fn(inst, "lantern_mio", { "firefly" }, Vector3(67, -7, 0), {195 / 255, 190 / 255, 120 / 255}) end,
    skin_tags = { "LANTERN" },
    fx_prefab = { "lantern_mio_fx_held", "lantern_mio_fx_ground", },
	-- prefabs = { "lantern_winter_fx_held", "lantern_winter_fx_ground", },
    -- init_fn = function(inst) ns_lantern_init_fn(inst, "lantern_mio", { "snowflake" }, Vector3(67, -7, 0), {195 / 255, 190 / 255, 120 / 255}) end,
    -- skin_tags = { "LANTERN" },
	-- fx_prefab = { "lantern_winter_fx_held", "lantern_winter_fx_ground", },
    -- release_group = 95,
}))

table.insert(prefabs, CreatePrefabSkin("nightstick_crystal", {
	base_prefab = "nightstick",
	type = "item",
    rarity = "Glassic",
    build_name_override = "nightstick",
    assets = {
        Asset( "DYNAMIC_ANIM", "anim/dynamic/nightstick_crystal.zip" ),
        Asset( "PKGREF", "anim/dynamic/nightstick_crystal.dyn" ),
    },
    init_fn = function(inst) nightstick_init_fn(inst, "nightstick_crystal") end,
	skin_tags = { "NIGHTSTICK"},
}))

table.insert(prefabs, CreatePrefabSkin("yellowamulet_heart", {
	base_prefab = "yellowamulet",
	type = "item",
    rarity = "Glassic",
    build_name_override = "yellowamulet_heart",
    assets = {
        Asset( "DYNAMIC_ANIM", "anim/dynamic/yellowamulet_heart.zip" ),
        Asset( "PKGREF", "anim/dynamic/yellowamulet_heart.dyn" ),
    },
    init_fn = function(inst) yellowamulet_init_fn(inst, "yellowamulet_heart") end,
	skin_tags = { "YELLOWAMULET"},
}))

table.insert(prefabs, CreatePrefabSkin("greenamulet_heart", {
	base_prefab = "greenamulet",
	type = "item",
    rarity = "Glassic",
    build_name_override = "greenamulet_heart",
    assets = {
        Asset( "DYNAMIC_ANIM", "anim/dynamic/greenamulet_heart.zip"),
        Asset( "PKGREF", "anim/dynamic/greenamulet_heart.dyn"),
    },
    init_fn = function(inst) greenamulet_init_fn(inst, "greenamulet_heart") end,
	skin_tags = { "GREENAMULET" },
}))

table.insert(prefabs, CreatePrefabSkin("raincoat_peggy", {
	base_prefab = "raincoat",
	type = "item",
    rarity = "Glassic",
    build_name_override = "raincoat_peggy",
    assets = {
        Asset( "DYNAMIC_ANIM", "anim/dynamic/raincoat_peggy.zip"),
        Asset( "PKGREF", "anim/dynamic/raincoat_peggy.dyn"),
    },
    init_fn = function(inst) raincoat_init_fn(inst, "raincoat_peggy") end,
	skin_tags = { "RAINCOAT" },
}))

table.insert(prefabs, CreatePrefabSkin("dragonflychest_gingerbread", {
	base_prefab = "dragonflychest",
	type = "item",
    rarity = "Glassic",
    build_name_override = "dragonflychest_gingerbread",
    assets = {
        Asset( "DYNAMIC_ANIM", "anim/dynamic/dragonflychest_gingerbread.zip"),
        Asset( "PKGREF", "anim/dynamic/dragonflychest_gingerbread.dyn"),
    },
    init_fn = function(inst) GlassicAPI.BasicInitFn(inst, "dragonflychest_gingerbread") end,
	skin_tags = { "DRAGONFLYCHEST" },
}))

table.insert(prefabs, CreatePrefabSkin("meatrack_hermit_red", {
	base_prefab = "meatrack",
	type = "item",
    rarity = "Glassic",
    build_name_override = "meatrack_hermit_red",
    assets = {
        Asset( "DYNAMIC_ANIM", "anim/dynamic/meatrack_hermit_red.zip"),
        Asset( "PKGREF", "anim/dynamic/meatrack_hermit_red.dyn"),
    },
    init_fn = function(inst)
        inst.AnimState:SetBank("meatrack_hermit")
        GlassicAPI.BasicInitFn(inst, "meatrack_hermit_red")
    end,
	skin_tags = { "MEATRACK" },
}))

table.insert(prefabs, CreatePrefabSkin("meatrack_hermit_white", {
	base_prefab = "meatrack",
	type = "item",
    rarity = "Glassic",
    build_name_override = "meatrack_hermit_white",
    assets = {
        Asset( "DYNAMIC_ANIM", "anim/dynamic/meatrack_hermit_white.zip"),
        Asset( "PKGREF", "anim/dynamic/meatrack_hermit_white.dyn"),
    },
    init_fn = function(inst)
        inst.AnimState:SetBank("meatrack_hermit")
        GlassicAPI.BasicInitFn(inst, "meatrack_hermit_white")
    end,
	skin_tags = { "MEATRACK" },
}))

table.insert(prefabs, CreatePrefabSkin("hivehat_pigcrown", {
	base_prefab = "hivehat",
	type = "item",
    rarity = "Glassic",
    build_name_override = "hivehat_pigcrown",
    assets = {
        Asset( "DYNAMIC_ANIM", "anim/dynamic/hivehat_pigcrown.zip"),
        Asset( "PKGREF", "anim/dynamic/hivehat_pigcrown.dyn"),
    },
    init_fn = function(inst) hivehat_init_fn(inst, "hivehat_pigcrown") end,
	skin_tags = { "HIVEHAT" },
}))

table.insert(prefabs, CreatePrefabSkin("hivehat_pigcrown_willow", {
	base_prefab = "hivehat",
	type = "item",
    rarity = "Glassic",
    build_name_override = "hivehat_pigcrown",
    assets = {
        Asset( "DYNAMIC_ANIM", "anim/dynamic/hivehat_pigcrown_willow.zip"),
        Asset( "PKGREF", "anim/dynamic/hivehat_pigcrown_willow.dyn"),
    },
    init_fn = function(inst) hivehat_init_fn(inst, "hivehat_pigcrown_willow") end,
	skin_tags = { "HIVEHAT" },
}))

return unpack(prefabs)