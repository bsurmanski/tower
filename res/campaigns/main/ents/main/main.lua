--
-- main actor 
--
--

local M = {}

M.__init = function()
    MAIN = Actor.register {
        SpriteSheet = ENT_FOLDER .. "/main/tash.tga",
        Frames = 1,
        Sides = 2,
        Sprite = {
            Texture = ENT_FOLDER .. "/main/tash.tga",
            Sides = {
                Frames = 
                {
                    {HEAD = {X = 10, Y = 10, ROTATION = 0.0},
                     LARM = {X = 10, Y = 20, ROTATION = 0.0},
                     RARM = {X = 16, Y = 20, ROTATION = 0.0}}, 
                }
            },
        },
        Name = "Tash",
        Description = "The main character!",
        Update = test,
        Update = function(self, dt)
            self:health(self.wealth);
            if(not (Actor.focus() == self)) then 
                Actor.move(self, 2 * dt, 0, 0); 
            end 
        end,
    }
end

return M
