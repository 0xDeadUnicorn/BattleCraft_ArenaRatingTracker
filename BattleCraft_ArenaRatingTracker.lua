local addonName = "ArenaRatingTracker"
local f = CreateFrame("Frame")
local inArena = false
local preRatings = {}

local COLORS = {
    PREFIX = "|cFFFF8100",
    BRACKET = "|cFFFFFFFF",
    RATING_VALUE = "|cFFFFCC00",
    CHANGES_TEXT = "|cFFFFFFFF",
    POSITIVE = "|cFF00FF00",
    NEGATIVE = "|cFFFF0000"
}

f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        local _, instanceType = GetInstanceInfo()
        
        if instanceType == "arena" then
            inArena = true
            preRatings = {}
            
            for i = 1, 3 do
                local teamName, _, rating = GetArenaTeam(i)
                preRatings[i] = rating or nil
            end
            
        elseif inArena then
            inArena = false
            local output = {}
            
            for i = 1, 3 do
                local teamName, _, newRating = GetArenaTeam(i)
                local oldRating = preRatings[i]
                
                if teamName and oldRating and newRating ~= oldRating then
                    local bracket = ({"2v2", "3v3", "5v5"})[i]
                    local diff = newRating - oldRating
                    
                    local msg = table.concat({
                        COLORS.BRACKET,
                        bracket,
                        " Rating|r ",
                        COLORS.RATING_VALUE,
                        newRating,
                        "|r ",
                        COLORS.CHANGES_TEXT,
                        "Changes|r ",
                        (diff >= 0 and COLORS.POSITIVE or COLORS.NEGATIVE),
                        (diff >= 0 and "+" or "")..diff,
                        "|r"
                    })
                    
                    table.insert(output, msg)
                end
            end
            
            if #output > 0 then
                for _, msg in ipairs(output) do
                    print(COLORS.PREFIX.."["..addonName.."]|r "..msg)
                end
            end
        end
    end
end)
