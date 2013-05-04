--
-- main actor 
--

MAIN_ACTOR = {
    Sprite = ACTORS_FOLDER .. "/main/tash.tga",
    Name = "Tash",
    Description = "The main character!",
    Main = true,
};

MAIN = actor.register(MAIN_ACTOR);
