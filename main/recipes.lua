local AddRecipe = GlassicAPI.AddRecipe
local SortAfter = GlassicAPI.RecipeSortAfter
local SortBefore = GlassicAPI.RecipeSortBefore
local AddDeconstructRecipe = AddDeconstructRecipe
local AddPlayerPostInit = AddPlayerPostInit
GLOBAL.setfenv(1, GLOBAL)

local function add_tech(tech_name, merge_table, brainjelly)
    if tech_name then
        GlassicAPI.AddTech(tech_name)
        if type(merge_table) == "table" then
            for target, bonus in pairs(merge_table) do
                GlassicAPI.MergeTechBonus(target, tech_name, bonus)
            end
        end
        if brainjelly then
            TECH.LOST[tech_name] = 10
        end
    end
end

local MERGE_TABLES =
{
    CIVI =
    {
        MOONORB_UPGRADED = 1,
        MOON_ALTAR_FULL = 1,
        OBSIDIAN_BENCH = 1,
    },
    DUMMY =
    {
        ANCIENTALTAR_HIGH = 1,
        OBSIDIAN_BENCH = 1,
    }
}
add_tech("CIVITECH", MERGE_TABLES.CIVI, true)
add_tech("DUMMYTECH", MERGE_TABLES.DUMMY, true)
local CIVITECH_ONE = { CIVITECH = 1}
local DUMMYTECH_ONE = { DUMMYTECH = 1}

STRINGS.NAMES.CIVI_REDGEM = STRINGS.NAMES.REDGEM
STRINGS.NAMES.CIVI_BLUEGEM = STRINGS.NAMES.BLUEGEM
STRINGS.NAMES.CIVI_DARKCRYSTAL = STRINGS.NAMES.DARKCRYSTAL
STRINGS.NAMES.CIVI_LIGHTCRYSTAL = STRINGS.NAMES.LIGHTCRYSTAL
STRINGS.NAMES.DUMMY_NIGHTMAREFUEL = STRINGS.NAMES.NIGHTMAREFUEL

--------------------
------- Civi -------
--------------------
-- 红宝石 --
AddRecipe("civi_redgem", {Ingredient("bluegem", 1), Ingredient("nightmarefuel", 1)}, TECH.CELESTIAL_ONE, {nounlock = true, nochar = true, nomods = true, builder_tag = "ns_builder_civi", product = "redgem", hidden = true})

-- 蓝宝石 --
AddRecipe("civi_bluegem", {Ingredient("redgem", 1), Ingredient("nightmarefuel", 1)}, TECH.CELESTIAL_ONE, {nounlock = true, nochar = true, nomods = true, builder_tag = "ns_builder_civi", product = "bluegem", hidden = true})
SortAfter("civi_bluegem", "civi_redgem")

-- 黑水晶
AddRecipe("darkcrystal", {Ingredient("purplegem", 1), Ingredient("nightmarefuel", 4)}, TECH.NONE, {nomods = true, builder_tag = "ns_builder_civi", no_deconstruction = true})
SortAfter("darkcrystal", "purplegem")

-- 白水晶
AddRecipe("lightcrystal", {Ingredient("purplegem", 1), Ingredient("nightmarefuel", 4)}, TECH.NONE, {nomods = true, builder_tag = "ns_builder_civi", no_deconstruction = true})
SortAfter("lightcrystal", "darkcrystal")

-- 纯粹辉煌
AddRecipe("civi_purebrilliance", {Ingredient("horrorfuel", 1), Ingredient("moonglass", 1)}, TECH.LUNARFORGING_TWO, {nounlock = true, nochar = true, nomods = true, builder_tag = "ns_builder_civi", product = "purebrilliance", hidden = true})
SortAfter("civi_purebrilliance", "lunarplant_kit")

-- 纯粹恐惧
AddRecipe("civi_horrorfuel", {Ingredient("purebrilliance", 1), Ingredient("nightmarefuel", 1)}, TECH.SHADOWFORGING_TWO, {nounlock = true, nochar = true, nomods = true, builder_tag = "ns_builder_civi", product = "horrorfuel", hidden = true})
SortAfter("civi_horrorfuel", "voidcloth_kit")

-- 影背包 --
AddRecipe("nightpack", {Ingredient("darkcrystal", 1), Ingredient("lightcrystal", 1), Ingredient("nightmarefuel", 5)}, TECH.CELESTIAL_ONE, {nounlock = true, builder_tag = "ns_builder_civi"})
SortBefore("nightpack", "civi_redgem")

