-- global lua file for this campaign
--

ITEMS_MODULE = CAMPAIGN_MODULE .. ".items"
ITEMS_FOLDER = CAMPAIGN_FOLDER .. "/items"

ACTORS_MODULE = CAMPAIGN_MODULE .. ".actors"
ACTORS_FOLDER = CAMPAIGN_FOLDER .. "/actors"

require(ITEMS_MODULE .. ".load");
require(ACTORS_MODULE .. ".load");

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
