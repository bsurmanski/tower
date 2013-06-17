--
-- Droplet
--
--

local M = {}

local DROPLET_ITEM = {
    Sprite = ENT_FOLDER .. "/fountain/droplet.tga",
    Name = "Droplet",
    Description = "A little drop of water",
    Shadow = false,
    Holdable = false,
    New = function(self)
        self:acceleration(0, -4.0, 0);
        self:velocity((math.random() - 0.5),
                      1.5,
                      (math.random() - 0.5));
        self:vrotation(4 * (math.random() - 0.5))
    end,

    Update = function(self, dt)
        if(self:position():y() < 0) then
            self:destroy()
        end
    end,
}

M.__init = function()
    DROPLET = Item.register(DROPLET_ITEM)
end

return M
