-- ====== Global Variables ======
local showPlayerIDsESX = false
local showPlayerIDsVRP = false

-- ====== Create ESX Menu ======
local MenuSize = vec2(600, 400)
local MenuStartCoords = vec2(500, 300)
local TabsBarWidth = 150
local SectionsPadding = 10
local MachoPaneGap = 10
local SectionChildWidth = MenuSize.x - TabsBarWidth
local EachSectionWidth = (SectionChildWidth - (SectionsPadding * 2)) / 1

local MainStart = vec2(TabsBarWidth + SectionsPadding, SectionsPadding + MachoPaneGap)
local MainEnd = vec2(MainStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

-- ====== ESX Window ======
local ESXWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
MachoMenuSetAccent(ESXWindow, 50, 200, 50)
local ESXSection = MachoMenuGroup(ESXWindow, "ESX Menu", MainStart.x, MainStart.y, MainEnd.x, MainEnd.y)

-- ====== ESX Buttons ======
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
MachoMenuCheckbox(ESXSection, "Show Player IDs", 
    function() showPlayerIDsESX = true end,
    function() showPlayerIDsESX = false end
)

-- ====== VRP Window ======
local VRPWindow = MachoMenuWindow(MenuStartCoords.x + 650, MenuStartCoords.y, MenuSize.x, MenuSize.y) -- يفتح جنب ESX
MachoMenuSetAccent(VRPWindow, 50, 150, 200)
local VRPSection = MachoMenuGroup(VRPWindow, "VRP Menu", MainStart.x, MainStart.y, MainEnd.x, MainEnd.y)

-- ====== VRP Buttons ======
MachoMenuButton(VRPSection, "Revive Yourself (VRP)", function()
    TriggerEvent('vrp_ambulance:revive')
    MachoMenuNotification("VRP", "You have been revived (VRP)!")
end)
MachoMenuButton(VRPSection, "Handcuff Player (VRP)", function()
    TriggerEvent('vrp_misc:handcuff')
    MachoMenuNotification("VRP", "Handcuff triggered (VRP)!")
end)
MachoMenuCheckbox(VRPSection, "Show Player IDs (VRP)", 
    function() showPlayerIDsVRP = true end,
    function() showPlayerIDsVRP = false end
)

-- ====== VRP Window ======
local VRPWindow = MachoMenuWindow(MenuStartCoords.x + 650, MenuStartCoords.y, MenuSize.x, MenuSize.y) -- يفتح جنب ESX
MachoMenuSetAccent(VRPWindow, 50, 150, 200)
local VRPSection = MachoMenuGroup(VRPWindow, "VRP Menu", MainStart.x, MainStart.y, MainEnd.x, MainEnd.y)

-- ====== VRP Buttons ======
MachoMenuButton(VRPSection, "Revive Yourself (VRP)", function()
    TriggerEvent('vrp_ambulance:revive')
    MachoMenuNotification("VRP", "You have been revived (VRP)!")
end)
MachoMenuButton(VRPSection, "Handcuff Player (VRP)", function()
    TriggerEvent('vrp_misc:handcuff')
    MachoMenuNotification("VRP", "Handcuff triggered (VRP)!")
end)
MachoMenuCheckbox(VRPSection, "Show Player IDs (VRP)", 
    function() showPlayerIDsVRP = true end,
    function() showPlayerIDsVRP = false end
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

-- ====== Player IDs Thread ======
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        -- ESX Player IDs
        if showPlayerIDsESX then
            for _, playerId in ipairs(GetActivePlayers()) do
                if playerId ~= PlayerId() then
                    local ped = GetPlayerPed(playerId)
                    if ped and DoesEntityExist(ped) then
                        local headCoords = GetPedBoneCoords(ped, 0x796e, 0.0, 0.0, 0.55)
                        local name = GetPlayerName(playerId)
                        local serverId = GetPlayerServerId(playerId)
                        DrawText3D(headCoords.x, headCoords.y, headCoords.z + 0.3, string.format("%s | ID: %d", name, serverId))
                    end
                end
            end
        end
        -- VRP Player IDs
        if showPlayerIDsVRP then
            for _, playerId in ipairs(GetActivePlayers()) do
                if playerId ~= PlayerId() then
                    local ped = GetPlayerPed(playerId)
                    if ped and DoesEntityExist(ped) then
                        local headCoords = GetPedBoneCoords(ped, 0x796e, 0.0, 0.0, 0.55)
                        local name = GetPlayerName(playerId)
                        local serverId = GetPlayerServerId(playerId)
                        DrawText3D(headCoords.x, headCoords.y, headCoords.z + 0.5, string.format("VRP: %s | ID: %d", name, serverId))
                    end
                end
            end
        end
    end
end)

