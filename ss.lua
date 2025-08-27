-- ====== Layout ======
local MenuSize        = vec2(900, 500)
local MenuStartCoords = vec2(480, 240)

local TabsBarWidth    = 170
local SectionsPadding = 10
local MachoPaneGap    = 10
local SectionsCount   = 2

local SectionChildWidth = MenuSize.x - TabsBarWidth
local EachSectionWidth  = (SectionChildWidth - (SectionsPadding * (SectionsCount + 1))) / SectionsCount

local LeftStart  = vec2(TabsBarWidth + (SectionsPadding * 1) + (EachSectionWidth * 0), SectionsPadding + MachoPaneGap)
local LeftEnd    = vec2(LeftStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

local RightStart = vec2(TabsBarWidth + (SectionsPadding * 2) + (EachSectionWidth * 1), SectionsPadding + MachoPaneGap)
local RightEnd   = vec2(RightStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

local SidebarStart = vec2(SectionsPadding, SectionsPadding + MachoPaneGap)
local SidebarEnd   = vec2(TabsBarWidth - SectionsPadding, MenuSize.y - SectionsPadding)

-- ====== Window ======
MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
MachoMenuSetAccent(MenuWindow, 255, 215, 0)  -- أصفر

-- ====== Sidebar ======
local Sidebar = MachoMenuGroup(MenuWindow, "Aura", SidebarStart.x, SidebarStart.y, SidebarEnd.x, SidebarEnd.y)
MachoMenuButton(Sidebar, "Player",   function() print("[Aura] Player") end)
MachoMenuButton(Sidebar, "Vehicle",  function() print("[Aura] Vehicle") end)
MachoMenuButton(Sidebar, "Players",  function() print("[Aura] Players") end)
MachoMenuButton(Sidebar, "CFW",      function() print("[Aura] CFW") end)
MachoMenuButton(Sidebar, "VRP",      function() print("[Aura] VRP") end)
MachoMenuButton(Sidebar, "ESX",      function() print("[Aura] ESX") end)
MachoMenuButton(Sidebar, "Tools",    function() print("[Aura] Tools") end)
MachoMenuButton(Sidebar, "Settings", function() print("[Aura] Settings") end)
MachoMenuButton(Sidebar, "Close",    function() MachoMenuDestroy(MenuWindow) end)

-- ====== Left Column ======
local LeftCol = MachoMenuGroup(MenuWindow, "Vehicle & Self", LeftStart.x, LeftStart.y, LeftEnd.x, LeftEnd.y)

local r = MachoMenuSlider(LeftCol, "Red",   255, 0, 255, "", 0, function(v) print("R="..v) end)
local g = MachoMenuSlider(LeftCol, "Green", 255, 0, 255, "", 0, function(v) print("G="..v) end)
local b = MachoMenuSlider(LeftCol, "Blue",  255, 0, 255, "", 0, function(v) print("B="..v) end)

local flipIndex = 1
MachoMenuDropDown(LeftCol, "Select Flip", function(idx)
    flipIndex = idx
    print("Flip selected: "..idx)
end, "Flip 1", "Flip 2", "Flip 3")

MachoMenuButton(LeftCol, "Flip", function()
    print("Flip pressed (index "..flipIndex..")")
end)

MachoMenuButton(LeftCol, "Hijack Nearest Vehicle", function()
    print("Hijack nearest vehicle")
end)

MachoMenuButton(LeftCol, "Remote Car", function()
    print("Remote car toggled")
end)

MachoMenuText(LeftCol, "Flip keybind (Hold): NONE")
MachoMenuText(LeftCol, "Hijack keybind (Hold): NONE")

-- ====== Right Column ======
local RightCol = MachoMenuGroup(MenuWindow, "Vehicle & CheckBox", RightStart.x, RightStart.y, RightEnd.x, RightEnd.y)

MachoMenuCheckbox(RightCol, "Steal Car", function() print("Steal Car: ON") end, function() print("Steal Car: OFF") end)
MachoMenuCheckbox(RightCol, "Seat Belt", function() print("Seat Belt: ON") end, function() print("Seat Belt: OFF") end)
MachoMenuCheckbox(RightCol, "Rainbow Vehicle Colour", function() print("Rainbow: ON") end, function() print("Rainbow: OFF") end)
MachoMenuCheckbox(RightCol, "Horn Boost", function() print("Horn Boost: ON") end, function() print("Horn Boost: OFF") end)
MachoMenuCheckbox(RightCol, "Vehicle Jump (SPACE)", function() print("Jump: ON") end, function() print("Jump: OFF") end)
MachoMenuCheckbox(RightCol, "Ghost Vehicle (Ground-Only Collisions)", function() print("Ghost: ON") end, function() print("Ghost: OFF") end)
MachoMenuCheckbox(RightCol, "Vehicle Godmode", function() print("Godmode: ON") end, function() print("Godmode: OFF") end)
MachoMenuSlider(RightCol, "Vehicle Invisibility Level", 255, 0, 255, "", 0, function(v) print("Invisibility level: "..v) end)
MachoMenuCheckbox(RightCol, "Vehicle Invisible", function() print("Invisible: ON") end, function() print("Invisible: OFF") end)
MachoMenuText(RightCol, "Vehicle Invisible Key (Hold): NONE")
MachoMenuSlider(RightCol, "Shift Boost Speed", 50, 0, 200, "km/h", 0, function(v) print("Shift Boost speed: "..v.." km/h") end)
MachoMenuCheckbox(RightCol, "Shift Boost", function() print("Shift Boost: ON") end, function() print("Shift Boost: OFF") end)

-- ====== Player ID 3D Display ======
local showPlayerIDs = false

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

-- Checkbox للتحكم بعرض Player IDs
MachoMenuCheckbox(RightCol, "Show Player IDs",
    function() showPlayerIDs = true print("Show Player IDs: ON") end,
    function() showPlayerIDs = false print("Show Player IDs: OFF") end
)
