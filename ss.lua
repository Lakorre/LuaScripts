-- ====== Ali Menu Independent ======
local MenuSize_Ali = vec2(600, 400)
local MenuStartCoords_Ali = vec2(500, 300)

-- إنشاء نافذة مستقلة
local MenuWindow_Ali = MachoMenuWindow(MenuStartCoords_Ali.x, MenuStartCoords_Ali.y, MenuSize_Ali.x, MenuSize_Ali.y)
MachoMenuSetAccent(MenuWindow_Ali, 255, 255, 150) -- أصفر فاتح

-- إنشاء القسم الرئيسي للقائمة Ali
local AliSection = MachoMenuGroup(MenuWindow_Ali, "Ali Menu", 20, 20, 580, 380)

-- زر Heal + Armor
MachoMenuButton(AliSection, "Heal / Armor", function()
    local ped = PlayerPedId()
    SetEntityHealth(ped, 200)
    SetPedArmour(ped, 100)
    MachoMenuNotification("Ali", "Health & Armor Restored")
end)

-- Toggle Player IDs
local showPlayerIDs_Ali = false
MachoMenuCheckbox(AliSection, "Show Player IDs", 
    function() showPlayerIDs_Ali = true MachoMenuNotification("Ali", "Player IDs ON") end,
    function() showPlayerIDs_Ali = false MachoMenuNotification("Ali", "Player IDs OFF") end
)

-- زر إغلاق مستقل
MachoMenuButton(AliSection, "Close Ali Menu", function()
    MachoMenuDestroy(MenuWindow_Ali)
end)

-- رسم Player IDs خاص بالقائمة Ali فقط
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if showPlayerIDs_Ali then
            for _, playerId in ipairs(GetActivePlayers()) do
                if playerId ~= PlayerId() then
                    local ped = GetPlayerPed(playerId)
                    local headCoords = GetPedBoneCoords(ped, 0x796e, 0.0, 0.0, 0.55)
                    local onScreen, _x, _y = World3dToScreen2d(headCoords.x, headCoords.y, headCoords.z + 0.3)
                    if onScreen then
                        SetTextScale(0.35, 0.35)
                        SetTextFont(4)
                        SetTextProportional(1)
                        SetTextOutline()
                        SetTextColour(255, 255, 255, 255)
                        SetTextEntry("STRING")
                        SetTextCentre(1)
                        AddTextComponentString(GetPlayerName(playerId).." | ID: "..GetPlayerServerId(playerId))
                        DrawText(_x, _y)
                    end
                end
            end
        end
    end
end)
