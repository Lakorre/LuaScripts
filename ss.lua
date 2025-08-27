-- ====== Main Menu ======
local MainMenu = MachoMenuWindow(100, 100, 800, 500)
MachoMenuSetAccent(MainMenu, 255, 50, 50) -- أحمر

-- Sidebar
local MainSidebar = MachoMenuGroup(MainMenu, "Main Menu", 10, 10, 200, 490)
MachoMenuButton(MainSidebar, "Option 1", function() print("Main Option 1") end)
MachoMenuButton(MainSidebar, "Option 2", function() print("Main Option 2") end)
MachoMenuButton(MainSidebar, "Close Main", function()
    MachoMenuDestroy(MainMenu)
end)

-- ====== Ali Menu ======
local AliMenu = MachoMenuWindow(200, 150, 600, 400)
MachoMenuSetAccent(AliMenu, 50, 200, 50) -- أخضر

local AliSection = MachoMenuGroup(AliMenu, "Ali Options", 10, 10, 580, 380)
local showPlayerIDs = false

MachoMenuCheckbox(AliSection, "Show Player IDs", 
    function() showPlayerIDs = true print("Player IDs ON") end, 
    function() showPlayerIDs = false print("Player IDs OFF") end
)

MachoMenuButton(AliSection, "Close Ali", function()
    MachoMenuDestroy(AliMenu)
end)

-- ====== Keybinds ======
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        -- Toggle MainMenu with F9
        if IsControlJustPressed(1, 0x78) then -- F9
            if MachoMenuIsOpen(MainMenu) then
                MachoMenuDestroy(MainMenu)
            else
                MainMenu = MachoMenuWindow(100, 100, 800, 500)
                MachoMenuSetAccent(MainMenu, 255, 50, 50)
            end
        end

        -- Toggle AliMenu with Page Up
        if IsControlJustPressed(1, 0x21) then -- Page Up
            if MachoMenuIsOpen(AliMenu) then
                MachoMenuDestroy(AliMenu)
            else
                AliMenu = MachoMenuWindow(200, 150, 600, 400)
                MachoMenuSetAccent(AliMenu, 50, 200, 50)
            end
        end
    end
end)

-- ====== Draw 3D Player IDs for Ali Menu ======
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

-- DrawText3D function
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
