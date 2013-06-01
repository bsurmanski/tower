--
-- Droplet
--

DROPLET_ITEM = {
    Sprite = ENT_FOLDER .. "/droplet/droplet.tga",
    Name = "Droplet",
    Description = "A little drop of water",
    Update = function(self, dt)
        
    end
};

DROPLET = Item.register(DROPLET_ITEM);
