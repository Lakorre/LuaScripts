-- Aura-style UI using ONLY the functions shown in your original snippet

-- ====== Layout ======
local MenuSize        = vec2(900, 500)
local MenuStartCoords = vec2(480, 240)

local TabsBarWidth    = 170   -- مساحة الشريط الجانبي (Sidebar) مثل Aura
local SectionsPadding = 10
local MachoPaneGap    = 10
local SectionsCount   = 2     -- عمودين محتوى (يسار/يمين)

-- مشتقات
local SectionChildWidth = MenuSize.x - TabsBarWidth
local EachSectionWidth  = (SectionChildWidth - (SectionsPadding * (SectionsCount + 1))) / SectionsCount

-- إحداثيات الأعمدة
local LeftStart  = vec2(TabsBarWidth + (SectionsPadding * 1) + (EachSectionWidth * 0), SectionsPadding + MachoPaneGap)
local LeftEnd    = vec2(LeftStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

local RightStart = vec2(TabsBarWidth + (SectionsPadding * 2) + (EachSectionWidth * 1), SectionsPadding + MachoPaneGap)
local RightEnd   = vec2(RightStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

-- إحداثيات الشريط الجانبي
local SidebarStart = vec2(SectionsPadding, SectionsPadding + MachoPaneGap)
local SidebarEnd   = vec2(TabsBarWidth - SectionsPadding, MenuSize.y - SectionsPadding)

-- ====== Window ======
MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
MachoMenuSetAccent(MenuWindow, 255, 215, 0)  -- أصفر مثل الصورة

-- ====== Sidebar (أزرار شكلية للتنقّل) ======
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

-- ====== المحتوى: العمود الأيسر (Vehicle & Self) ======
local LeftCol = MachoMenuGroup(MenuWindow, "Vehicle & Self", LeftStart.x, LeftStart.y, LeftEnd.x, LeftEnd.y)

-- RGB
local r = MachoMenuSlider(LeftCol, "Red",   255, 0, 255, "", 0, function(v) print("R="..v) end)
local g = MachoMenuSlider(LeftCol, "Green", 255, 0, 255, "", 0, function(v) print("G="..v) end)
local b = MachoMenuSlider(LeftCol, "Blue",  255, 0, 255, "", 0, function(v) print("B="..v) end)

-- Vehicle Control
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

-- أسطر شكلية بدل مُلتقط مفاتيح (لأن المكتبة ما فيها Keybind Picker)
MachoMenuText(LeftCol, "Flip keybind (Hold): NONE")
MachoMenuText(LeftCol, "Hijack keybind (Hold): NONE")

-- ====== المحتوى: العمود الأيمن (Vehicle & CheckBox) ======
local RightCol = MachoMenuGroup(MenuWindow, "Vehicle & CheckBox", RightStart.x, RightStart.y, RightEnd.x, RightEnd.y)

MachoMenuCheckbox(RightCol, "Steal Car", function() print("Steal Car: ON") end, function() print("Steal Car: OFF") end)
MachoMenuCheckbox(RightCol, "Steal Car", function() print("Steal Car: ON") end, function() print("Steal Car: OFF") end)
MachoMenuCheckbox(RightCol, "Steal Car", function() print("Steal Car: ON") end, function() print("Steal Car: OFF") end)

MachoMenuCheckbox(RightCol, "Seat Belt", function() print("Seat Belt: ON") end, function() print("Seat Belt: OFF") end)
MachoMenuCheckbox(RightCol, "Rainbow Vehicle Colour", function() print("Rainbow: ON") end, function() print("Rainbow: OFF") end)
MachoMenuCheckbox(RightCol, "Horn Boost", function() print("Horn Boost: ON") end, function() print("Horn Boost: OFF") end)
MachoMenuCheckbox(RightCol, "Vehicle Jump (SPACE)", function() print("Jump: ON") end, function() print("Jump: OFF") end)
MachoMenuCheckbox(RightCol, "Ghost Vehicle (Ground-Only Collisions)", function() print("Ghost: ON") end, function() print("Ghost: OFF") end)
MachoMenuCheckbox(RightCol, "Vehicle Godmode", function() print("Godmode: ON") end, function() print("Godmode: OFF") end)

MachoMenuSlider(RightCol, "Vehicle Invisibility Level", 255, 0, 255, "", 0, function(v)
    print("Invisibility level: "..v)
end)

MachoMenuCheckbox(RightCol, "Vehicle Invisible", function() print("Invisible: ON") end, function() print("Invisible: OFF") end)
MachoMenuText(RightCol, "Vehicle Invisible Key (Hold): NONE")

MachoMenuSlider(RightCol, "Shift Boost Speed", 50, 0, 200, "km/h", 0, function(v)
    print("Shift Boost speed: "..v.." km/h")
end)

MachoMenuCheckbox(RightCol, "Shift Boost", function() print("Shift Boost: ON") end, function() print("Shift Boost: OFF") end)