-- 友爱戒指
AddRecipe("friendshipring", {Ingredient("moonrocknugget", 4), Ingredient("nightmarefuel", 4)}, CIVITECH_ONE, {nounlock = true, builder_tag = "ns_builder_civi"})
SortAfter("friendshipring", "nightpack")

-- 注能图腾
AddDeconstructRecipe("friendshiptotem_dark", {Ingredient("moonrocknugget", 4), Ingredient("nightmarefuel", 4), Ingredient("darkcrystal", 1)})
AddDeconstructRecipe("friendshiptotem_light", {Ingredient("moonrocknugget", 4), Ingredient("nightmarefuel", 4), Ingredient("lightcrystal", 1)})

AddDeconstructRecipe("darkgem", {Ingredient("darkcrystal", 1)})
AddDeconstructRecipe("lightgem", {Ingredient("lightcrystal", 1)})
AddDeconstructRecipe("darkmagatama", {Ingredient("darkcrystal", 1), Ingredient("nightmarefuel", 1)})
AddDeconstructRecipe("lightmagatama", {Ingredient("lightcrystal", 1), Ingredient("nightmarefuel", 1)})
AddDeconstructRecipe("darkamulet", {Ingredient("thulecite", 2), Ingredient("darkcrystal", 1), Ingredient("nightmarefuel", 4)})
AddDeconstructRecipe("lightamulet", {Ingredient("thulecite", 2), Ingredient("lightcrystal", 1), Ingredient("nightmarefuel", 4)})
---------------------
------- Dummy -------
---------------------

-- 灵魂剥离 --
AddRecipe("dummy_nightmarefuel", {Ingredient(CHARACTER_INGREDIENT.HEALTH, 20, nil, nil, "decrease_sanity.tex")}, TECH.NONE, {nomods = true, builder_tag = "ns_builder_dummy", product = "nightmarefuel", actionstr = "SOULSPLIT", hidden = true})
-- 暗影破碎者 --
AddRecipe("nightmare_spear", {Ingredient("nightmarefuel", 1)}, TECH.NONE, {builder_tag = "ns_builder_dummy", no_deconstruction = true, sg_state = "domediumaction"})

-- 收获的季节 --
AddRecipe("book_harvest", {Ingredient("papyrus", 2), Ingredient(CHARACTER_INGREDIENT.HEALTH, 15, nil, nil, "decrease_sanity.tex")}, TECH.SCIENCE_TWO, {builder_tag = "ns_builder_dummy"})

-- 雨神的眷恋 --
AddRecipe("book_toggledownfall", {Ingredient("papyrus", 2), Ingredient(CHARACTER_INGREDIENT.HEALTH, 30, nil, nil, "decrease_sanity.tex")}, TECH.MAGIC_THREE, {builder_tag = "ns_builder_dummy"})

-- 黑洞法杖 --
AddRecipe("blackholestaff", {Ingredient("livinglog", 2), Ingredient("orangegem", 2), Ingredient("nightmarefuel", 4)}, DUMMYTECH_ONE, {nounlock = true, builder_tag = "ns_builder_dummy"})
SortAfter("blackholestaff", "greenstaff")
---------------------
------- Other -------
---------------------

-- Reset Skill Tree --
AddRecipe("skilltree_respec_tool", {Ingredient("moonglass", 1), Ingredient("nightmarefuel", 1)}, TECH.NONE, {builder_tag = "player", nomods = true})
SortBefore("skilltree_respec_tool", "transmute_log")

-- 月影 --
AddRecipe("lunarshadow", {Ingredient("security_pulse_cage_full", 1), Ingredient("sword_lunarplant", 1), Ingredient("voidcloth_scythe", 1)}, TECH.LUNARFORGING_TWO, {nounlock=true, station_tag="lunar_forge", no_deconstruction = true})
SortAfter("lunarshadow", "houndstooth_blowpipe")

-- 恐惧锁链 --
AddRecipe("horrorchain", {Ingredient("horrorfuel", 4), Ingredient("voidcloth", 2)}, TECH.SHADOWFORGING_TWO, {nounlock=true, station_tag = "shadow_forge", no_deconstruction = true})
SortAfter("horrorchain", "voidcloth_scythe")

-- 武神铥头 --
-- AddRecipe("battleruinshat", {Ingredient("wathgrithrhat", 1), Ingredient("thulecite", 4)}, TECH.NONE, {builder_tag = "valkyrie"})
-- SortAfter("battleruinshat", "wathgrithrhat")

