local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local SS = R:GetModule("SkadaSetting")

local isMoving = false
local timeout = 0
local skadaEventManager = CreateFrame("Frame")
local hideTimer
local inCombat = false

local function SkadaIn()
    for i, win in ipairs(Skada:GetWindows()) do
        if win:IsShown() then
            return true
        end
    end
    return false
end

local function MoveOut()
    timeout = 0
    for i, win in ipairs(Skada:GetWindows()) do
        if win:IsShown() then
            isMoving = true
            UIFrameFadeOut(win.bargroup, .7, 1, 0)
            skadaEventManager:SetScript("OnUpdate", function(self)
                if win.bargroup:GetAlpha() == 0 then
                    win:Hide()
                    skadaEventManager:SetScript("OnUpdate", nil)
                    isMoving = false
                end
            end)
        end
    end
    return true
end

local function MoveIn()
    timeout = 0
    for i, win in ipairs(Skada:GetWindows()) do
        if not win:IsShown() then
            isMoving = true
            win:Show()
            UIFrameFadeIn(win.bargroup, .7, 0, 1)
            skadaEventManager:SetScript("OnUpdate", function(self)
                if win.bargroup:GetAlpha() == 1 then
                    skadaEventManager:SetScript("OnUpdate", nil)
                    isMoving = false
                end
            end)
        end
    end
    return true
end

local function OnUpdateTimeCounter()
    timeout = timeout + 1
    if timeout > SS.db.skadahidetime then
        local checker
        checker = SS:ScheduleRepeatingTimer(function() 
            if not isMoving then 
                SS:CancelTimer(checker)
                MoveOut()
            end 
        end, 0.2)
        SS:CancelTimer(hideTime)
    end
end

local function TimeMoveOut(delay)
    if hideTime then
        SS:CancelTimer(hideTime)
    end
    if delay then
        timeout = 0
        if SS.db.skadahide and SkadaIn() then
            if SS.db.skadahide then
                hideTime = SS:ScheduleRepeatingTimer(OnUpdateTimeCounter, 1)
            end
        end
    else
        local checker
        checker = SS:ScheduleRepeatingTimer(function() 
            if not isMoving then 
                SS:CancelTimer(checker)
                MoveOut()
            end 
        end, 0.2)
    end
end

local function TimeMoveIn()
    if hideTime then
        SS:CancelTimer(hideTime)
    end
    local checker
    checker = SS:ScheduleRepeatingTimer(function() 
        if not isMoving then 
            SS:CancelTimer(checker)
            MoveIn()
            if not inCombat then
                TimeMoveOut(true)
            end
        end 
    end, 0.2)   
end

function SS:ToggleSkada()
    if SkadaIn() then
        TimeMoveOut(false)
    else
        TimeMoveIn()
    end
end

local function OnEvent(self, event, ...)
    if event == "PLAYER_REGEN_DISABLED" then
        inCombat = true
        TimeMoveIn(true)
    end

    if event == "PLAYER_REGEN_ENABLED" then
        inCombat = false
        TimeMoveOut(true)
    end
end

local function CreateToggle()
    local SkadaToggle = CreateFrame("Frame", "SkadaToggle", UIParent)
    SkadaToggle:CreatePanel("Default", 10, 140, "BOTTOMRIGHT",UIParent,"BOTTOMRIGHT", 0,30)
    SkadaToggle:SetAlpha(0)
    SkadaToggle:SetScript("OnEnter",function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 0, 0)
        GameTooltip:ClearLines()
        UIFrameFadeIn(self, 0.5, self:GetAlpha(), 1)
        if SkadaIn() then
            GameTooltip:AddLine(L["点击隐藏Skada"])
        else
            GameTooltip:AddLine(L["点击显示Skada"])
        end
        GameTooltip:Show()
    end)
    SkadaToggle:SetScript("OnLeave",function(self)
        UIFrameFadeOut(self, 0.5, self:GetAlpha(), 0)
        GameTooltip:Hide()
    end)
    SkadaToggle:SetScript("OnMouseDown", function(self, btn)
        if btn == "LeftButton" then
            SS:ToggleSkada()
        end
    end)
end

local function hoverWindows()
    for i, win in ipairs(Skada:GetWindows()) do
        win.bargroup:SetScript("OnEnter", function(self)
            if hideTime then
                SS:CancelTimer(hideTime)
            end
        end)

        win.bargroup:SetScript("OnLeave", function(self)
            TimeMoveOut(true)
        end)
    end
end

function SS:AutoHide()
    CreateToggle()
    hoverWindows()
    TimeMoveOut(true)

    skadaEventManager:RegisterEvent("PLAYER_REGEN_DISABLED")
    skadaEventManager:RegisterEvent("PLAYER_REGEN_ENABLED")
    skadaEventManager:SetScript("OnEvent", OnEvent)
end