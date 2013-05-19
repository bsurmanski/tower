--
-- main actor 
--

MAIN_ACTOR = {
    SpriteSheet = ACTORS_FOLDER .. "/main/tash.tga",
    Frames = 1,
    Sides = 2,
    Name = "Tash",
    Description = "The main character!",
    Main = true,
};

MAIN = actor.register(MAIN_ACTOR);
