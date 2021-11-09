local Widget = require("widgets/widget")
local Image = require("widgets/image")
local Text = require("widgets/text")

local Constants = require("ServerLogger/Constants")
local Util = require("ServerLogger/Util")

require("constants")
require("fonts")

local LEFT_OFFSET = 800
local TOP_OFFSET = 10
local MARGIN = 4
local FONT_SIZE = 20
local FONT = NUMBERFONT

local Root = Class(Widget, function (self, buffManager)
    Widget._ctor(self, "Root")
    print("new root")
    -- self.TimeDifferenceManager = timeDifferenceManager
    --linked to Manager's buff
    self.buffs = buffManager:GetBuffs()
    self.buffManager = buffManager
    -- self.strs = buffManager:GetStr()
    self.listUpdated = true
    -- dec
    self.root = self:AddChild(Widget("root"))
    self.root:SetVAnchor(ANCHOR_TOP)
    self.root:SetHAnchor(ANCHOR_LEFT)

    self.root.buffs = self.root:AddChild(Widget("buffs"))
    self.root.buffs:SetVAnchor(ANCHOR_TOP)
    self.root.buffs:SetHAnchor(ANCHOR_LEFT)
    self.root.buffs.items = {}
    
    -- print(self.str)
    print("root calling for set onbuffChange")
    buffManager:SetOnBuffsChanged1(function (buffs)
        self.buffs = buffs
        self.listUpdated = true
    end)
    -----------
    
    -- buffManager:SetOnStrChanged(function (strs)
    --     self.strs = strs
    --     self.strs[0] = {str = "i"}
    --     self.listUpdated = true
    -- end)
    -----------
    self:StartUpdating()
end)

function Root:ClearBuffs()
    self.buffs = {}
    self.listUpdated = true
end
-- local strT = "default"
function Root:OnUpdate()
    if self.listUpdated then
        Util:KillAllWidgets(self.root.buffs.items)

        self.root.buffs.items = {}
        Util:ForEach(self.buffs, function (buff, i)
            local buffWidget = self.root.buffs:AddChild(Widget("str_index_" .. i))

            buffWidget:SetVAnchor(ANCHOR_TOP)
            buffWidget:SetHAnchor(ANCHOR_LEFT)
            buffWidget.myStr = buffWidget:AddChild(Text(FONT,FONT_SIZE))
            buffWidget.myStr:SetPosition(0,-MARGIN)
            buffWidget.myStr:SetHAlign(ANCHOR_MIDDLE)
            buffWidget.myStr:SetString(buff.str)
            buffWidget:SetPosition(LEFT_OFFSET , TOP_OFFSET - i * (FONT_SIZE + MARGIN))

            table.insert(self.root.buffs.items, buffWidget)
        end)
    end

    self.listUpdated = false
end

return Root
