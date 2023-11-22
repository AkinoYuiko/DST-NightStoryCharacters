local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local foodvalue =
{
    health = 10,
    sanity = 10,
    hunger = 15,
}

FOODTYPE.NIGHTMAREFUEL = "NIGHTMAREFUEL"
local Eater = require("components/eater")
local prefers_to_eat = Eater.PrefersToEat
function Eater:PrefersToEat(food)
    if food and food.components.nightfuel and self.inst:HasTag("nightfueleater") then
        return true
    end
    return prefers_to_eat(self, food)
end

local SCALE = 0.4
local function oneaten(food, eater)
    if eater.prefab == "miotan" and eater.StartBoost then
        eater:StartBoost(food.components.fuel.fuelvalue)
        local fx = SpawnPrefab("statue_transition")
        if fx then
            fx.entity:SetParent(eater.entity)
            fx.Transform:SetScale(SCALE, SCALE, SCALE)
        end
        eater.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
    end
end

AddPrefabPostInit("nightmarefuel", function(inst)
    if not TheWorld.ismastersim then return end
    inst:AddComponent("edible")
    inst.components.edible.healthvalue = foodvalue.health
    inst.components.edible.sanityvalue = foodvalue.sanity
    inst.components.edible.hungervalue = foodvalue.hunger
    inst.components.edible.foodtype = FOODTYPE.NIGHTMAREFUEL
    inst.components.edible:SetOnEatenFn(oneaten)

    inst:AddComponent("fuelpocketwatch")
    inst:AddComponent("nightfuel")
end)

-- if not Prefabs["horrorfuel"] then return end

AddPrefabPostInit("horrorfuel", function(inst)
    if not TheWorld.ismastersim then return end
    inst:AddComponent("edible")
    inst.components.edible.healthvalue = foodvalue.health * 2
    inst.components.edible.sanityvalue = foodvalue.sanity * 2
    inst.components.edible.hungervalue = foodvalue.hunger * 2
    inst.components.edible.foodtype = FOODTYPE.NIGHTMAREFUEL
    inst.components.edible:SetOnEatenFn(oneaten)

    inst:AddComponent("fuelpocketwatch")
    inst:AddComponent("nightfuel")
end)
