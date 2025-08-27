-- ====== Ali Menu ======
local AliMenu = MachoMenuWindow(200, 150, 600, 400)
MachoMenuSetAccent(AliMenu, 50, 200, 50) -- أخضر

local AliSection = MachoMenuGroup(AliMenu, "Ali Options", 10, 10, 580, 380)
local showPlayerIDs = false

-- Show Player IDs checkbox
MachoMenuCheckbox(AliSection, "Show Player IDs", 
    function() showPlayerIDs = true print("Player IDs ON") end, 
    function() showPlayerIDs = false print("Player IDs OFF") end
)

-- Revive Yourself (esx) button
MachoMenuButton(AliSection, "Revive Yourself (esx)", function()
    TriggerEvent('esx_ambulancejob:revive', PlayerPedId())
    MachoMenuNotification("Ali Menu", "You have been revived!")
end)

-- Close button
MachoMenuButton(AliSection, "Close Ali", function()
    MachoMenuDestroy(AliMenu)
end)

