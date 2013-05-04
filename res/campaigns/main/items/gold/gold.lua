--
-- Gold item
--

GOLD_ITEM = {
    Type = item.Misc, 
    Autopickup = true,
    Sprite = ITEMS_FOLDER .. "/gold/gold.tga",
    Name = "Gold",
    Description = "Yarrr, delicious gold",
};

GOLD = item.register(GOLD_ITEM);
