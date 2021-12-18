local Badge = require "widgets/badge"
local UIAnim = require "widgets/uianim"

local SANITY_TINT = { 174 / 255, 21 / 255, 21 / 255, 1 }
local LUNACY_TINT = { 191 / 255, 232 / 255, 240, 255, 1 }

local function OnGhostDeactivated(inst)
    if inst.AnimState:IsCurrentAnimation("ghost_deactivate") then
        inst.widget:Hide()
    end
end

local function OnEffigyDeactivated(inst)
    if inst.AnimState:IsCurrentAnimation("effigy_deactivate") then
        inst.widget:Hide()
    end
end

local DummyBadge = Class(Badge, function(self, owner)
    Badge._ctor(self, nil, owner, SANITY_TINT, "status_sanity", nil, nil, true)

    self.sanitymode = SANITY_MODE_INSANITY

    self.topperanim = self.underNumber:AddChild(UIAnim())
    self.topperanim:GetAnimState():SetBank("status_meter")
    self.topperanim:GetAnimState():SetBuild("status_meter")
    self.topperanim:GetAnimState():PlayAnimation("anim")
    self.topperanim:GetAnimState():AnimateWhilePaused(false)
    self.topperanim:GetAnimState():SetMultColour(0, 0, 0, 1)
    self.topperanim:SetScale(1, -1, 1)
    self.topperanim:SetClickable(false)
    self.topperanim:GetAnimState():SetPercent("anim", 1)

    if self.circleframe ~= nil then
        self.circleframe:GetAnimState():Hide("frame")
    else
        self.anim:GetAnimState():Hide("frame")
    end

    self.circleframe2 = self.underNumber:AddChild(UIAnim())
    self.circleframe2:GetAnimState():SetBank("status_sanity")
    self.circleframe2:GetAnimState():SetBuild("status_sanity")
    self.circleframe2:GetAnimState():OverrideSymbol("frame_circle", "status_meter", "frame_circle")
    self.circleframe2:GetAnimState():Hide("FX")
    self.circleframe2:GetAnimState():PlayAnimation("frame")
    self.circleframe2:GetAnimState():AnimateWhilePaused(false)

    self.sanityarrow = self.underNumber:AddChild(UIAnim())
    self.sanityarrow:GetAnimState():SetBank("sanity_arrow")
    self.sanityarrow:GetAnimState():SetBuild("sanity_arrow")
    self.sanityarrow:GetAnimState():PlayAnimation("neutral")
    self.sanityarrow:GetAnimState():AnimateWhilePaused(false)
    self.sanityarrow:SetClickable(false)

    self.ghostanim = self.underNumber:AddChild(UIAnim())
    self.ghostanim:GetAnimState():SetBank("status_sanity")
    self.ghostanim:GetAnimState():SetBuild("status_sanity")
    self.ghostanim:GetAnimState():PlayAnimation("ghost_deactivate")
    self.ghostanim:GetAnimState():AnimateWhilePaused(false)
    self.ghostanim:Hide()
    self.ghostanim:SetClickable(false)
    self.ghostanim.inst:ListenForEvent("animover", OnGhostDeactivated)

    self.val = 100
    self.max = 100
    self.penaltypercent = 0
    self.ghost = false

    self.effigyanim = self.underNumber:AddChild(UIAnim())
    self.effigyanim:GetAnimState():SetBank("status_health")
    self.effigyanim:GetAnimState():SetBuild("status_health")
    self.effigyanim:GetAnimState():PlayAnimation("effigy_deactivate")
    self.effigyanim:Hide()
    self.effigyanim:SetClickable(false)
    self.effigyanim:GetAnimState():AnimateWhilePaused(false)
    self.effigyanim.inst:ListenForEvent("animover", OnEffigyDeactivated)
    self.effigy = false
    self.effigybreaksound = nil

    self.corrosives = {}
    self._onremovecorrosive = function(debuff)
        self.corrosives[debuff] = nil
    end
    self.inst:ListenForEvent("startcorrosivedebuff", function(owner, debuff)
        if self.corrosives[debuff] == nil then
            self.corrosives[debuff] = true
            self.inst:ListenForEvent("onremove", self._onremovecorrosive, debuff)
        end
    end, owner)

    self.hots = {}
    self._onremovehots = function(debuff)
        self.hots[debuff] = nil
    end
    self.inst:ListenForEvent("starthealthregen", function(owner, debuff)
        if self.hots[debuff] == nil then
            self.hots[debuff] = true
            self.inst:ListenForEvent("onremove", self._onremovehots, debuff)
        end
    end, owner)

    self.overtime_delta_history = {}
    self.inst:ListenForEvent("healthdelta", function(owner, data)
        if data and data.overtime then
            local delta = ( data.newpercent - data.oldpercent ) * TUNING.DUMMY_HEALTH
            table.insert(self.overtime_delta_history, {delta = delta, time = GetTime()})
        end
    end, owner)

    self:StartUpdating()
end)

