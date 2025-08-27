-- ====== Menu Config ======
local MenuSize = vec2(100, 100)        -- أكبر/متوسط حجم للشاشة
local MenuStartCoords = vec2(20, 20)    -- بدء من الأعلى واليسار
local SidebarWidth = 10                
local SectionsPadding = 10
local TopGap = 10
local SectionsCount = 3

local SectionChildWidth = MenuSize.x - SidebarWidth
local EachSectionWidth = (SectionChildWidth - (SectionsPadding * (SectionsCount + 1))) / SectionsCount

-- ====== Section Coordinates ======
local LeftStart  = vec2(SidebarWidth + (SectionsPadding * 1) + (EachSectionWidth * 0), SectionsPadding + TopGap)
local LeftEnd    = vec2(LeftStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

local CenterStart = vec2(SidebarWidth + (SectionsPadding * 2) + (EachSectionWidth * 1), SectionsPadding + TopGap)
local CenterEnd   = vec2(CenterStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

local RightStart = vec2(SidebarWidth + (SectionsPadding * 3) + (EachSectionWidth * 2), SectionsPadding + TopGap)
local RightEnd   = vec2(RightStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

-- ====== Create Menu Window ======
local MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
MachoMenuSetAccent(MenuWindow, 255, 255, 150) -- أصفر فاتح

local isMenuOpen = true


