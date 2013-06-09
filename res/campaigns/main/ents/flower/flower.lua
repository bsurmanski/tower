--
-- Flower 
--

local M = {}

M.__init = function()
    local FLOWER_ITEM = {
        Sprite = ENT_FOLDER .. "/flower/flower.tga",
        Name = "Flower",
        Description = "A nice smelling flower",
    }

    FLOWER = Item.register(FLOWER_ITEM)
end

return M