function DummyBadge:ShowEffigy()
    if not self.effigy then
        self.effigy = true
        self.effigyanim:GetAnimState():PlayAnimation("effigy_activate")
        self.effigyanim:GetAnimState():PushAnimation("effigy_idle", false)
        self.effigyanim:Show()
    end
end

local function PlayEffigyBreakSound(inst, self)
    inst.task = nil
    if self:IsVisible() and inst.AnimState:IsCurrentAnimation("effigy_deactivate") then
        --Don't use FE sound since it's not a 2D sfx
        TheFocalPoint.SoundEmitter:PlaySound(self.effigybreaksound)
    end
end

function DummyBadge:HideEffigy()
    if self.effigy then
        self.effigy = false
        self.effigyanim:GetAnimState():PlayAnimation("effigy_deactivate")
        if self.effigyanim.inst.task ~= nil then
            self.effigyanim.inst.task:Cancel()
        end
        self.effigyanim.inst.task = self.effigyanim.inst:DoTaskInTime(7 * FRAMES, PlayEffigyBreakSound, self)
    end
end

function DummyBadge:DoTransition()
	local new_sanity_mode = self.owner.replica.sanity:GetSanityMode()
	if self.sanitymode ~= new_sanity_mode then
		self.sanitymode = new_sanity_mode
        if self.sanitymode == SANITY_MODE_INSANITY then
            self.backing:GetAnimState():ClearOverrideSymbol("bg")
            self.anim:GetAnimState():SetMultColour(unpack(SANITY_TINT))
            self.circleframe:GetAnimState():OverrideSymbol("icon", "status_sanity", "icon")
        else
            self.backing:GetAnimState():OverrideSymbol("bg", "status_sanity", "lunacy_bg")
            self.anim:GetAnimState():SetMultColour(unpack(LUNACY_TINT))
            self.circleframe:GetAnimState():OverrideSymbol("icon", "status_sanity", "lunacy_icon")
        end
	    Badge.SetPercent(self, self.val, self.max) -- refresh the animation
	end
	self.transition_task = nil
end

local function RemoveFX(fxinst)
    fxinst.widget:Kill()
end

function DummyBadge:SpawnTransitionFX(anim)
    if self.parent ~= nil then
        local fx = self.parent:AddChild(UIAnim())
        fx:SetPosition(self:GetPosition())
        fx:SetClickable(false)
        fx.inst:ListenForEvent("animover", RemoveFX)
        fx:GetAnimState():SetBank("status_sanity")
        fx:GetAnimState():SetBuild("status_sanity")
        fx:GetAnimState():Hide("frame")
        fx:GetAnimState():PlayAnimation(anim)
    end
end

