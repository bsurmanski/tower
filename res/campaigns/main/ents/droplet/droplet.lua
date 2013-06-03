--
-- Droplet
--

DROPLET_ITEM = {
    Sprite = ENT_FOLDER .. "/droplet/droplet.tga",
    Name = "Droplet",
    Description = "A little drop of water",
    New = function(self)
        self:velocity((math.random() - 0.5) / 10,
                      -0.05,
                      0.05 + (math.random() - 0.5) / 10);
                      
    end,
    Update = function(self, dt)
        if(self:position():y() < 0) then
            self:destroy()
        end
    end,
};

DROPLET = Item.register(DROPLET_ITEM);
