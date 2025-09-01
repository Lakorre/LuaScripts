---------------------------------------------------
-- نافذة Left Menu
---------------------------------------------------

local MenuSizeLeft = vec2(600, 350)
local MenuStartCoordsLeft = vec2(500, 500)

local MenuLeft = MachoMenuWindow(MenuStartCoordsLeft.x, MenuStartCoordsLeft.y, MenuSizeLeft.x, MenuSizeLeft.y)
MachoMenuSetAccent(MenuLeft, 137, 52, 235)

-- قسم 1
local SectionOne = MachoMenuGroup(MenuLeft, "Section One", 10, 40, 180, 300)
MachoMenuButton(SectionOne, "Close Left", function()
    MachoMenuDestroy(MenuLeft)
end)

-- قسم 2
local SectionTwo = MachoMenuGroup(MenuLeft, "Section Two", 200, 40, 380, 300)

MachoMenuSlider(SectionTwo, "Slider", 10, 0, 100, "%", 0, function(Value)
    print("Slider updated with value " .. Value)
end)

MachoMenuCheckbox(SectionTwo, "Checkbox",
    function() print("Enabled") end,
    function() print("Disabled") end
)

local TextHandle = MachoMenuText(SectionTwo, "SomeText")
MachoMenuButton(SectionTwo, "Change Text Example", function()
    MachoMenuSetText(TextHandle, "ChangedText")
end)

-- قسم 3
local SectionThree = MachoMenuGroup(MenuLeft, "Section Three", 400, 40, 580, 300)

local InputBoxHandle = MachoMenuInputbox(SectionThree, "Input", "...")
MachoMenuButton(SectionThree, "Print Input", function()
    local LocatedText = MachoMenuGetInputbox(InputBoxHandle)
    print(LocatedText)
end)

local DropDownHandle = MachoMenuDropDown(SectionThree, "Drop Down",
    function(Index)
        print("New Value is " .. Index)
    end,
    "Selectable 1",
    "Selectable 2",
    "Selectable 3"
)


---------------------------------------------------
-- نافذة MACHO Editor
---------------------------------------------------

local MenuSizeRight = vec2(600, 350)
local MenuStartCoordsRight = vec2(1200, 500)

local MenuRight = MachoMenuWindow(MenuStartCoordsRight.x, MenuStartCoordsRight.y, MenuSizeRight.x, MenuSizeRight.y)
MachoMenuSetAccent(MenuRight, 255, 20, 147)

local EditorSection = MachoMenuGroup(MenuRight, "MACHO Editor", 10, 40, 580, 300)

MachoMenuButton(EditorSection, "Run Code", function()
    print("Running MACHO code...")
end)

MachoMenuButton(EditorSection, "Close Right", function()
    MachoMenuDestroy(MenuRight)
end)
