-- global lua file for this campaign
--

ITEMS_MODULE = CAMPAIGN_MODULE .. ".items"
ITEMS_FOLDER = CAMPAIGN_FOLDER .. "/items"

ACTORS_MODULE = CAMPAIGN_MODULE .. ".actors"
ACTORS_FOLDER = CAMPAIGN_FOLDER .. "/actors"

require(ITEMS_MODULE .. ".load");
require(ACTORS_MODULE .. ".load");

mainActor = actor.new(MAIN);
actor.focus(mainActor);
actor.moveTo(mainActor, 0, 0, 0);

secondActor = actor.new(MAIN);
actor.moveTo(secondActor, 1, 0, 3);

item.moveTo(item.new(GOLD), 0, 0, 5);
item.moveTo(item.new(GOLD), 0, 0, 6);
item.moveTo(item.new(GOLD), 2, 0, 6);
item.moveTo(item.new(GOLD), 6, 0, 6);
