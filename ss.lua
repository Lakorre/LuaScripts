-- ====== Ali Menu Configuration ======
local MenuSize = vec2(600, 400)
local MenuStartCoords = vec2(500, 300)
local TabsBarWidth = 150
local SectionsPadding = 10
local MachoPaneGap = 10
local SectionsCount = 1
local SectionChildWidth = MenuSize.x - TabsBarWidth
local EachSectionWidth = SectionChildWidth - (SectionsPadding * 2)

-- ====== Section coordinates ======
local MainStart = vec2(TabsBarWidth + SectionsPadding, SectionsPadding + MachoPaneGap)
local MainEnd = vec2(MainStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

-- ====== Create Menu Window ======
local MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
MachoMenuSetAccent(MenuWindow, 255, 255, 150)  -- أصفر فاتح

-- ====== Main Section ======
local AliSection = MachoMenuGroup(MenuWindow, "Ali", MainStart.x, MainStart.y, MainEnd.x, MainEnd.y)

-- زر مستقل لإعادة الصحة والدرع
MachoMenuButton(AliSection, "Heal / Armor", function()
    local playerPed = PlayerPedId()
    if DoesEntityExist(playerPed) and not IsEntityDead(playerPed) then
        SetEntityHealth(playerPed, 200)
        SetPedArmour(playerPed, 100)
        MachoMenuNotification("Ali", "Health & Armor Restored")
    end
end)

-- Toggle ON/OFF for player IDs
local showPlayerIDs = false
MachoMenuCheckbox(AliSection, "Player IDs Toggle", 
    function() showPlayerIDs = true MachoMenuNotification("Ali", "Player IDs ON") end,
    function() showPlayerIDs = false MachoMenuNotification("Ali", "Player IDs OFF") end
)

-- زر Close لإغلاق القائمة
MachoMenuButton(AliSection, "Close Menu", function()
    MachoMenuDestroy(MenuWindow)
end)

-- ====== Draw 3D Player IDs ======
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local camCoords = GetGameplayCamCoords()
    local distance = #(vector3(camCoords.x, camCoords.y, camCoords.z) - vector3(x, y, z))
    local scale = math.max(0.35 - (distance / 300), 0.30)
    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextOutline()
        SetTextColour(255, 255, 255, 255)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if showPlayerIDs then
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
