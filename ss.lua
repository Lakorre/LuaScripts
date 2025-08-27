-- ====== ESX Menu ======
local MenuSize = vec2(600, 400)
local MenuStartCoords = vec2(500, 300)
local TabsBarWidth = 150
local SectionsPadding = 10
local MachoPaneGap = 10
local SectionsCount = 1
local SectionChildWidth = MenuSize.x - TabsBarWidth
local EachSectionWidth = (SectionChildWidth - (SectionsPadding * (SectionsCount + 1))) / SectionsCount

local MainStart = vec2(TabsBarWidth + SectionsPadding, SectionsPadding + MachoPaneGap)
local MainEnd = vec2(MainStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

-- ====== Create Menu Window ======
local ESXWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
MachoMenuSetAccent(ESXWindow, 50, 200, 50) -- أخضر فاتح

-- ====== Global Variables ======
local showPlayerIDsESX = false

-- ====== Main Section ======
local ESXSection = MachoMenuGroup(ESXWindow, "ESX Menu", MainStart.x, MainStart.y, MainEnd.x, MainEnd.y)

-- ====== Buttons ======
MachoMenuButton(ESXSection, "Revive Yourself (ESX)", function()
    TriggerEvent('esx_ambulancejob:revive')
    MachoMenuNotification("ESX", "You have been revived!")
end)

MachoMenuButton(ESXSection, "Handcuff Player", function()
    TriggerEvent('esx_misc:handcuff')
    MachoMenuNotification("ESX", "Handcuff triggered!")
end)

MachoMenuButton(ESXSection, "UnJail Player", function()
    TriggerEvent("esx_jail:unJailPlayer")
    MachoMenuNotification("ESX", "Player released from jail!")
end)

-- ====== Player IDs Checkbox ======
MachoMenuCheckbox(ESXSection, "Show Player IDs", 
    function() showPlayerIDsESX = true end,
    function() showPlayerIDsESX = false end
)

-- ====== Draw Text 3D Function ======
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

-- ====== Thread Show Player IDs ======
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
