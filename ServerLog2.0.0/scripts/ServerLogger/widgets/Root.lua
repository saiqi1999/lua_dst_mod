local Widget = require("widgets/widget")
local Image = require("widgets/image")
local Text = require("widgets/text")

local Constants = require("ServerLogger/Constants")
local Util = require("ServerLogger/Util")

require("constants")
require("fonts")

local LEFT_OFFSET = 800
local TOP_OFFSET = -40
local IMAGE_SIZE = 30
local MARGIN = 9
local FONT_SIZE = 18
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
        self.buffs[0] = "0"
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
        -- if(self.strs==nil)then 
        --     strT = "str=nil"
        -- end
        -- if(self.strs[0]==nil)then
        --     strT = "no object"
        -- end
        -- if(self.buffs[0]==nil)then
        --     strT = "no othe robject"
        -- end
        -- Util:ForEach(self.strs, function(strObj, i)
        --     strT = "strObj.str"
        --     if(strObj~=nil)then
        --         strT = strObj.str
        --     end
        -- end)
        Util:ForEach(self.buffs, function (buff, i)
            --print("buff+ 3")
            --strT = buff.startedAt..""
            local buffWidget = self.root.buffs:AddChild(Widget("str_index_" .. i))

            buffWidget:SetVAnchor(ANCHOR_TOP)
            buffWidget:SetHAnchor(ANCHOR_LEFT)

            -- local imageTex = Constants.BuffImagePrefab[buff.type] .. ".tex"

            -- buffWidget.bg = buffWidget:AddChild(Image(Util:GetHUDAtlas(), "inv_slot.tex"))
            -- buffWidget.bg:SetSize(IMAGE_SIZE, IMAGE_SIZE)

            -- buffWidget.image = buffWidget:AddChild(Image(Util:GetInventoryItemAtlas(imageTex), imageTex))
            -- buffWidget.image:SetSize(IMAGE_SIZE, IMAGE_SIZE)

            -- buffWidget.timeLeft = buffWidget:AddChild(Text(FONT, FONT_SIZE))
            -- buffWidget.timeLeft:SetPosition(0, -IMAGE_SIZE)
            -- buffWidget.timeLeft:SetHAlign(ANCHOR_MIDDLE)

            buffWidget.myStr = buffWidget:AddChild(Text(FONT,FONT_SIZE))
            buffWidget.myStr:SetPosition(0,-IMAGE_SIZE)
            buffWidget.myStr:SetHAlign(ANCHOR_MIDDLE)
            -- print(self.buffManager.GetStr())
            --why this is nil?
            buffWidget.myStr:SetString(buff.str)
            -- buffWidget.myStr2 = buffWidget:AddChild(Text(FONT,FONT_SIZE))
            -- buffWidget.myStr2:SetPosition(0,-IMAGE_SIZE-FONT_SIZE)
            -- buffWidget.myStr2:SetHAlign(ANCHOR_MIDDLE)
            -- -- print(self.buffManager.GetStr())
            -- --why this is nil?
            -- buffWidget.myStr2:SetString(strT)

            buffWidget:SetPosition(LEFT_OFFSET , -TOP_OFFSET - i * (FONT_SIZE + MARGIN))

            table.insert(self.root.buffs.items, buffWidget)
        end)
    end

    -- Util:ForEach(self.buffs, function (buff, i)
    --     local buffWidget = self.root.buffs.items[i]

    --     if not buffWidget then
    --         return
    --     end

        -- local timePassed = GetTime() - buff.startedAt - self.TimeDifferenceManager.timeDiff
        -- local timeLeft = math.max(0, math.floor(buff.duration - timePassed))
        -- local minutes = math.floor(timeLeft / 60)
        -- local seconds = timeLeft % 60

        -- if minutes < 10 then
        --     minutes = "0" .. minutes
        -- end

        -- if seconds < 10 then
        --     seconds = "0" .. seconds
        -- end

        -- buffWidget.timeLeft:SetString(minutes .. ":" .. seconds)
    -- end)

    self.listUpdated = false
end

return Root
