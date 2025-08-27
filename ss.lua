-- ====== Menu Initialization ======
local MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
MachoMenuSetAccent(MenuWindow, 137, 52, 235)

-- Section One
local FirstSection = MachoMenuGroup(MenuWindow, "Section One", SectionOneStart.x, SectionOneStart.y, SectionOneEnd.x, SectionOneEnd.y)
MachoMenuButton(FirstSection, "Close Menu", function()
    MachoMenuDestroy(MenuWindow)
    MenuWindow = nil
end)

-- Section Two
local SecondSection = MachoMenuGroup(MenuWindow, "Section Two", SectionTwoStart.x, SectionTwoStart.y, SectionTwoEnd.x, SectionTwoEnd.y)
local SliderHandle = MachoMenuSlider(SecondSection, "Slider", 10, 0, 100, "%", 0, function(Value) print("Slider updated: "..Value) end)
local CheckboxHandle = MachoMenuCheckbox(SecondSection, "Enable Feature", function() print("Enabled") end, function() print("Disabled") end)
local TextHandle = MachoMenuText(SecondSection, "Default Text")
MachoMenuButton(SecondSection, "Change Text", function() MachoMenuSetText(TextHandle, "Text Updated!") end)

-- Section Three
local ThirdSection = MachoMenuGroup(MenuWindow, "Section Three", SectionThreeStart.x, SectionThreeStart.y, SectionThreeEnd.x, SectionThreeEnd.y)
local InputHandle = MachoMenuInputbox(ThirdSection, "Input Box", "Type here...")
MachoMenuButton(ThirdSection, "Print Input", function()
    print("Input: "..MachoMenuGetInputbox(InputHandle))
end)
MachoMenuDropDown(ThirdSection, "Select Option", function(Index) print("Dropdown selected: "..Index) end, "Option 1", "Option 2", "Option 3")

local showPlayerIDs = false
MachoMenuCheckbox(ThirdSection, "Show Player IDs", function() showPlayerIDs = true end, function() showPlayerIDs = false end)

-- ====== Toggle Menu with Page Up ======
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(1, 0x21) then -- Page Up
            if MenuWindow then
                if MachoMenuIsOpen(MenuWindow) then
                    MachoMenuDestroy(MenuWindow)
                else
                    MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
                    MachoMenuSetAccent(MenuWindow, 137, 52, 235)
                    -- يمكنك إعادة إنشاء الأقسام هنا إذا MachoMenu لا يحفظها بعد Destroy
                end
            end
        end
    end
end)
