--
-- Gold item
--

GOLD_ITEM = {
    Type = Item.Misc, 
    Autopickup = true,
    Sprite = ENT_FOLDER .. "/gold/gold.tga",
    Name = "Gold",
    Description = "Yarrr, delicious gold",
    Collide = function(self, other, dt)
        if(other == Actor.focus()) then
            other:wealth(other:wealth() + 1)
            self:destroy()
        end
    end,
};

GOLD = Item.register(GOLD_ITEM);
