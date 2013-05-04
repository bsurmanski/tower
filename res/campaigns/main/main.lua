-- global lua file for this campaign
--

ITEMS_MODULE = CAMPAIGN_MODULE .. ".items"
ITEMS_FOLDER = CAMPAIGN_FOLDER .. "/items"

ACTORS_MODULE = CAMPAIGN_MODULE .. ".actors"
ACTORS_FOLDER = CAMPAIGN_FOLDER .. "/actors"

require(ITEMS_MODULE .. ".load");
require(ACTORS_MODULE .. ".load");

actor.moveTo(actor.new(MAIN, true), 0, 0, 0);

item.moveTo(item.new(GOLD), 0, 0, 5);
item.moveTo(item.new(GOLD), 0, 0, 6);
item.moveTo(item.new(GOLD), 2, 0, 6);
item.moveTo(item.new(GOLD), 6, 0, 6);
