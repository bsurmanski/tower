--
-- pot
--

local M = {}

M.__init = function()
    POT_FRAG1 = Item.register {
        Type = Item.Misc, 
        Sprite = ENT_FOLDER .. "/pot/frag1.tga",
        Name = "Fragment",
        Description = "Look out! a sharp fragment!",
        New = function(self)
            self:vrotation((math.random() - 0.5) * 10)
        end,
        Update = function(self, dt)
            if(self:position():y() <= 0) then
                self:destroy()
            end
        end
    }

    POT_FRAG2 = Item.register {
        Type = Item.Misc, 
        Sprite = ENT_FOLDER .. "/pot/frag2.tga",
        Name = "Fragment",
        Description = "Look out! a sharp fragment!",
        New = function(self)
            self:vrotation((math.random() - 0.5) * 10)
        end,
        Update = function(self, dt)
            if(self:position():y() <= 0) then
                self:destroy()
            end
        end
    }

    POT_FRAG3 = Item.register {
        Type = Item.Misc, 
        Sprite = ENT_FOLDER .. "/pot/frag3.tga",
        Name = "Fragment",
        Description = "Look out! a sharp fragment!",
        New = function(self)
            self:vrotation((math.random() - 0.5) * 10)
        end,
        Update = function(self, dt)
            if(self:position():y() <= 0) then
                self:destroy()
            end
        end
    }

    POT_FRAG4 = Item.register {
        Type = Item.Misc, 
        Sprite = ENT_FOLDER .. "/pot/frag4.tga",
        Name = "Fragment",
        Description = "Look out! a sharp fragment!",
        New = function(self)
            self:vrotation((math.random() - 0.5) * 10)
        end,
        Update = function(self, dt)
            if(self:position():y() <= 0) then
                self:destroy()
            end
        end
    }
end

return M
