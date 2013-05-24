--
-- main actor 
--
--

MAIN = Actor.register {
    SpriteSheet = ACTORS_FOLDER .. "/main/tash.tga",
    Frames = 1,
    Sides = 2,
    Name = "Tash",
    Description = "The main character!",
    Update = test,
    Update = function(self, dt)
        self:health(self.wealth);
        if(not (Actor.focus() == self)) then 
            Actor.move(self, 2 * dt, 0, 0); 
        end 
    end,
};
