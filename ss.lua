-- ====== Menu Config ======
local MenuSize = vec2(1600, 900)        -- تقريبًا كامل الشاشة
local MenuStartCoords = vec2(50, 50)    -- بدء من الأعلى واليسار
local TabsBarWidth = 200                 -- عرض الـSidebar
local SectionsPadding = 20
local MachoPaneGap = 10
local SectionsCount = 3

local SectionChildWidth = MenuSize.x - TabsBarWidth
local EachSectionWidth = (SectionChildWidth - (SectionsPadding * (SectionsCount + 1))) / SectionsCount

-- ====== Section coordinates ======
local LeftStart  = vec2(TabsBarWidth + (SectionsPadding * 1) + (EachSectionWidth * 0), SectionsPadding + MachoPaneGap)
local LeftEnd    = vec2(LeftStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

local CenterStart = vec2(TabsBarWidth + (SectionsPadding * 2) + (EachSectionWidth * 1), SectionsPadding + MachoPaneGap)
local CenterEnd   = vec2(CenterStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

local RightStart = vec2(TabsBarWidth + (SectionsPadding * 3) + (EachSectionWidth * 2), SectionsPadding + MachoPaneGap)
local RightEnd   = vec2(RightStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

-- ====== Create Menu Window ======
local MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
MachoMenuSetAccent(MenuWindow, 255, 255, 150) -- أصفر فاتح

local isMenuOpen = true

-- ====== Sidebar ======
local Sidebar = MachoMenuGroup(MenuWindow, "Sidebar", 10, SectionsPadding + MachoPaneGap, TabsBarWidth - 10, MenuSize.y - SectionsPadding)
MachoMenuButton(Sidebar, "Player", function() print("[Menu] Player") end)
MachoMenuButton(Sidebar, "Vehicle", function() print("[Menu] Vehicle") end)
MachoMenuButton(Sidebar, "Settings", function() print("[Menu] Settings") end)
MachoMenuButton(Sidebar, "Close", function() 
    isMenuOpen = false 
    MachoMenuNotification("Menu", "Closed") 
end)

-- ====== Left Section ======
local LeftSection = MachoMenuGroup(MenuWindow, "Left Section", LeftStart.x, LeftStart.y, LeftEnd.x, LeftEnd.y)
MachoMenuButton(LeftSection, "Test Button 1", function() print("Left Button 1 pressed") end)
MachoMenuSlider(LeftSection, "Slider 1", 50, 0, 100, "%", 0, function(v) print("Slider 1: "..v) end)

-- ====== Center Section ======
local CenterSection = MachoMenuGroup(MenuWindow, "Center Section", CenterStart.x, CenterStart.y, CenterEnd.x, CenterEnd.y)
MachoMenuButton(CenterSection, "Test Button 2", function() print("Center Button 2 pressed") end)
MachoMenuCheckbox(CenterSection, "Checkbox 1", function() print("Checkbox ON") end, function() print("Checkbox OFF") end)

-- ====== Right Section ======
local RightSection = MachoMenuGroup(MenuWindow, "Right Section", RightStart.x, RightStart.y, RightEnd.x, RightEnd.y)
MachoMenuButton(RightSection, "Test Button 3", function() print("Right Button 3 pressed") end)
MachoMenuText(RightSection, "This is some text")

-- ====== Player IDs Checkbox ======
local showPlayerIDs = false
MachoMenuCheckbox(RightSection, "Show Player IDs", 
    function() 
        showPlayerIDs = true
        print("Player IDs: ON") 
    end, 
    function() 
        showPlayerIDs = false
        print("Player IDs: OFF") 
    end
)

-- ====== Draw 3D Player IDs ======
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

-- ====== Page Up Toggle ======
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(1, 0x21) then -- Page Up
            if isMenuOpen then
                isMenuOpen = false
                MachoMenuNotification("Menu", "Hidden")
            else
                isMenuOpen = true
                MachoMenuNotification("Menu", "Shown")
            end
        end
    end
end)
