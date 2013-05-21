--
-- main actor 
--

MAIN = Actor.register {
    SpriteSheet = ACTORS_FOLDER .. "/main/tash.tga",
    Frames = 1,
    Sides = 2,
    Name = "Tash",
    Description = "The main character!",
    Update = function(self, info, dt) 
        if(not (Actor.focus() == self)) then 
            Actor.move(self, 0.1, 0, 0); 
        end 
    end,
};
