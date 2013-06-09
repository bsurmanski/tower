--
-- Shield
--

local M = {}

M.__init = function()
    SHIELD_ITEM = {
        Type = Item.Secondary, 
        Sprite = ENT_FOLDER .. "/shield/shield.tga",
        Sides = 2,
        Name = "Shield",
        Description = "A fancy shield to keep you safe",
        Collide = function(self, other, dt)
            if(other == Actor.focus()) then
                --self:destroy()
            end
        end,
    }

    SHIELD = Item.register(SHIELD_ITEM)
end

return M
