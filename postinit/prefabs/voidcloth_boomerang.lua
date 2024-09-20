local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local function chain(target, duration)
    TheWorld.components.horrorchainmanager:AddMember(target, duration)
end

AddPrefabPostInit("voidcloth_boomerang_proj", function(inst)
    if not TheWorld.ismastersim then return end
    local onhit = inst.components.projectile.onhit
    inst.components.projectile:SetOnHitFn(function(_inst, attacker, target, ...)
        onhit(_inst, attacker, target, ...)
        if target and target:IsValid() and attacker and attacker.prefab == "civi" then
            chain(target, TUNING.CIVI_VOIDCLOTH_BOOMERANG_CHAIN_DURATION)
            local ents = TheWorld.components.horrorchainmanager:GetNearbyMembers(target)
            for _, ent in ipairs(ents) do
                chain(ent, TUNING.CIVI_VOIDCLOTH_BOOMERANG_CHAIN_DURATION)
            end
        end
    end)
end)
