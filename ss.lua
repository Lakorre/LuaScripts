-- ====== RICO Menu Configuration ======
local MenuSize = vec2(800, 500)  -- Increased size to fit more content
local MenuStartCoords = vec2(400, 300)
local TabsBarWidth = 200  -- Width for the left sidebar with categories
local SectionChildWidth = MenuSize.x - TabsBarWidth
local SectionsCount = 2  -- Main content area and right panel
local SectionsPadding = 10
local MachoPaneGap = 10
local EachSectionWidth = (SectionChildWidth - (SectionsPadding * (SectionsCount + 1))) / SectionsCount

-- ====== Section coordinates ======
local TabsStart = vec2(0, MachoPaneGap)
local TabsEnd = vec2(TabsBarWidth, MenuSize.y - SectionsPadding)

local MainContentStart = vec2(TabsBarWidth + SectionsPadding, SectionsPadding + MachoPaneGap)
local MainContentEnd = vec2(MainContentStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

local RightPanelStart = vec2(TabsBarWidth + SectionsPadding * 2 + EachSectionWidth, SectionsPadding + MachoPaneGap)
local RightPanelEnd = vec2(RightPanelStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

-- ====== Create Menu Window ======
local MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
MachoMenuSetAccent(MenuWindow, 220, 20, 60)  -- Red accent like RICO

-- ====== Global Variables ======
local CurrentTab = "Self"
local MainContent = nil
local RightPanel = nil

-- ====== Left Sidebar (Categories) ======
local TabsSection = MachoMenuGroup(MenuWindow, "RICO V4.5", TabsStart.x, TabsStart.y, TabsEnd.x, TabsEnd.y)

-- Add version info
MachoMenuText(TabsSection, "Expired: Never")

-- Category buttons with gear icons
local Categories = {
    "Self Options",
    "Online Options", 
    "Weapons",
    "Vehicles",
    "Exploit Video",
    "Exploit",
    "Nuke Options",
    "Settings"
}

-- Function to update main content based on selected category
function UpdateMainContent(category)
    CurrentTab = category
    
    -- Destroy existing content
    if MainContent then
        -- Update content instead of recreating
    end
    
    -- Create main content section
    MainContent = MachoMenuGroup(MenuWindow, category, MainContentStart.x, MainContentStart.y, MainContentEnd.x, MainContentEnd.y)
    
    if category == "Self" or category == "Self Options" then
        MachoMenuButton(MainContent, "Revive [SAFE]", function()
            SetPedArmour(PlayerPedId(), 100)
        end)
       MachoMenuButton(MainContent, "Armor", function()
    local playerPed = PlayerPedId()

    MachoMenuButton(MainContent, "Armor", function()
    local playerPed = PlayerPedId()
    SetEntityHealth(playerPed, 100)
    SetPedArmour(playerPed, 100)
    MachoMenuNotification("RICO", "Health & Armor Restored")
end)

        MachoMenuButton(MainContent, "Suicide", function()
            -- Add suicide functionality here
        end)
        MachoMenuButton(MainContent, "Clean Player", function()
            -- Add clean player functionality here
        end)
        MachoMenuButton(MainContent, "Anti Carry", function()
            -- Add anti carry functionality here
        end)
        MachoMenuButton(MainContent, "Anti Teleport", function()
            -- Add anti teleport functionality here
        end)
        MachoMenuText(MainContent, "")
        MachoMenuText(MainContent, "Self Animation")
        MachoMenuButton(MainContent, "Sucked Anim", function()
            -- Add animation functionality here
        end)
        MachoMenuButton(MainContent, "Fuck #1 [Sex] Anim", function()
            -- Add animation functionality here
        end)
        
    elseif category == "Online Options" then
        MachoMenuButton(MainContent, "Player List", function()
            -- Add player list functionality
        end)
        MachoMenuButton(MainContent, "Spectate Player", function()
            -- Add spectate functionality
        end)
        MachoMenuButton(MainContent, "Teleport to Player", function()
            -- Add teleport functionality
        end)
        MachoMenuButton(MainContent, "Kill Player", function()
            -- Add kill functionality
        end)
        
    elseif category == "Weapons" then
        MachoMenuButton(MainContent, "Give All Weapons", function()
            -- Add weapons functionality
        end)
        MachoMenuButton(MainContent, "Remove All Weapons", function()
            -- Add remove weapons functionality
        end)
        MachoMenuButton(MainContent, "Infinite Ammo", function()
            -- Add infinite ammo functionality
        end)
        MachoMenuButton(MainContent, "Super Damage", function()
            -- Add super damage functionality
        end)
        
    elseif category == "Vehicles" then
        MachoMenuButton(MainContent, "Spawn Vehicle", function()
            -- Add vehicle spawn functionality
        end)
        MachoMenuButton(MainContent, "Vehicle God Mode", function()
            -- Add vehicle god mode functionality
        end)
        MachoMenuButton(MainContent, "Super Speed", function()
            -- Add super speed functionality
        end)
        
    elseif category == "Exploit" then
        MachoMenuButton(MainContent, "Money Drop", function()
            -- Add money drop functionality
        end)
        MachoMenuButton(MainContent, "RP Drop", function()
            -- Add RP drop functionality
        end)
        MachoMenuButton(MainContent, "Unlock All", function()
            -- Add unlock all functionality
        end)
        
    elseif category == "Settings" then
        MachoMenuButton(MainContent, "Save Config", function()
            -- Add save config functionality
        end)
        MachoMenuButton(MainContent, "Load Config", function()
            -- Add load config functionality
        end)
        MachoMenuButton(MainContent, "Reset Settings", function()
            -- Add reset functionality
        end)
    end
end

-- Function to update right panel
function UpdateRightPanel()
    RightPanel = MachoMenuGroup(MenuWindow, "Player Options", RightPanelStart.x, RightPanelStart.y, RightPanelEnd.x, RightPanelEnd.y)
    
    MachoMenuButton(RightPanel, "Check Anti Cheat [F8]", function()
        -- Add anti cheat check functionality
    end)
    MachoMenuButton(RightPanel, "Disable Fireguard Watch Game", function()
        -- Add fireguard disable functionality
    end)
    MachoMenuButton(RightPanel, "Freecam [Key: DEL]", function()
        -- Add freecam functionality
    end)
    
    MachoMenuText(RightPanel, "")
    MachoMenuText(RightPanel, "Teleport")
    
    MachoMenuButton(RightPanel, "TX Teleport To Waypoint", function()
        -- Add waypoint teleport functionality
    end)
    MachoMenuButton(RightPanel, "Car Dealership (Simeon's)", function()
        -- Add teleport functionality
    end)
    MachoMenuButton(RightPanel, "Legion Square", function()
        -- Add teleport functionality
    end)
    MachoMenuButton(RightPanel, "Grove Street", function()
        -- Add teleport functionality
    end)
    MachoMenuButton(RightPanel, "LSPD HQ", function()
        -- Add teleport functionality
    end)
end

-- Create category buttons
for i, category in ipairs(Categories) do
    MachoMenuButton(TabsSection, "⚙ " .. category, function()
        UpdateMainContent(category)
    end)
end

-- Initialize with Self options
UpdateMainContent("Self")
UpdateRightPanel()

-- Add close button at bottom of tabs
MachoMenuText(TabsSection, "")
MachoMenuButton(TabsSection, "Close Menu", function()
    MachoMenuDestroy(MenuWindow)
end)





