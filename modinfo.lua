local function zheng(zh, en)
    local LOC = {
        zh = zh,
        zht = zh,
    }
    return LOC[locale] or en
end

version = "1.52.3"
-- basic info --
name = zheng("暗夜故事集", "Night Stories")
author = zheng("鸭子乐园", "Ducklantis")
changelog = zheng([[
- 调整了月光粉的代码逻辑。
版本更新历史：
- 新增只有拥有技能树的四名角色可以重置洞察。
- 新增一种快捷重置洞察的方法（详见合成菜单-角色栏）。
]], [[
- Tweak code logic for Lunar Powder.
Version Change Notes:
- Only characters with skill trees can reset insight.
- Add a quick way to reset insight (See Crafting Menu - Character Filter).
]])
description = zheng("版本: ", "Version: ") .. version ..
    zheng("\n\n本次更改内容:\n", "\n\nChange:\n") .. changelog .. "\n" ..
    zheng("“黑夜将至，你准备好了吗？”", "\"Night is coming, aren't you ready yet?\"")

priority = 25

api_version = 10
dst_compatible = true
all_clients_require_mod = true

icon_atlas = "images/modicon.xml"
icon = "modicon.tex"

mod_dependencies = {
    {
        workshop = "workshop-2521851770",    -- Glassic API
        ["GlassicAPI"] = false,
        ["Glassic API - DEV"] = true
    },
}
folder_name = folder_name or "workshop-"
if not folder_name:find("workshop-") then
    name = name .. " - DEV"
end

server_filter_tags = {
    "night_stories",
    "night stories",
}
