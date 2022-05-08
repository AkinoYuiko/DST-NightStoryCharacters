local function loc(t)
    t.zhr = t.zh
    t.zht = t.zht or t.zh
    t.ch = t.ch or t.zh
    return t[locale] or t.en
end

local function zh_en(a, b)
    return loc({
        zh = a,
        en = b
    })
end

version = "1.29.15"
-- basic info --
name = zh_en("暗夜故事集", "Night Stories")
author = zh_en("丁香女子学校", "Civi, Tony, LSSSS")
description = zh_en(
    -- zh
"版本: " .. version .. "\n\n" .. [[更新内容:
- 移除了IA配方部分的兼容处理，现交由IA:Deluxe Addon处理。

- 修复注能图腾动作的一个错误。
...
- 新道具：黑水晶、白水晶、友爱戒指、注能黑暗图腾、注能光明图腾。
- 新增配方：黑水晶、白水晶、友爱戒指。
- 移除配方：黑宝石、白宝石、黑勾玉、白勾玉、黑暗护符、光明护符。

“黑夜将至，你准备好了吗？”]],
    -- en
"[Version: " .. version .. "\n\n" ..[[Changelog:
- Move compatibility work with IA to IA:Deluxe Addon.

- Fix an issue when socketing Crystals into Ring of Friendship.
...
- New items: Dark Crystal, Light Cystal, Ring of Friendship, Charged Dark Totem, Charged Light Totem.
- New recipes: Dark Crystal, Light Crystal, Ring of Friendship.
- Remove recipes: Dark Gem, Light Gem, Dark Magatama, Light Magatama, Dark Amulet, Light Amulet.

"Night is coming, aren't you ready yet?"]]
)

forumthread = ""
api_version = 10
dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
all_clients_require_mod = true

icon_atlas = "images/modicon.xml"
icon = "modicon.tex"

priority = 25
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
