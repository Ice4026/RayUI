local R, L, P = unpack(select(2, ...)) --Import: Engine, Locales, ProfileDB, local
local SS = R:NewModule("SkadaSetting", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0", "AceConsole-3.0")
SS.modName = L["Skada设置"]

function SS:GetOptions()
    local options = {
        skadahide = {
            order = 5,
            name = L["非战斗时隐藏"],
            type = "toggle",
            -- disabled = function() return not S.db.skada end,
        },
        skadahidetime = {
            order = 6,
            name = L["Skada自动隐藏时间"],
            desc = L["设置脱战后多少秒隐藏"],
            type = "range",
            min = 5, max = 60, step = 1,
            disabled = function() return not self.db.skadahide end,
        },
    }
    return options
end

function SS:ADDON_LOADED(event, addon) end

function SS:PLAYER_ENTERING_WORLD(event, addon)
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    self:AutoHide()
end

function SS:Initialize()
    SS:RegisterEvent("ADDON_LOADED")
    SS:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function SS:Info()
    return L["|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|rSkada设置模块."]
end

R:RegisterModule(SS:GetName())