-- ====== VRP Menu ======
local MenuSizeVRP = vec2(600, 400)
local MenuStartCoordsVRP = vec2(600, 300)
local TabsBarWidthVRP = 150
local SectionsPaddingVRP = 10
local MachoPaneGapVRP = 10
local SectionChildWidthVRP = MenuSizeVRP.x - TabsBarWidthVRP
local EachSectionWidthVRP = (SectionChildWidthVRP - (SectionsPaddingVRP * 2)) / 1

local MainStartVRP = vec2(TabsBarWidthVRP + SectionsPaddingVRP, SectionsPaddingVRP + MachoPaneGapVRP)
local MainEndVRP = vec2(MainStartVRP.x + EachSectionWidthVRP, MenuSizeVRP.y - SectionsPaddingVRP)

local VRPWindow = MachoMenuWindow(MenuStartCoordsVRP.x, MenuStartCoordsVRP.y, MenuSizeVRP.x, MenuSizeVRP.y)
MachoMenuSetAccent(VRPWindow, 50, 150, 250) -- لون أزرق فاتح

-- ====== Global Variable ======
local showPlayerIDsVRP = false

-- ====== Main Section ======
local VRPSection = MachoMenuGroup(VRPWindow, "VRP Menu", MainStartVRP.x, MainStartVRP.y, MainEndVRP.x, MainEndVRP.y)

-- ====== Buttons ======
MachoMenuButton(VRPSection, "Revive Yourself (VRP)", function()
    TriggerEvent('vrp_ambulancejob:revive')
    MachoMenuNotification("VRP", "You have been revived!")
end)

MachoMenuButton(VRPSection, "Handcuff Player", function()
    TriggerEvent('vrp_misc:handcuff')
    MachoMenuNotification("VRP", "Handcuff triggered!")
end)

MachoMenuButton(VRPSection, "UnJail Player", function()
    TriggerEvent("vrp_jail:unJailPlayer")
    MachoMenuNotification("VRP", "Player released from jail!")
end)

-- ====== Player IDs Checkbox ======
MachoMenuCheckbox(VRPSection, "Show Player IDs", 
    function() showPlayerIDsVRP = true end,
    function() showPlayerIDsVRP = false end
)

-- ====== Draw Text 3D Function ======
function DrawText3D_VRP(x, y, z, text)
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

-- ====== Player IDs Thread for VRP ======
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if showPlayerIDsVRP then
            for _, playerId in ipairs(GetActivePlayers()) do
                if playerId ~= PlayerId() then
                    local ped = GetPlayerPed(playerId)
                    if ped and DoesEntityExist(ped) then
                        local headCoords = GetPedBoneCoords(ped, 0x796e, 0.0, 0.0, 0.55)
                        local name = GetPlayerName(playerId)
                        local serverId = GetPlayerServerId(playerId)
                        DrawText3D_VRP(headCoords.x, headCoords.y, headCoords.z + 0.3, string.format("%s | ID: %d", name, serverId))
                    end
                end
            end
        end
    end
end)
