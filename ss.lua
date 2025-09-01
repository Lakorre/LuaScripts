-- نافذة القائمة اليسار
local MenuSizeLeft = vec2(600, 350)
local MenuStartCoordsLeft = vec2(500, 500)

local MenuWindowLeft = MachoMenuWindow(MenuStartCoordsLeft.x, MenuStartCoordsLeft.y, MenuSizeLeft.x, MenuSizeLeft.y)
MachoMenuSetAccent(MenuWindowLeft, 137, 52, 235)

-- قسم أول
local FirstSection = MachoMenuGroup(MenuWindowLeft, "Section One", 10, 40, 180, 300)
MachoMenuButton(FirstSection, "Close", function()
    MachoMenuDestroy(MenuWindowLeft)
end)


-- قسم ثاني
local SecondSection = MachoMenuGroup(MenuWindowLeft, "Section Two", 200, 40, 380, 300)
MachoMenuSlider(SecondSection, "Slider", 50, 0, 100, "%", 0, function(val)
    print("Slider Value: " .. val)
end)


-- قسم ثالث
local ThirdSection = MachoMenuGroup(MenuWindowLeft, "Section Three", 400, 40, 580, 300)
local InputBoxHandle = MachoMenuInputbox(ThirdSection, "Input", "...")
MachoMenuButton(ThirdSection, "Print Input", function()
    local text = MachoMenuGetInputbox(InputBoxHandle)
    print(text)
end)


-- نافذة ثانية (MACHO Editor)
local MenuSizeRight = vec2(600, 350)
local MenuStartCoordsRight = vec2(1200, 500) -- غيرت الإحداثيات بحيث تظهر يمين

local MenuWindowRight = MachoMenuWindow(MenuStartCoordsRight.x, MenuStartCoordsRight.y, MenuSizeRight.x, MenuSizeRight.y)
MachoMenuSetAccent(MenuWindowRight, 255, 20, 147)

local CodeSection = MachoMenuGroup(MenuWindowRight, "Code", 10, 40, 580, 300)
MachoMenuButton(CodeSection, "Run Code", function()
    print("Running code here...")
end)
