-- ====== Ali Menu Configuration (Independent) ======
local MenuSize_Ali = vec2(600, 400)
local MenuStartCoords_Ali = vec2(500, 300)
local TabsBarWidth_Ali = 150
local SectionsPadding_Ali = 10
local MachoPaneGap_Ali = 10

-- Section coordinates
local MainStart_Ali = vec2(TabsBarWidth_Ali + SectionsPadding_Ali, SectionsPadding_Ali + MachoPaneGap_Ali)
local MainEnd_Ali = vec2(MainStart_Ali.x + (MenuSize_Ali.x - TabsBarWidth_Ali - SectionsPadding_Ali*2), MenuSize_Ali.y - SectionsPadding_Ali)

-- Create independent Menu Window
local MenuWindow_Ali = MachoMenuWindow(MenuStartCoords_Ali.x, MenuStartCoords_Ali.y, MenuSize_Ali.x, MenuSize_Ali.y)
MachoMenuSetAccent(MenuWindow_Ali, 255, 255, 150)  -- أصفر فاتح

-- Main Section
local AliSection = MachoMenuGroup(MenuWindow_Ali, "Ali", MainStart_Ali.x, MainStart_Ali.y, MainEnd_Ali.x, MainEnd_Ali.y)

-- Heal + Armor Button
MachoMenuButton(AliSection, "Heal / Armor", function()
    local playerPed = PlayerPedId()
    if DoesEntityExist(playerPed) and not IsEntityDead(playerPed) then
        SetEntityHealth(playerPed, 200)
        SetPedArmour(playerPed, 100)
        MachoMenuNotification("Ali", "Health & Armor Restored")
    end
end)

-- Player IDs Toggle
local showPlayerIDs_Ali = false
MachoMenuCheckbox(AliSection, "Player IDs Toggle", 
    function() showPlayerIDs_Ali = true MachoMenuNotification("Ali", "Player IDs ON") end,
    function() showPlayerIDs_Ali = false MachoMenuNotification("Ali", "Player IDs OFF") end
)

-- Close Button
MachoMenuButton(AliSection, "Close Menu", function()
    MachoMenuDestroy(MenuWindow_Ali)
end)

-- Draw 3D Player IDs for this menu only
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if showPlayerIDs_Ali then
            for _, playerId in ipairs(GetActivePlayers()) do
                if playerId ~= PlayerId() then
                    local ped = GetPlayerPed(playerId)
                    local headCoords = GetPedBoneCoords(ped, 0x796e, 0.0, 0.0, 0.55)
                    local name = GetPlayerName(playerId)
                    local serverId = GetPlayerServerId(playerId)
                    local onScreen, _x, _y = World3dToScreen2d(headCoords.x, headCoords.y, headCoords.z + 0.3)
                    if onScreen then
                        SetTextScale(0.35, 0.35)
                        SetTextFont(4)
                        SetTextProportional(1)
                        SetTextOutline()
                        SetTextColour(255, 255, 255, 255)
                        SetTextEntry("STRING")
                        SetTextCentre(1)
                        AddTextComponentString(string.format("%s | ID: %d", name, serverId))
                        DrawText(_x, _y)
                    end
                end
            end
        end
    end
end)
