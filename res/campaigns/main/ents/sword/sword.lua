--
-- Shield
--

local M = {}

M.__init = function()
    SWORD = Item.register{
        Type = Item.Secondary, 
        Sprite = ENT_FOLDER .. "/sword/sword.tga",
        Sides = 1,
        Name = "Sword",
        Description = "Sharp and pointy at the end. Perfect for roasting marshmallows!",
    }
end

return M
