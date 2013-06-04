--
-- Droplet
--

DROPLET_ITEM = {
    Sprite = ENT_FOLDER .. "/droplet/droplet.tga",
    Name = "Droplet",
    Description = "A little drop of water",
    New = function(self)
        self:acceleration(0, -4.0, 0);
        self:velocity((math.random() - 0.5),
                      1.5,
                      (math.random() - 0.5));
    end,

    Update = function(self, dt)
        if(self:position():y() < 0) then
            self:destroy()
        end
    end,
};

DROPLET = Item.register(DROPLET_ITEM);
