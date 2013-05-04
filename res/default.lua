--
-- default settings and configuration for the game
--

CAMPAIGN = "main" --the default campaign folder
MAIN = "main" --the default starting lua file

CAMPAIGN_FOLDER = "res/campaigns/" .. CAMPAIGN
CAMPAIGN_MODULE = "campaigns." .. CAMPAIGN
CAMPAIGN_MAIN = CAMPAIGN_MODULE .. "." .. MAIN 

items = {}

--key.bind(key.UP,    string.byte('W'));
--key.bind(key.DOWN,  string.byte('S'));
--key.bind(key.LEFT,  string.byte('A'));
--key.bind(key.RIGHT, string.byte('D'));

require(CAMPAIGN_MAIN);
