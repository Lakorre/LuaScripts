-- ====== Ali Menu Configuration ======
local MenuSize = vec2(600, 400)  -- حجم متوسط
local MenuStartCoords = vec2(500, 300)
local TabsBarWidth = 150
local SectionsPadding = 10
local MachoPaneGap = 10
local SectionsCount = 1  -- قائمة واحدة فقط
local SectionChildWidth = MenuSize.x - TabsBarWidth
local EachSectionWidth = SectionChildWidth - (SectionsPadding * 2)

-- ====== Section coordinates ======
local MainStart = vec2(TabsBarWidth + SectionsPadding, SectionsPadding + MachoPaneGap)
local MainEnd = vec2(MainStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

-- ====== Create Menu Window ======
local MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
MachoMenuSetAccent(MenuWindow, 255, 255, 150)  -- أصفر فاتح

-- ====== Main Section ======
local AliSection = MachoMenuGroup(MenuWindow, "Ali", MainStart.x, MainStart.y, MainEnd.x, MainEnd.y)

-- زر مستقل لإعادة الصحة والدرع
MachoMenuButton(AliSection, "Heal / Armor", function()
    local playerPed = PlayerPedId()
    if DoesEntityExist(playerPed) and not IsEntityDead(playerPed) then
        SetEntityHealth(playerPed, 200)  -- صحة كاملة
        SetPedArmour(playerPed, 100)     -- درع كامل
        MachoMenuNotification("Ali", "Health & Armor Restored")
    else
        MachoMenuNotification("Ali", "Player does not exist or is dead")
    end
end)

-- زر Close لإغلاق القائمة
MachoMenuButton(AliSection, "Close Menu", function()
    MachoMenuDestroy(MenuWindow)
end)

-- ====== Toggle Menu Key (Page Up) ======
local isMenuOpen = true
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(1, 0x21) then -- Page Up
            if isMenuOpen then
                isMenuOpen = false
                MachoMenuNotification("Ali", "Menu Hidden")
            else
                isMenuOpen = true
                MachoMenuNotification("Ali", "Menu Shown")
            end
        end
    end
end)
