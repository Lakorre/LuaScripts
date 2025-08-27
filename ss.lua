local isMenuOpen = true -- المنيو يُنشأ دائمًا عند التحميل

-- ====== Create Window once ======
local MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
MachoMenuSetAccent(MenuWindow, 255, 215, 0)

-- Sidebar
local Sidebar = MachoMenuGroup(MenuWindow, "Menu", SidebarStart.x, SidebarStart.y, SidebarEnd.x, SidebarEnd.y)
MachoMenuButton(Sidebar, "Player", function() print("[Aura] Player") end)
MachoMenuButton(Sidebar, "Close", function() isMenuOpen = false MachoMenuNotification("Menu", "You closed the menu") end)

-- Left Column
local LeftCol = MachoMenuGroup(MenuWindow, "Vehicle & Self", LeftStart.x, LeftStart.y, LeftEnd.x, LeftEnd.y)
local r = MachoMenuSlider(LeftCol, "Red", 255, 0, 255, "", 0, function(v) print("R="..v) end)

-- ====== Page Up Key ======
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(1, 0x21) then -- Page Up
            if isMenuOpen then
                isMenuOpen = false
                MachoMenuNotification("Menu", "Menu Hidden (cannot fully hide window)")
            else
                isMenuOpen = true
                MachoMenuNotification("Menu", "Menu Shown")
            end
        end
    end
end)