function DummyBadge:SetPercent(val, max, penaltypercent)
    self.val = val
    self.max = max
    Badge.SetPercent(self, self.val, self.max)

    self.penaltypercent = penaltypercent or 0
    self.topperanim:GetAnimState():SetPercent("anim", 1 - self.penaltypercent)

	local sanity = self.owner.replica.sanity

	if sanity:GetSanityMode() ~= self.sanitymode then
		if self.transition_task ~= nil then
			self.transition_task:Cancel()
			self.transition_task = nil
			self:DoTransition()
		end
		if self:IsVisible() then
            if self.sanitymode ~= SANITY_MODE_INSANITY then
                self.circleframe2:GetAnimState():PlayAnimation("transition_sanity")
                self:SpawnTransitionFX("transition_sanity")
            else
                self.circleframe2:GetAnimState():PlayAnimation("transition_lunacy")
                self:SpawnTransitionFX("transition_lunacy")
            end
			self.circleframe2:GetAnimState():PushAnimation("frame", false)
			self.transition_task = self.owner:DoTaskInTime(6 * FRAMES, function() self:DoTransition() end)
		else
			self:DoTransition()
		end
    end
end

function DummyBadge:PulseGreen()
	if self.sanitymode == SANITY_MODE_LUNACY then
		Badge.PulseRed(self)
	else
		Badge.PulseGreen(self)
	end
end

function DummyBadge:PulseRed()
	if self.sanitymode == SANITY_MODE_LUNACY then
		Badge.PulseGreen(self)
	else
		Badge.PulseRed(self)
	end
end

local RATE_SCALE_ANIM =
{
    [RATE_SCALE.INCREASE_HIGH] = "arrow_loop_increase_most",
    [RATE_SCALE.INCREASE_MED] = "arrow_loop_increase_more",
    [RATE_SCALE.INCREASE_LOW] = "arrow_loop_increase",
    [RATE_SCALE.DECREASE_HIGH] = "arrow_loop_decrease_most",
    [RATE_SCALE.DECREASE_MED] = "arrow_loop_decrease_more",
    [RATE_SCALE.DECREASE_LOW] = "arrow_loop_decrease",
    [RATE_SCALE.NEUTRAL] = "neutral",
}


local last_update_dt = 0
local current_dt = 0

-- local hunger_rate = - TUNING.WILSON_HEALTH / TUNING.STARVE_KILL_TIME * FRAMES
-- local temperature_rate = - TUNING.WILSON_HEALTH / TUNING.FREEZING_KILL_TIME

function DummyBadge:OnUpdate(dt)
    if TheNet:IsServerPaused() then return end

    self.overtime_delta = 0
    
    local time = GetTime() - 1

    local t = self.overtime_delta_history
    local j = 1

    for i = 1, #t do
        local val = t[i]
        if val.time < time then
            t[i] = nil
        else
            self.overtime_delta = self.overtime_delta + val.delta
            if i ~= j then
                t[j] = val
                t[i] = nil
            end
            j = j + 1
        end
    end

    local anim = RATE_SCALE_ANIM[
        (self.overtime_delta > .2 and RATE_SCALE.INCREASE_HIGH) or
        (self.overtime_delta > .1 and RATE_SCALE.INCREASE_MED) or
        (self.overtime_delta > .01 and RATE_SCALE.INCREASE_LOW) or
        (self.overtime_delta < -.3 and RATE_SCALE.DECREASE_HIGH) or
        (self.overtime_delta < -.1 and RATE_SCALE.DECREASE_MED) or
        (self.overtime_delta < -.02 and RATE_SCALE.DECREASE_LOW) or
        RATE_SCALE.NEUTRAL
    ]

    if self.arrowdir ~= anim then
        self.arrowdir = anim
        self.sanityarrow:GetAnimState():PlayAnimation(anim, true)
    end

    local ghost = self.owner.replica.sanity and self.owner.replica.sanity:IsGhostDrain() or false
    if self.ghost ~= ghost then
        self.ghost = ghost
        if ghost then
            self.ghostanim:GetAnimState():PlayAnimation("ghost_activate")
            self.ghostanim:GetAnimState():PushAnimation("ghost_idle", true)
            self.ghostanim:Show()
        else
            self.ghostanim:GetAnimState():PlayAnimation("ghost_deactivate")
        end
    end
end

return DummyBadge