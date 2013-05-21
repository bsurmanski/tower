--
-- Gold item
--

GOLD_ITEM = {
    Type = Item.Misc, 
    Autopickup = true,
    Sprite = ITEMS_FOLDER .. "/gold/gold.tga",
    Name = "Gold",
    Description = "Yarrr, delicious gold",
};

GOLD = Item.register(GOLD_ITEM);
