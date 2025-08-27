-- إعدادات عامة للواجهة
local MenuSize = vec2(800, 450)
local MenuStartCoords = vec2(500, 250)

local SidebarWidth = 180
local SectionsPadding = 10
local MachoPaneGap = 10

local SectionWidth = (MenuSize.x - SidebarWidth - (SectionsPadding * 3)) / 2

-- إنشاء نافذة المينو
MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
MachoMenuSetAccent(MenuWindow, 255, 220, 0) -- أصفر مثل Aura

-- إضافة Sidebar Tabs
local SidebarTabs = {
    "Player",
    "Vehicle",
    "Settings"
}

-- أول سكشن: التحكم باللاعب أو السيارة
local SectionOneStart = vec2(SidebarWidth + SectionsPadding, SectionsPadding + MachoPaneGap)
local SectionOneEnd = vec2(SectionOneStart.x + SectionWidth, MenuSize.y - SectionsPadding)

-- ثاني سكشن
local SectionTwoStart = vec2(SidebarWidth + (SectionsPadding * 2) + SectionWidth, SectionsPadding + MachoPaneGap)
local SectionTwoEnd = vec2(SectionTwoStart.x + SectionWidth, MenuSize.y - SectionsPadding)

-- تبويب Vehicle
VehicleSectionLeft = MachoMenuGroup(MenuWindow, "Vehicle & Self", SectionOneStart.x, SectionOneStart.y, SectionOneEnd.x, SectionOneEnd.y)
VehicleSectionRight = MachoMenuGroup(MenuWindow, "Vehicle & CheckBox", SectionTwoStart.x, SectionTwoStart.y, SectionTwoEnd.x, SectionTwoEnd.y)

--------------------------------------
-- ✅ عناصر القسم الأيسر
MachoMenuSlider(VehicleSectionLeft, "Red", 255, 0, 255, "", 0, function(val) print("Red: "..val) end)
MachoMenuSlider(VehicleSectionLeft, "Green", 255, 0, 255, "", 0, function(val) print("Green: "..val) end)
MachoMenuSlider(VehicleSectionLeft, "Blue", 255, 0, 255, "", 0, function(val) print("Blue: "..val) end)

MachoMenuDropDown(VehicleSectionLeft, "Select Flip", function(idx)
    print("Selected Flip: "..idx)
end, "Flip 1", "Flip 2", "Flip 3")

MachoMenuButton(VehicleSectionLeft, "Flip", function() print("Vehicle Flipped") end)
MachoMenuButton(VehicleSectionLeft, "Hijack Nearest Vehicle", function() print("Hijack triggered") end)
MachoMenuButton(VehicleSectionLeft, "Remote Car", function() print("Remote Car Mode") end)

MachoMenuText(VehicleSectionLeft, "Flip Keybind (Hold)")
MachoMenuKeybind(VehicleSectionLeft, function(key) print("Flip Key set to: "..key) end)

MachoMenuText(VehicleSectionLeft, "Hijack Vehicle Key (Hold)")
MachoMenuKeybind(VehicleSectionLeft, function(key) print("Hijack Key set to: "..key) end)

--------------------------------------
-- ✅ عناصر القسم الأيمن (Checkbox + Slider)
MachoMenuCheckbox(VehicleSectionRight, "Steal Car", function() print("Steal Car ON") end, function() print("Steal Car OFF") end)
MachoMenuCheckbox(VehicleSectionRight, "Seat Belt", function() print("Seat Belt ON") end, function() print("Seat Belt OFF") end)
MachoMenuCheckbox(VehicleSectionRight, "Rainbow Vehicle Colour", function() print("Rainbow ON") end, function() print("Rainbow OFF") end)
MachoMenuCheckbox(VehicleSectionRight, "Horn Boost", function() print("Horn Boost ON") end, function() print("Horn Boost OFF") end)
MachoMenuCheckbox(VehicleSectionRight, "Vehicle Jump (SPACE)", function() print("Jump ON") end, function() print("Jump OFF") end)
MachoMenuCheckbox(VehicleSectionRight, "Ghost Vehicle", function() print("Ghost ON") end, function() print("Ghost OFF") end)
MachoMenuCheckbox(VehicleSectionRight, "Vehicle Godmode", function() print("Godmode ON") end, function() print("Godmode OFF") end)

MachoMenuSlider(VehicleSectionRight, "Vehicle Invisibility Level", 255, 0, 255, "", 0, function(val) print("Invisibility: "..val) end)

MachoMenuCheckbox(VehicleSectionRight, "Vehicle Invisible", function() print("Invisible ON") end, function() print("Invisible OFF") end)
MachoMenuText(VehicleSectionRight, "Invisible Keybind (Hold)")
MachoMenuKeybind(VehicleSectionRight, function(key) print("Invisible Key: "..key) end)

MachoMenuSlider(VehicleSectionRight, "Shift Boost Speed", 50, 0, 200, "km/h", 0, function(val) print("Boost Speed: "..val.." km/h") end)
MachoMenuCheckbox(VehicleSectionRight, "Shift Boost", function() print("Boost ON") end, function() print("Boost OFF") end)

--------------------------------------
-- ✅ Sidebar أزرار التبويبات
for i, tab in ipairs(SidebarTabs) do
    MachoMenuSidebarButton(MenuWindow, tab, function()
        print("Switched to Tab: "..tab)
    end)
end
