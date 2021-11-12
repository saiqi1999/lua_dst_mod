local Widget = require("widgets/widget")
local Image = require("widgets/image")
local Text = require("widgets/text")

local Util = require("ServerLogger/Util")

require("constants")
require("fonts")

local LEFT_OFFSET = 750
local TOP_OFFSET = 10
local MARGIN = 4
local FONT_SIZE = 20
local FONT = NUMBERFONT
local MAX_NUM = 4

local Root = Class(Widget, function (self, serverLogManager)
    Widget._ctor(self, "Root")
    self.notices = serverLogManager:GetNotices()
    self.serverLogManager = serverLogManager
    self.listUpdated = true
    self.root = self:AddChild(Widget("root"))
    self.root:SetVAnchor(ANCHOR_TOP)
    self.root:SetHAnchor(ANCHOR_LEFT)

    self.root.slots = self.root:AddChild(Widget("slots"))
    self.root.slots:SetVAnchor(ANCHOR_TOP)
    self.root.slots:SetHAnchor(ANCHOR_LEFT)
    self.root.slots.items = {}
    
    serverLogManager:SetOnNoticesChanged(function (notices)
        self.notices = notices
        self.listUpdated = true
    end)

    self:StartUpdating()
end)

function Root:SetPos(left)
    LEFT_OFFSET = left
end

local visible = true
function Root:SwitchVisibility()
    if visible then visible = false
    else visible = true end
    self.listUpdated = true
end

function Root:ClearNotices()
    self.notices = {}
    self.listUpdated = true
end
function Root:OnUpdate()
    if self.listUpdated then
        Util:KillAllWidgets(self.root.slots.items)

        self.root.slots.items = {}
        Util:ForEach(self.notices, function (info, i)
            if i <= MAX_NUM and visible then
                local infoWidget = self.root.slots:AddChild(Widget("str_index_" .. i))

                infoWidget:SetVAnchor(ANCHOR_TOP)
                infoWidget:SetHAnchor(ANCHOR_LEFT)
                infoWidget.myStr = infoWidget:AddChild(Text(FONT,FONT_SIZE))
                infoWidget.myStr:SetPosition(0,-MARGIN)
                infoWidget.myStr:SetHAlign(ANCHOR_MIDDLE)
                infoWidget.myStr:SetString(info.str)
                infoWidget:SetPosition(LEFT_OFFSET , TOP_OFFSET - i * (FONT_SIZE + MARGIN))

                table.insert(self.root.slots.items, infoWidget)
            end
        end)
    end

    self.listUpdated = false
end

return Root
