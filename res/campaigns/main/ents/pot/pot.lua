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
                local pos = self:position()
                local fragtypes = {POT_FRAG1, POT_FRAG2, POT_FRAG3, POT_FRAG4}
                
                -- spawn fragments on break
                for i = 0, 5, 1 do
                    local fragindex = math.random(1, 4) -- 1 to 4
                    local fragtype = fragtypes[fragindex]
                    local frag = Item.new(fragtype, pos:x(), pos:y(), pos:z());
                    frag:velocity(4 * math.random() - 2, 
                                  1 + math.random(), 
                                  4 * math.random() - 2)
                end

                for i = 0, math.random(3), 1 do
                local goodie = Item.new(GOLD, pos:x(), 0.05, pos:z());
                goodie:velocity(2 * math.random() - 1, 
                              1 + math.random(), 
                              2 * math.random() - 1)
                end
                self:destroy()
            end
        end
    }
end

return M
