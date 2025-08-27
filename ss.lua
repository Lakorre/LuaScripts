local MenuWindow = nil
local isMenuOpen = false

function OpenMenu()
    if isMenuOpen then return end -- إذا مفتوح بالفعل
    isMenuOpen = true

    -- ====== Create Window ======
    MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
    MachoMenuSetAccent(MenuWindow, 255, 215, 0)

    -- Sidebar
    local Sidebar = MachoMenuGroup(MenuWindow, "Menu", SidebarStart.x, SidebarStart.y, SidebarEnd.x, SidebarEnd.y)
    MachoMenuButton(Sidebar, "Player", function() print("[Aura] Player") end)
    MachoMenuButton(Sidebar, "Vehicle", function() print("[Aura] Vehicle") end)
    MachoMenuButton(Sidebar, "Players", function() print("[Aura] Players") end)
    MachoMenuButton(Sidebar, "Tools", function() print("[Aura] Tools") end)
    MachoMenuButton(Sidebar, "Settings", function() print("[Aura] Settings") end)
    MachoMenuButton(Sidebar, "Close", function() CloseMenu() end)

    -- Left Column
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

    -- Right Column
    local RightCol = MachoMenuGroup(MenuWindow, "Vehicle & CheckBox", RightStart.x, RightStart.y, RightEnd.x, RightEnd.y)
    local showPlayerIDs = false
    MachoMenuCheckbox(RightCol, "Show Player IDs", function() showPlayerIDs = true print("Player IDs ON") end, function() showPlayerIDs = false print("Player IDs OFF") end)
    MachoMenuCheckbox(RightCol, "Seat Belt", function() print("Seat Belt ON") end, function() print("Seat Belt OFF") end)
end

function CloseMenu()
    if MenuWindow then
        MachoMenuDestroy(MenuWindow)
        MenuWindow = nil
        isMenuOpen = false
    end
end

-- ====== Toggle Menu with Page Up ======
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(1, 0x21) then -- Page Up
            if isMenuOpen then
                CloseMenu()
            else
                OpenMenu()
            end
        end
    end
end)
