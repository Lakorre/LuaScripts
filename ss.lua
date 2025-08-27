-- Register a key to open the menu (Page Up)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(1, 0x21) then -- Page Up
            if MenuWindow == nil or not MachoMenuIsOpen(MenuWindow) then
                -- ====== Create Window ======
                MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
                MachoMenuSetAccent(MenuWindow, 137, 52, 235)

                -- Section One
                local FirstSection = MachoMenuGroup(MenuWindow, "Section One", SectionOneStart.x, SectionOneStart.y, SectionOneEnd.x, SectionOneEnd.y)
                MachoMenuButton(FirstSection, "Close Menu", function()
                    MachoMenuDestroy(MenuWindow)
                    MachoMenuNotification("Menu", "Closed!")
                end)

                -- Section Two
                local SecondSection = MachoMenuGroup(MenuWindow, "Section Two", SectionTwoStart.x, SectionTwoStart.y, SectionTwoEnd.x, SectionTwoEnd.y)
                MachoMenuSlider(SecondSection, "Slider", 10, 0, 100, "%", 0, function(Value) print("Slider updated: "..Value) end)
                MachoMenuCheckbox(SecondSection, "Enable Feature", function() print("Feature Enabled") end, function() print("Feature Disabled") end)
                local TextHandle = MachoMenuText(SecondSection, "Default Text")
                MachoMenuButton(SecondSection, "Change Text", function() MachoMenuSetText(TextHandle, "Text Updated!") end)

                -- Section Three
                local ThirdSection = MachoMenuGroup(MenuWindow, "Section Three", SectionThreeStart.x, SectionThreeStart.y, SectionThreeEnd.x, SectionThreeEnd.y)
                local InputHandle = MachoMenuInputbox(ThirdSection, "Input Box", "Type here...")
                MachoMenuButton(ThirdSection, "Print Input", function()
                    local text = MachoMenuGetInputbox(InputHandle)
                    print("Input: "..text)
                end)
                MachoMenuDropDown(ThirdSection, "Select Option", function(Index) print("Dropdown selected: "..Index) end, "Option 1", "Option 2", "Option 3")

                -- Player IDs Checkbox
                MachoMenuCheckbox(ThirdSection, "Show Player IDs", function() showPlayerIDs = true print("Player IDs ON") end, function() showPlayerIDs = false print("Player IDs OFF") end)

                -- Example Keybind
                MachoMenuKeybind(ThirdSection, "Test Keybind", 0, function(key, toggle) print("Key "..key.." toggled: "..tostring(toggle)) end)

                -- Example Notification
                MachoMenuButton(ThirdSection, "Show Notification", function()
                    MachoMenuNotification("Test", "This is a Macho notification!")
                end)
            end
        end
    end
end)
