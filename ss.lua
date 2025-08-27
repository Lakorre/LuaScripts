local MenuSize = vec2(500, 300)
local MenuStartCoords = vec2(500, 500) 
local TabsBarWidth = 0 -- The width of the tabs bar, height is assumed to be MenuHeight as it goes top to bottom
local SectionChildWidth = MenuSize.x - TabsBarWidth -- The total size for sections on the left hand side
local SectionsCount = 3 
local SectionsPadding = 10 -- pixels between each section (that makes SetionCount + 1 = total padding areas)
local MachoPaneGap = 10 -- Hard coded gap of accent at the top.
-- Therefore each section width must be:
local EachSectionWidth = (SectionChildWidth - (SectionsPadding * (SectionsCount + 1))) / SectionsCount
-- Now you have each sections absolute width, you can calculate their X coordinate and Y coordinate
local SectionOneStart = vec2(TabsBarWidth + (SectionsPadding * 1) + (EachSectionWidth * 0), SectionsPadding + MachoPaneGap)
local SectionOneEnd = vec2(SectionOneStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)
local SectionTwoStart = vec2(TabsBarWidth + (SectionsPadding * 2) + (EachSectionWidth * 1), SectionsPadding + MachoPaneGap)
local SectionTwoEnd = vec2(SectionTwoStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)
local SectionThreeStart = vec2(TabsBarWidth + (SectionsPadding * 3) + (EachSectionWidth * 2), SectionsPadding + MachoPaneGap)
local SectionThreeEnd = vec2(SectionThreeStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

-- Create our window, MenuStartCoords is where the menu starts
MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
MachoMenuSetAccent(MenuWindow, 137, 52, 235)
MachoMenuSetKeybind(MenuWindow, 0x78) -- F9 key

-- Add title text
MachoMenuSmallText(MenuWindow, "Welcome to Macho Menu!")

-- ===== First Section: Player Settings =====
FirstSection = MachoMenuGroup(MenuWindow, "Player Settings", SectionOneStart.x, SectionOneStart.y, SectionOneEnd.x, SectionOneEnd.y)

-- Heal Player
MachoMenuButton(FirstSection, "Heal Player", function()
    SetEntityHealth(PlayerPedId(), 200)
    MachoMenuNotification("Health", "Player fully healed!")
end)

-- Give Armor
MachoMenuButton(FirstSection, "Give Armor", function()
    SetPedArmour(PlayerPedId(), 100)
    MachoMenuNotification("Armor", "Full armor applied!")
end)

-- Player Name Input
local NameInputBox = MachoMenuInputbox(FirstSection, "Player Name", "Enter new name...")

-- Save Name Button
MachoMenuButton(FirstSection, "Save Name", function()
    local newName = MachoMenuGetInputbox(NameInputBox)
    if newName and newName ~= "" then
        MachoMenuNotification("Name Change", "Name saved: " .. newName)
    else
        MachoMenuNotification("Error", "Please enter a valid name!")
    end
end)

-- Weapon Dropdown
MachoMenuDropDown(FirstSection, "Give Weapon", function(selected)
    local weapons = {
        ["Assault Rifle"] = "WEAPON_ASSAULTRIFLE",
        ["Pistol"] = "WEAPON_PISTOL",
        ["Sniper Rifle"] = "WEAPON_SNIPERRIFLE",
        ["Shotgun"] = "WEAPON_PUMPSHOTGUN"
    }
    
    for name, hash in pairs(weapons) do
        if selected == name then
            GiveWeaponToPed(PlayerPedId(), GetHashKey(hash), 300, false, true)
            MachoMenuNotification("Weapons", "Given: " .. name)
            break
        end
    end
end, "Assault Rifle", "Pistol", "Sniper Rifle", "Shotgun")

-- Close Button
MachoMenuButton(FirstSection, "Close", function()
    MachoMenuDestroy(MenuWindow)
end)

-- ===== Second Section: Vehicle Settings =====
SecondSection = MachoMenuGroup(MenuWindow, "Vehicle Settings", SectionTwoStart.x, SectionTwoStart.y, SectionTwoEnd.x, SectionTwoEnd.y)

-- Repair Vehicle
MachoMenuButton(SecondSection, "Repair Vehicle", function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 then
        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
        MachoMenuNotification("Vehicle", "Vehicle repaired!")
    else
        MachoMenuNotification("Error", "You're not in a vehicle!")
    end
end)

-- Boost Vehicle
MachoMenuButton(SecondSection, "Boost Vehicle", function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 then
        SetVehicleEnginePowerMultiplier(vehicle, 2.0)
        MachoMenuNotification("Vehicle", "Vehicle boosted!")
    else
        MachoMenuNotification("Error", "You're not in a vehicle!")
    end
end)

-- Spawn Vehicle Dropdown
MachoMenuDropDown(SecondSection, "Spawn Vehicle", function(selected)
    local vehicles = {
        ["Adder"] = "adder",
        ["Zentorno"] = "zentorno",
        ["T20"] = "t20",
        ["Insurgent"] = "insurgent"
    }
    
    for name, model in pairs(vehicles) do
        if selected == name then
            local hash = GetHashKey(model)
            RequestModel(hash)
            while not HasModelLoaded(hash) do
                Wait(1)
            end
            
            local coords = GetEntityCoords(PlayerPedId())
            local heading = GetEntityHeading(PlayerPedId())
            local vehicle = CreateVehicle(hash, coords.x + 2.0, coords.y, coords.z, heading, true, false)
            
            MachoMenuNotification("Vehicle", "Spawned: " .. name)
            break
        end
    end
end, "Adder", "Zentorno", "T20", "Insurgent")

-- Vehicle Speed Slider
MachoMenuSlider(SecondSection, "Vehicle Speed", 100.0, 50.0, 300.0, "km/h", 0, function(value)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 then
        local speed = value / 3.6 -- Convert km/h to m/s
        SetVehicleForwardSpeed(vehicle, speed)
        MachoMenuNotification("Speed", "Speed set to: " .. value .. " km/h")
    end
end)

-- Close Button
MachoMenuButton(SecondSection, "Close", function()
    MachoMenuDestroy(MenuWindow)
end)

-- ===== Third Section: Advanced Settings =====
ThirdSection = MachoMenuGroup(MenuWindow, "Advanced Settings", SectionThreeStart.x, SectionThreeStart.y, SectionThreeEnd.x, SectionThreeEnd.y)

-- Server Info
MachoMenuButton(ThirdSection, "Server Info", function()
    MachoMenuNotification("Server Info", "Players online: " .. GetNumberOfPlayers())
end)

-- Dark Mode Checkbox
MachoMenuCheckbox(ThirdSection, "Dark Mode", 
    function() 
        MachoMenuNotification("Dark Mode", "Dark mode enabled")
    end,
    function() 
        MachoMenuNotification("Dark Mode", "Dark mode disabled")
    end
)

-- Check Logger State
MachoMenuButton(ThirdSection, "Check Logger", function()
    local state = MachoGetLoggerState()
    local stateText = ""
    if state == 0 then
        stateText = "All Disabled"
    elseif state == 3 then
        stateText = "All Enabled"
    else
        stateText = "Partially Enabled (" .. state .. ")"
    end
    MachoMenuNotification("Logger State", "Current: " .. stateText)
end)

-- Disable Logger
MachoMenuButton(ThirdSection, "Disable Logger", function()
    MachoSetLoggerState(0)
    MachoMenuNotification("Logger", "Logger disabled!")
end)

-- Enable Logger
MachoMenuButton(ThirdSection, "Enable Logger", function()
    MachoSetLoggerState(3)
    MachoMenuNotification("Logger", "Logger enabled!")
end)

-- Lock Logger (Permanent)
MachoMenuButton(ThirdSection, "LOCK Logger", function()
    MachoLockLogger()
    MachoMenuNotification("WARNING", "Logger permanently locked!")
end)

-- Get Selected Info
MachoMenuButton(ThirdSection, "Selected Info", function()
    local selectedPlayer = MachoMenuGetSelectedPlayer()
    local selectedVehicle = MachoMenuGetSelectedVehicle()
    MachoMenuNotification("Selection", "Player: " .. selectedPlayer .. " | Vehicle: " .. selectedVehicle)
end)

-- Close Button
MachoMenuButton(ThirdSection, "Close", function()
    MachoMenuDestroy(MenuWindow)
end)

-- Teleport Keybind (T key)
MachoMenuKeybind(ThirdSection, "Teleport Key", 0x54, function(key, toggle)
    if toggle then
        local coords = GetEntityCoords(PlayerPedId())
        SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z + 10.0)
        MachoMenuNotification("Teleport", "Teleported up 10m!")
    end
end)

-- Keyboard Input Handler
MachoOnKeyDown(function(key)
    if key == 0x70 then -- F1 key to close menu
        if MachoMenuIsOpen(MenuWindow) then
            MachoMenuDestroy(MenuWindow)
        end
    end
end)
