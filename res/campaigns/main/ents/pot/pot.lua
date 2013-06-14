--
-- pot
--

local M = {}

M.__init = function()
    POT = Item.register {
        Type = Item.Secondary, 
        Sprite = ENT_FOLDER .. "/pot/pot.tga",
        Name = "Pot",
        Description = "A stylish, yet fragile pot",
        Collide = function(self, other, dt)
            if(other == Actor.focus()) then
            end
        end,
        Update = function(self, dt)
            if(self:velocity():y() < -2 and self:position():y() <= 0) then
                pos = self:position()
                fragtypes = {POT_FRAG1, POT_FRAG2, POT_FRAG3, POT_FRAG4}
                
                -- spawn fragments on break
                for i = 0, 5, 1 do
                    fragindex = math.random(1, 4) -- 1 to 4
                    fragtype = fragtypes[fragindex]
                    frag = Item.new(fragtype, pos:x(), 0.05, pos:z());
                    frag:velocity(math.random(-1.0, 1.0), 
                                  math.random(1.0, 2.0), 
                                  math.random(-1.0, 1.0))
                end
                self:destroy()
            end
        end
    }
end

return M
