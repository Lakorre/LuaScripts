-- ====== Menu Config ======
local MenuSize = vec2(1200, 700)        -- Menu size
local MenuStartCoords = vec2(50, 50)   
local SidebarWidth = 180                
local SectionsPadding = 15
local TopGap = 10
local SectionsCount = 3

local SectionChildWidth = MenuSize.x - SidebarWidth
local EachSectionWidth = (SectionChildWidth - (SectionsPadding * (SectionsCount + 1))) / SectionsCount

-- ====== Section Coordinates ======
local LeftStart  = vec2(SidebarWidth + (SectionsPadding * 1) + (EachSectionWidth * 0), SectionsPadding + TopGap)
local LeftEnd    = vec2(LeftStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

local CenterStart = vec2(SidebarWidth + (SectionsPadding * 2) + (EachSectionWidth * 1), SectionsPadding + TopGap)
local CenterEnd   = vec2(CenterStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

local RightStart = vec2(SidebarWidth + (SectionsPadding * 3) + (EachSectionWidth * 2), SectionsPadding + TopGap)
local RightEnd   = vec2(RightStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

-- ====== Create Menu Window ======
local MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
MachoMenuSetAccent(MenuWindow, 255, 255, 150) -- Light yellow

-- ====== Section Toggles ======
local showLeftSection   = true
local showCenterSection = true
local showRightSection  = true
local showPlayerIDs     = false
local showVehicleBlips  = false

-- ====== Sidebar ======
local Sidebar = MachoMenuGroup(MenuWindow, "Sidebar", 10, SectionsPadding + TopGap, SidebarWidth - 10, MenuSize.y - SectionsPadding)
MachoMenuButton(Sidebar, "Toggle Left Section", function()
    showLeftSection = not showLeftSection
    MachoMenuNotification("Left Section", showLeftSection and "Shown" or "Hidden")
end)
MachoMenuButton(Sidebar, "Toggle Center Section", function()
    showCenterSection = not showCenterSection
    MachoMenuNotification("Center Section", showCenterSection and "Shown" or "Hidden")
end)
MachoMenuButton(Sidebar, "Toggle Right Section", function()
    showRightSection = not showRightSection
    MachoMenuNotification("Right Section", showRightSection and "Shown" or "Hidden")
end)
MachoMenuButton(Sidebar, "Toggle Player IDs", function()
    showPlayerIDs = not showPlayerIDs
    MachoMenuNotification("Player IDs", showPlayerIDs and "ON" or "OFF")
end)
MachoMenuCheckbox(Sidebar, "Show Nearby Vehicles", function()
    showVehicleBlips = true
    MachoMenuNotification("Vehicle Blips", "ON")
end, function()
    showVehicleBlips = false
    MachoMenuNotification("Vehicle Blips", "OFF")
    for _, blipID in ipairs(blips) do
        RemoveBlip(blipID)
    end
    blips = {}
end)

-- ====== Left Section ======
local LeftSection = MachoMenuGroup(MenuWindow, "Left Section", LeftStart.x, LeftStart.y, LeftEnd.x, LeftEnd.y)
MachoMenuButton(LeftSection, "Button 1", function() print("Left Button pressed") end)
MachoMenuSlider(LeftSection, "Slider 1", 50, 0, 100, "%", 0, function(v) print("Slider 1: "..v) end)

-- ====== Center Section ======
local CenterSection = MachoMenuGroup(MenuWindow, "Center Section", CenterStart.x, CenterStart.y, CenterEnd.x, CenterEnd.y)
MachoMenuButton(CenterSection, "Button 2", function() print("Center Button pressed") end)
MachoMenuCheckbox(CenterSection, "Checkbox 1", function() print("Checkbox ON") end, function() print("Checkbox OFF") end)

-- ====== Right Section ======
local RightSection = MachoMenuGroup(MenuWindow, "Right Section", RightStart.x, RightStart.y, RightEnd.x, RightEnd.y)
MachoMenuButton(RightSection, "Button 3", function() print("Right Button pressed") end)
MachoMenuText(RightSection, "Some text")

-- ====== 3D Text Function ======
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

-- ====== Draw Player IDs ======
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

-- ====== Vehicle Blips ======
local blips = {}
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if showVehicleBlips then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local nearbyCars = GetGamePool("CVehicle")

            for _, blipID in ipairs(blips) do
                RemoveBlip(blipID)
            end
            blips = {}

            for _, vehicle in ipairs(nearbyCars) do
                local vehicleCoords = GetEntityCoords(vehicle)
                local distance = #(playerCoords - vehicleCoords)

                if distance <= 500.0 then
                    local vehicleName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                    local blip = AddBlipForEntity(vehicle)
                    SetBlipSprite(blip, 225)
                    SetBlipColour(blip, 1)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString(vehicleName)
                    EndTextCommandSetBlipName(blip)
                    table.insert(blips, blip)
                end
            end
        else
            for _, blipID in ipairs(blips) do
                RemoveBlip(blipID)
            end
            blips = {}
        end
    end
end)

-- ====== Page Up Toggle Entire Menu ======
local isMenuOpen = true
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(1, 0x21) then -- Page Up
            isMenuOpen = not isMenuOpen
            MachoMenuNotification("Menu", isMenuOpen and "Shown" or "Hidden")
        end
    end
end)
