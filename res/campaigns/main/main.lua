-- global lua file for this campaign
--


--require(ENT_MODULE .. ".load");
--

mainActor = Actor.new(MAIN);
Actor.focus(mainActor);
mainActor:moveTo(0, 0, 0);
mainActor:wealth();

--secondActor = Actor.new(MAIN);
--secondActor:moveTo(1, 0, 3);

--Item.new(GOLD):moveTo(0, 0, 5);
--Item.new(GOLD):moveTo(0, 0, 6);
--Item.new(GOLD):moveTo(2, 0, 6);
--Item.new(SWORD):moveTo(6, 0, 6);
Item.new(SHIELD):moveTo(7, 0, 6);

--Model.new(Fountain):moveTo(3, 0, 1);
--Model.new(Fountain):moveTo(5, 0, 4);
Model.new(BED):moveTo(1, 0, 1);

--Item.new(FLOWER):moveTo(6, 0, 7);

--Item.new(POT, 8, 0, 5);
