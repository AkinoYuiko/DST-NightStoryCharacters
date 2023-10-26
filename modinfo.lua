local function zheng(zh, en)
    local LOC = {
        zh = zh,
        zht = zh,
    }
    return LOC[locale] or en
end

version = "1.44.6"
version_compatible = "1.44.5"
-- basic info --
name = zheng("暗夜故事集", "Night Stories")
author = zheng("鸭子乐园", "Ducklantis")
changelog = zheng([[
- 更新澪的文本。

- 修复了月光粉额外攻击的触发条件存在的漏洞。
- 修复一处崩溃。
- 新增【亮茄头盔】对【月影】的伤害加成。
- 修复一处拼写错误。
- 调整了月光粉的配方和持续时间。
- 新物品【月光粉】:
  赋予一次额外攻击（无视位面实体抵抗），仅当未佩戴启迪之冠时生效。
]], [[
- Update Mio's speech text.

- Fix logic issue for the trigger condition of Moonlight Powder.
- Fix a crash.
- Add setbonus for Moonlight Shadow when Brightshade Helm is equipped.
- Fix a string typo.
- Tweak the recipe and duration of Moonlight Powder.
- New Item "Moonlight Powder":
  Grants an extra attack that ignores planar entity protection, only active when Enlightened Crown NOT EQUIPPED!
]])
description = zheng("版本: ", "Version: ") .. version ..
    zheng("\n\n更新内容:\n", "\n\nChangelog:\n") .. changelog .. "\n" ..
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
