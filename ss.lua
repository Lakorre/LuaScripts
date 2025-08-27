-- ====== Menu Config ======
local MenuSize = vec2(600, 350)
local MenuStartCoords = vec2(500, 500)
local TabsBarWidth = 150
local SectionsPadding = 10
local MachoPaneGap = 10
local SectionsCount = 2 -- محتوى يمين ويسار
local SectionChildWidth = MenuSize.x - TabsBarWidth
local EachSectionWidth = (SectionChildWidth - (SectionsPadding * (SectionsCount + 1))) / SectionsCount

-- Column coordinates
local LeftStart  = vec2(TabsBarWidth + (SectionsPadding * 1) + (EachSectionWidth * 0), SectionsPadding + MachoPaneGap)
local LeftEnd    = vec2(LeftStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

local RightStart = vec2(TabsBarWidth + (SectionsPadding * 2) + (EachSectionWidth * 1), SectionsPadding + MachoPaneGap)
local RightEnd   = vec2(RightStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

-- Sidebar coordinates
local SidebarStart = vec2(SectionsPadding, SectionsPadding + MachoPaneGap)
local SidebarEnd   = vec2(TabsBarWidth - SectionsPadding, MenuSize.y - SectionsPadding)

-- ====== Create Window ======
local MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
MachoMenuSetAccent(MenuWindow, 255, 215, 0) -- Aura-style yellow

-- ====== Sidebar ======
local Sidebar = MachoMenuGroup(MenuWindow, "Menu", SidebarStart.x, SidebarStart.y, SidebarEnd.x, SidebarEnd.y)
MachoMenuButton(Sidebar, "Player", function() print("[Aura] Player") end)
MachoMenuButton(Sidebar, "Vehicle", function() print("[Aura] Vehicle") end)
MachoMenuButton(Sidebar, "Players", function() print("[Aura] Players") end)
MachoMenuButton(Sidebar, "Tools", function() print("[Aura] Tools") end)
MachoMenuButton(Sidebar, "Settings", function() print("[Aura] Settings") end)
MachoMenuButton(Sidebar, "Close", function() MachoMenuDestroy(MenuWindow) end)

-- ====== Left Column ======
local LeftCol = MachoMenuGroup(MenuWindow, "Vehicle & Self", LeftStart.x, LeftStart.y, LeftEnd.x, LeftEnd.y)
local r = MachoMenuSlider(LeftCol, "Red", 255, 0, 255, "", 0, function(v) print("R="..v) end)
local g = MachoMenuSlider(LeftCol, "Green", 255, 0, 255, "", 0, function(v) print("G="..v) end)
local b = MachoMenuSlider(LeftCol, "Blue", 255, 0, 255, "", 0, function(v) print("B="..v) end)
local flipIndex = 1
MachoMenuDropDown(LeftCol, "Select Flip", function(idx) flipIndex = idx print("Flip selected: "..idx) end, "Flip 1", "Flip 2", "Flip 3")
MachoMenuButton(LeftCol, "Flip", function() print("Flip pressed (index "..flipIndex..")") end)
MachoMenuButton(LeftCol, "Hijack Nearest Vehicle", function() print("Hijack nearest vehicle") end)
MachoMenuButton(LeftCol, "Remote Car", function() print("Remote car toggled") end)
MachoMenuText(LeftCol, "Flip keybind (Hold): NONE")
MachoMenuText(LeftCol, "Hijack keybind (Hold): NONE")

-- ====== Right Column ======
local RightCol = MachoMenuGroup(MenuWindow, "Vehicle & CheckBox", RightStart.x, RightStart.y, RightEnd.x, RightEnd.y)
local showPlayerIDs = false
MachoMenuCheckbox(RightCol, "Show Player IDs", function() showPlayerIDs = true print("Player IDs ON") end, function() showPlayerIDs = false print("Player IDs OFF") end)
MachoMenuCheckbox(RightCol, "Seat Belt", function() print("Seat Belt ON") end, function() print("Seat Belt OFF") end)
MachoMenuSlider(RightCol, "Vehicle Invisibility Level", 255, 0, 255, "", 0, function(v) print("Invisibility level: "..v) end)
MachoMenuText(RightCol, "Vehicle Invisible Key (Hold): NONE")
MachoMenuSlider(RightCol, "Shift Boost Speed", 50, 0, 200, "km/h", 0, function(v) print("Shift Boost speed: "..v.." km/h") end)

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

-- ====== Page Up Toggle ======
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(1, 0x21) then -- Page Up
            if MenuWindow then
                print("Page Up pressed - menu is already created") 
                -- إذا تريد إعادة فتح المنيو يمكنك استخدام Notification أو Keybind بدلاً من Destroy
                MachoMenuNotification("Page Up", "Menu toggle pressed")
            end
        end
    end
end)
