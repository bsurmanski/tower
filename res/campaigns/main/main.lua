-- global lua file for this campaign
--

ENT_MODULE = CAMPAIGN_MODULE .. ".ents"
ENT_FOLDER = CAMPAIGN_FOLDER .. "/ents"

require(ENT_MODULE .. ".load");

mainActor = Actor.new(MAIN);
Actor.focus(mainActor);
mainActor:moveTo(0, 0, 0);
mainActor:wealth();

secondActor = Actor.new(MAIN);
secondActor:moveTo(1, 0, 3);

Item.new(GOLD):moveTo(0, 0, 5);
Item.new(GOLD):moveTo(0, 0, 6);
Item.new(GOLD):moveTo(2, 0, 6);
Item.new(GOLD):moveTo(6, 0, 6);
Item.new(SHIELD):moveTo(7, 0, 6);

Model.new(FOUNTAIN):moveTo(3, 0, 1);
