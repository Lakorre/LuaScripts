-- Menu settings
local MenuSize = vec2(600, 400)
local MenuStartCoords = vec2(300, 200) 
local TabsBarWidth = 0
local SectionChildWidth = MenuSize.x - TabsBarWidth
local SectionsCount = 3
local SectionsPadding = 15
local MachoPaneGap = 10

-- Calculate each section width
local EachSectionWidth = (SectionChildWidth - (SectionsPadding * (SectionsCount + 1))) / SectionsCount

-- Calculate section coordinates
local SectionOneStart = vec2(TabsBarWidth + (SectionsPadding * 1) + (EachSectionWidth * 0), SectionsPadding + MachoPaneGap)
local SectionOneEnd = vec2(SectionOneStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

local SectionTwoStart = vec2(TabsBarWidth + (SectionsPadding * 2) + (EachSectionWidth * 1), SectionsPadding + MachoPaneGap)
local SectionTwoEnd = vec2(SectionTwoStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

local SectionThreeStart = vec2(TabsBarWidth + (SectionsPadding * 3) + (EachSectionWidth * 2), SectionsPadding + MachoPaneGap)
local SectionThreeEnd = vec2(SectionThreeStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

-- Create main window (x, y, width, height)
local MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)

-- Set accent color (RGB: 137, 52, 235)
MachoMenuSetAccent(MenuWindow, 137, 52, 235)

-- Set keybind (F9)
MachoMenuSetKeybind(MenuWindow, 0x78)

-- Add small title text
MachoMenuSmallText(MenuWindow, "Welcome to Macho Menu!")

-- ===== Section One: Player Settings =====
local PlayerSection = MachoMenuGroup(MenuWindow, "Player Settings", SectionOneStart.x, SectionOneStart.y, SectionOneEnd.x, SectionOneEnd.y)

-- Heal button
MachoMenuButton(PlayerSection, "Heal Player", function()
    SetEntityHealth(PlayerPedId(), 200)
    MachoMenuNotification("Health", "Player fully healed!")
end)

-- Armor button
MachoMenuButton(PlayerSection, "Give Armor", function()
    SetPedArmour(PlayerPedId(), 100)
    MachoMenuNotification("Armor", "Full armor applied!")
end)

-- Name input box
local NameInputBox = MachoMenuInputbox(PlayerSection, "Player Name", "Enter new name...")

-- Save name button
MachoMenuButton(PlayerSection, "Save Name", function()
    local newName = MachoMenuGetInputbox(NameInputBox)
    if newName and newName ~= "" then
        MachoMenuNotification("Name Change", "Name saved: " .. newName)
    else
        MachoMenuNotification("Error", "Please enter a valid name!")
    end
end)

-- Weapon dropdown
MachoMenuDropDown(PlayerSection, "Give Weapon", function(selected)
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

-- Teleport keybind
MachoMenuKeybind(PlayerSection, "Teleport Key", 0x54, function(key, toggle)
    if toggle then
        local coords = GetEntityCoords(PlayerPedId())
        SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z + 10.0)
        MachoMenuNotification("Teleport", "Teleported up 10m!")
    end
end)

-- ===== Section Two: Vehicle Settings =====
local VehicleSection = MachoMenuGroup(MenuWindow, "Vehicle Settings", SectionTwoStart.x, SectionTwoStart.y, SectionTwoEnd.x, SectionTwoEnd.y)

-- زر إصلاح المركبة
MachoMenuButton(VehicleSection, "Repair Vehicle", function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 then
        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
        MachoMenuNotification("Vehicle", "Vehicle repaired!")
    else
        MachoMenuNotification("Error", "You're not in a vehicle!")
    end
end)

-- زر تسريع المركبة
MachoMenuButton(VehicleSection, "Boost Vehicle", function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 then
        SetVehicleEnginePowerMultiplier(vehicle, 2.0)
        MachoMenuNotification("Vehicle", "Vehicle boosted!")
    else
        MachoMenuNotification("Error", "You're not in a vehicle!")
    end
end)

-- قائمة منسدلة لاستدعاء المركبات
MachoMenuDropDown(VehicleSection, "Spawn Vehicle", function(selected)
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

-- منزلق للسرعة
MachoMenuSlider(VehicleSection, "Vehicle Speed", 100.0, 50.0, 300.0, "km/h", 0, function(value)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 then
        local speed = value / 3.6
        SetVehicleForwardSpeed(vehicle, speed)
        MachoMenuNotification("Speed", "Speed set to: " .. value .. " km/h")
    end
end)

-- زر معلومات المحدد
MachoMenuButton(VehicleSection, "Selected Info", function()
    local selectedPlayer = MachoMenuGetSelectedPlayer()
    local selectedVehicle = MachoMenuGetSelectedVehicle()
    MachoMenuNotification("Selection", "Player: " .. selectedPlayer .. " | Vehicle: " .. selectedVehicle)
end)

-- ===== القسم الثالث: الإعدادات المتقدمة =====
local AdvancedSection = MachoMenuGroup(MenuWindow, "Advanced Settings", SectionThreeStart.x, SectionThreeStart.y, SectionThreeEnd.x, SectionThreeEnd.y)

-- معلومات السيرفر
MachoMenuButton(AdvancedSection, "Server Info", function()
    MachoMenuNotification("Server Info", "Players online: " .. GetNumberOfPlayers())
end)

-- صندوق اختيار للوضع الليلي
MachoMenuCheckbox(AdvancedSection, "Dark Mode", 
    function() 
        MachoMenuNotification("Dark Mode", "Dark mode enabled")
    end,
    function() 
        MachoMenuNotification("Dark Mode", "Dark mode disabled")
    end
)

-- فحص حالة السجل
MachoMenuButton(AdvancedSection, "Check Logger", function()
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

-- تعطيل السجل
MachoMenuButton(AdvancedSection, "Disable Logger", function()
    MachoSetLoggerState(0)
    MachoMenuNotification("Logger", "Logger disabled!")
end)

-- تفعيل السجل
MachoMenuButton(AdvancedSection, "Enable Logger", function()
    MachoSetLoggerState(3)
    MachoMenuNotification("Logger", "Logger enabled!")
end)

-- قفل السجل نهائياً
MachoMenuButton(AdvancedSection, "🔒 LOCK Logger", function()
    MachoLockLogger()
    MachoMenuNotification("WARNING", "Logger permanently locked!")
end)

-- زر إغلاق القائمة
MachoMenuButton(AdvancedSection, "Close Menu", function()
    MachoMenuDestroy(MenuWindow)
end)

-- معالج لوحة المفاتيح
MachoOnKeyDown(function(key)
    if key == 0x70 then -- F1 key
        if MachoMenuIsOpen(MenuWindow) then
            MachoMenuDestroy(MenuWindow)
        end
    end
end)

-- مثال على حقن المورد (معطل)
--[[
MachoInjectResource('any', [[
    print("Code injected successfully!")
]])
]]--

-- مثال على المصادقة المدفوعة (معطل)
--[[
local KeysBin = MachoWebRequest("https://your-website.com/keys")
local CurrentKey = MachoAuthenticationKey()
local KeyPresent = string.find(KeysBin, CurrentKey)
if KeyPresent ~= nil then
    print("Key is authenticated [" .. CurrentKey .. "]")
else
    print("Key is not in the list [" .. CurrentKey .. "]")
    MachoMenuDestroy(MenuWindow) -- إغلاق القائمة إذا المفتاح غير صالح
end
]]--
