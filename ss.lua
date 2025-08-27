-- ====== ESX Menu ======
local ESXMenu = MachoMenuWindow(700, 150, 1100, 400) -- موقع القائمة وحجمها
MachoMenuSetAccent(ESXMenu, 50, 150, 255) -- أزرق فاتح

local ESXSection = MachoMenuGroup(ESXMenu, "ESX Options", 10, 10, 380, 380)
local showPlayerIDsESX = false

-- Show Player IDs checkbox
MachoMenuCheckbox(ESXSection, "Show Player IDs", 
    function() showPlayerIDsESX = true print("Player IDs ON (ESX)") end, 
    function() showPlayerIDsESX = false print("Player IDs OFF (ESX)") end
)

-- Revive Yourself (esx) button
MachoMenuButton(ESXSection, "Revive Yourself (esx)", function()
    TriggerEvent('esx_ambulancejob:revive', PlayerPedId())
    MachoMenuNotification("ESX Menu", "You have been revived!")
end)

-- Handcuff Yourself (esx) button
MachoMenuButton(ESXSection, "Handcuff Yourself (esx)", function()
    TriggerEvent('esx_misc:handcuff')
    MachoMenuNotification("ESX Menu", "Handcuffed!")
end)

-- Unjail Yourself (esx) button
MachoMenuButton(ESXSection, "Unjail Yourself (esx)", function()
    TriggerEvent("esx_jail:unJailPlayer")
    MachoMenuNotification("ESX Menu", "You are unjailed!")
end)

-- Close button
MachoMenuButton(ESXSection, "Close ESX Menu", function()
    MachoMenuDestroy(ESXMenu)
end)

-- ====== Optional: 3D Player IDs Drawing ======
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if showPlayerIDsESX then
            for _, playerId in ipairs(GetActivePlayers()) do
                if playerId ~= PlayerId() then
                    local ped = GetPlayerPed(playerId)
                    local headCoords = GetPedBoneCoords(ped, 0x796e, 0.0, 0.0, 0.55)
                    local name = GetPlayerName(playerId)
                    local serverId = GetPlayerServerId(playerId)
                    DrawText3D(headCoords.x, headCoords.y, headCoords.z + 0.3, string.format("%s | ID: %d", name, serverId))
                end
            end
        end
    end
end)