-- 厨师礼物包装 & 厨师包锅
AddRecipe("cookpackagewrap", {Ingredient("portablecookpot_item", 1), Ingredient("bundlewrap", 4)}, TECH.NONE, {builder_tag="masterchef", numtogive = 4})
SortAfter("cookpackagewrap", "portablespicer_item")
AddRecipe("cookgiftwrap", {Ingredient("portablecookpot_item", 1), Ingredient("giftwrap", 4)}, TECH.NONE, {builder_tag="masterchef", numtogive = 4})
SortAfter("cookgiftwrap", "cookpackagewrap")

-- 仙人掌粉 --
AddRecipe("spice_cactus", {Ingredient("cactus_meat", 2), Ingredient("cactus_flower", 1)}, TECH.FOODPROCESSING_ONE, {nounlock = true, numtogive = 2, nochar = true, builder_tag = "professionalchef", no_deconstruction = true})
SortAfter("spice_cactus", "spice_salt")

-- 月光粉 --
AddRecipe("spice_moonglass", {Ingredient("moonglass_charged", 1), Ingredient("moonglass", 5)}, TECH.FOODPROCESSING_ONE, {nounlock = true, numtogive = 2, nochar = true, builder_tag = "professionalchef", no_deconstruction = true})
SortAfter("spice_moonglass", "spice_cactus")

-- 便携衣柜 & 魔法礼装 --
AddRecipe("portable_wardrobe_wrap", {Ingredient("giftwrap", 1), Ingredient("nightmarefuel",1)}, TECH.MAGIC_THREE, {no_deconstruction = true}, {"MAGIC", "DECOR"})
SortAfter("portable_wardrobe_wrap", "wardrobe", "DECOR")
AddRecipe("portable_wardrobe_item", {Ingredient("portable_wardrobe_wrap", 3), Ingredient("boards", 4)}, TECH.MAGIC_THREE, {no_deconstruction = true}, {"MAGIC", "DECOR"})
SortAfter("portable_wardrobe_item", "portable_wardrobe_wrap")

-- 鸭子雕像 --
AddRecipe("chesspiece_headuck_builder", {Ingredient(TECH_INGREDIENT.SCULPTING, 2), Ingredient("rocks", 2)}, TECH.LOST, {nounlock = true, actionstr="SCULPTING", image="chesspiece_headuck.tex"})

-- THE 潮涌 --
AddRecipe("book_wetness", {Ingredient("book_rain", 1), Ingredient("book_temperature", 1), Ingredient("malbatross_feather", 10)}, TECH.BOOKCRAFT_ONE, {nounlock = true, builder_tag = "reader"})
SortAfter("book_wetness", "book_rain")

-- 月镐和月锤 --
AddRecipe("moonglasspickaxe", {Ingredient("twigs", 2), Ingredient("moonglass", 3)}, TECH.CELESTIAL_THREE, {nomods = true, nounlock = true, description = "moonglassaxe"})
SortAfter("moonglasspickaxe", "moonglassaxe")

AddRecipe("moonglasshammer", {Ingredient("twigs", 3), Ingredient("cutgrass", 6), Ingredient("moonglass", 3)}, TECH.CELESTIAL_THREE, {nomods = true, nounlock = true, description = "moonglassaxe"})
SortAfter("moonglasshammer", "moonglasspickaxe")

AddDeconstructRecipe("glassiccutter", {Ingredient("glasscutter", 1)})

------------------------------------------------
-- 防止改配方出问题的一个修复
------------------------------------------------
local function clear_nounlock_recipes(inst)
    if inst.components.builder then
        local recipes = inst.components.builder.recipes
        if recipes then
            for i, recipe in ipairs(recipes) do
                if AllRecipes[recipe] and AllRecipes[recipe].nounlock then
                    recipes[i] = nil
                end
            end
        end
    end
end

AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then return end

    local onload = inst.OnLoad
    inst.OnLoad = function(inst, ...)
        if onload then onload(inst, ...) end
        clear_nounlock_recipes(inst)
    end
    clear_nounlock_recipes(inst)
end)

-- [[ Reset Insight ]] --
local SkillTreeUpdater = require("components/skilltreeupdater")
local deactivate_skill = SkillTreeUpdater.DeactivateSkill
function SkillTreeUpdater:DeactivateSkill(...)
    local prev = self.skilltree.skip_validation
    self.skilltree.skip_validation = true
    deactivate_skill(self, ...)
    self.skilltree.skip_validation = prev
end
