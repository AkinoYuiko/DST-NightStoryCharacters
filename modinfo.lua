local function loc(t)
    t.zht = t.zht or t.zh
    return t[locale] or t.en
end

local function zh_en(a, b)
    return loc({
        zh = a,
        en = b
    })
end

version = "1.32.1"
-- basic info --
name = zh_en("暗夜故事集", "Night Stories")
author = zh_en("丁香女子学校", "Civi, Tony, LSSSS")
changelog = zh_en([[
- 修复了皮肤中缺失和错误的 SWAP_ICON。
- 现在使用 Mods In Menu 时可以在物品收藏中看到这些物品皮肤了。
- 移除皮肤：发光的心，绿色的心。

- 新增雕塑：真头痛鸭。仅在秋天第一天可以在陶轮制作。
]], [[
- Fix mistaken and missing SWAP_ICON in all skin builds.
- Improve compatibility with Mods In Menu. Now you can see all prefab skins.
- Remove skin: "Glowing Heart" and "Green Heart".

- New Figure: Headuck. Only available on Autumn 1st.
]])
description = zh_en("版本: ", "Version: ") .. version ..
    zh_en("\n\n更新内容:\n", "\n\nChangelog:\n") .. changelog .. "\n" ..
    zh_en("“黑夜将至，你准备好了吗？”", "\"Night is coming, aren't you ready yet?\"")

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
