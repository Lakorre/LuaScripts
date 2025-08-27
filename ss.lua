-- إنشاء النافذة الرئيسية
local MainWindow = MachoMenuWindow(100.0, 100.0, 500.0, 400.0)

-- تعيين لون مميز (أزرق)
MachoMenuSetAccent(MainWindow, 0.2, 0.5, 1.0)

-- تعيين مفتاح الاختصار (F9)
MachoMenuSetKeybind(MainWindow, 0x78)

-- إضافة عنوان صغير
MachoMenuSmallText(MainWindow, "Welcome to Macho Menu!")

-- إنشاء التبويبات
local Tab1 = MachoMenuAddTab(MainWindow, "General Settings")
local Tab2 = MachoMenuAddTab(MainWindow, "Player")
local Tab3 = MachoMenuAddTab(MainWindow, "Vehicle")

-- ===== Tab 1: General Settings =====
local Tab1Group1 = MachoMenuGroup(Tab1, "Server Settings", 10.0, 10.0, 480.0, 120.0)
local Tab1Group2 = MachoMenuGroup(Tab1, "Logger Protection", 10.0, 140.0, 480.0, 100.0)

-- Server info button
MachoMenuButton(Tab1Group1, "Server Info", function()
    MachoMenuNotification("Server Info", "Players online: " .. GetNumberOfPlayers())
end)

-- Dark mode checkbox
MachoMenuCheckbox(Tab1Group1, "Enable Dark Mode", 
    function() 
        MachoMenuNotification("Dark Mode", "Dark mode enabled")
    end,
    function() 
        MachoMenuNotification("Dark Mode", "Dark mode disabled")
    end
)

-- Volume slider
MachoMenuSlider(Tab1Group1, "Volume Level", 50.0, 0.0, 100.0, "%", 0, function(value)
    MachoMenuNotification("Volume", "Volume set to: " .. value .. "%")
end)

-- ===== Logger Protection Functions =====
-- Check logger state button
MachoMenuButton(Tab1Group2, "Check Logger State", function()
    local state = MachoGetLoggerState()
    local stateText = ""
    if state == 0 then
        stateText = "All Disabled"
    elseif state == 3 then
        stateText = "All Enabled"
    else
        stateText = "Partially Enabled (" .. state .. ")"
    end
    MachoMenuNotification("Logger State", "Current state: " .. stateText)
end)

-- Disable logger button
MachoMenuButton(Tab1Group2, "Disable Logger", function()
    MachoSetLoggerState(0)
    MachoMenuNotification("Logger", "Logger disabled (state: 0)")
end)

-- Enable logger button
MachoMenuButton(Tab1Group2, "Enable Logger", function()
    MachoSetLoggerState(3)
    MachoMenuNotification("Logger", "Logger enabled (state: 3)")
end)

-- Lock logger permanently (WARNING!)
MachoMenuButton(Tab1Group2, "🔒 LOCK Logger (Permanent!)", function()
    MachoLockLogger()
    MachoMenuNotification("WARNING", "Logger permanently locked until reload!")
end)

-- ===== Tab 2: Player =====
local Tab2Group1 = MachoMenuGroup(Tab2, "Player Settings", 10.0, 10.0, 480.0, 180.0)

-- Heal button
MachoMenuButton(Tab2Group1, "Heal Player", function()
    SetEntityHealth(PlayerPedId(), 200)
    MachoMenuNotification("Health", "Player fully healed!")
end)

-- Armor button
MachoMenuButton(Tab2Group1, "Give Armor", function()
    SetPedArmour(PlayerPedId(), 100)
    MachoMenuNotification("Armor", "Full armor applied!")
end)

-- Name input box
local NameInputBox = MachoMenuInputbox(Tab2Group1, "Change Name", "Enter new name...")

-- Save name button
MachoMenuButton(Tab2Group1, "Save Name", function()
    local newName = MachoMenuGetInputbox(NameInputBox)
    if newName and newName ~= "" then
        MachoMenuNotification("Name Change", "Name saved: " .. newName)
    else
        MachoMenuNotification("Error", "Please enter a valid name!")
    end
end)

-- Weapon dropdown
MachoMenuDropDown(Tab2Group1, "Give Weapon", function(selected)
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

-- Keybind example
MachoMenuKeybind(Tab2Group1, "Teleport Key", 0x54, function(key, toggle) -- T key
    if toggle then
        local coords = GetEntityCoords(PlayerPedId())
        SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z + 10.0)
        MachoMenuNotification("Teleport", "Teleported up!")
    end
end)

-- ===== Tab 3: Vehicle =====
local Tab3Group1 = MachoMenuGroup(Tab3, "Vehicle Settings", 10.0, 10.0, 480.0, 150.0)

-- Repair vehicle button
MachoMenuButton(Tab3Group1, "Repair Vehicle", function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 then
        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
        MachoMenuNotification("Vehicle", "Vehicle repaired!")
    else
        MachoMenuNotification("Error", "You're not in a vehicle!")
    end
end)

-- Boost vehicle button
MachoMenuButton(Tab3Group1, "Boost Vehicle", function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 then
        SetVehicleEnginePowerMultiplier(vehicle, 2.0)
        MachoMenuNotification("Vehicle", "Vehicle boosted!")
    else
        MachoMenuNotification("Error", "You're not in a vehicle!")
    end
end)

-- Vehicle spawn dropdown
MachoMenuDropDown(Tab3Group1, "Spawn Vehicle", function(selected)
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

-- Speed slider for current vehicle
MachoMenuSlider(Tab3Group1, "Vehicle Speed", 100.0, 50.0, 300.0, "km/h", 0, function(value)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 then
        local speed = value / 3.6 -- Convert km/h to m/s
        SetVehicleForwardSpeed(vehicle, speed)
        MachoMenuNotification("Speed", "Speed set to: " .. value .. " km/h")
    end
end)

-- Get selected info button
MachoMenuButton(Tab3Group1, "Get Selected Info", function()
    local selectedPlayer = MachoMenuGetSelectedPlayer()
    local selectedVehicle = MachoMenuGetSelectedVehicle()
    MachoMenuNotification("Selection", "Player: " .. selectedPlayer .. " | Vehicle: " .. selectedVehicle)
end)

-- Keyboard input examples
MachoOnKeyDown(function(key)
    if key == 0x70 then -- F1 key
        if MachoMenuIsOpen(MainWindow) then
            MachoMenuDestroy(MainWindow)
        end
    end
end)
