-- ====== Layout Setup ======
local MenuSize = vec2(600, 350)
local MenuStartCoords = vec2(500, 500)

local TabsBarWidth = 0
local SectionChildWidth = MenuSize.x - TabsBarWidth
local SectionsCount = 3
local SectionsPadding = 10
local MachoPaneGap = 10

local EachSectionWidth = (SectionChildWidth - (SectionsPadding * (SectionsCount + 1))) / SectionsCount

local SectionOneStart = vec2(TabsBarWidth + (SectionsPadding * 1) + (EachSectionWidth * 0), SectionsPadding + MachoPaneGap)
local SectionOneEnd = vec2(SectionOneStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

local SectionTwoStart = vec2(TabsBarWidth + (SectionsPadding * 2) + (EachSectionWidth * 1), SectionsPadding + MachoPaneGap)
local SectionTwoEnd = vec2(SectionTwoStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

local SectionThreeStart = vec2(TabsBarWidth + (SectionsPadding * 3) + (EachSectionWidth * 2), SectionsPadding + MachoPaneGap)
local SectionThreeEnd = vec2(SectionThreeStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

-- ====== Create Window ======
local MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
MachoMenuSetAccent(MenuWindow, 137, 52, 235)

-- ====== Section One ======
local FirstSection = MachoMenuGroup(MenuWindow, "Section One", SectionOneStart.x, SectionOneStart.y, SectionOneEnd.x, SectionOneEnd.y)
MachoMenuButton(FirstSection, "Close Menu", function()
    MachoMenuDestroy(MenuWindow)
end)

-- ====== Section Two ======
local SecondSection = MachoMenuGroup(MenuWindow, "Section Two", SectionTwoStart.x, SectionTwoStart.y, SectionTwoEnd.x, SectionTwoEnd.y)
local MenuSliderHandle = MachoMenuSlider(SecondSection, "Slider", 10, 0, 100, "%", 0, function(Value)
    print("Slider updated with value ".. Value)
end)

MachoMenuCheckbox(SecondSection, "Checkbox", 
    function() print("Checkbox Enabled") end,
    function() print("Checkbox Disabled") end
)

local TextHandle = MachoMenuText(SecondSection, "SomeText")
MachoMenuButton(SecondSection, "Change Text Example", function()
    MachoMenuSetText(TextHandle, "ChangedText")
end)

-- ====== Section Three ======
local ThirdSection = MachoMenuGroup(MenuWindow, "Section Three", SectionThreeStart.x, SectionThreeStart.y, SectionThreeEnd.x, SectionThreeEnd.y)
local InputBoxHandle = MachoMenuInputbox(ThirdSection, "Input", "...")
MachoMenuButton(ThirdSection, "Print Input", function()
    local text = MachoMenuGetInputbox(InputBoxHandle)
    print("Input text: "..text)
end)

local DropDownHandle = MachoMenuDropDown(ThirdSection, "Drop Down", 
    function(Index) print("DropDown selected: "..Index) end, 
    "Selectable 1", "Selectable 2", "Selectable 3"
)

-- ====== Player IDs 3D Display ======
local showPlayerIDs = false

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local camCoords = GetGameplayCamCoords()
    local distance = #(vector3(camCoords.x, camCoords.y, camCoords.z) - vector3(x, y, z))
    local scale = math.max(0.35 - (distance / 300), 0.30)

    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextOutline()
        SetTextColour(255, 255, 255, 255)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if showPlayerIDs then
            for _, playerId in ipairs(GetActivePlayers()) do
                if playerId ~= PlayerId() then
                    local ped = GetPlayerPed(playerId)
                    local headCoords = GetPedBoneCoords(ped, 0x796e, 0.0, 0.0, 0.55)
                    local name = GetPlayerName(playerId)
                    local serverId = GetPlayerServerId(playerId)
                    DrawText3D(headCoords.x, headCoords.y, headCoords.z + 0.3, string.format("%s | ID: %d", name, serverId))
                end
            end
        end
    end
end)

-- ====== Checkbox to toggle Player IDs ======
MachoMenuCheckbox(ThirdSection, "Show Player IDs",
    function() showPlayerIDs = true print("Show Player IDs: ON") end,
    function() showPlayerIDs = false print("Show Player IDs: OFF") end
)
