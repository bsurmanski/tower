--
-- default settings and configuration for the game
--

CAMPAIGN = "main" --the default campaign folder
MAIN = "main" --the default starting lua file

CAMPAIGN_FOLDER = "res/campaigns/" .. CAMPAIGN
CAMPAIGN_MODULE = "campaigns." .. CAMPAIGN
CAMPAIGN_MAIN = CAMPAIGN_MODULE .. "." .. MAIN 

items = {}

Key.bind(Key.UP,    string.byte('W'));
Key.bind(Key.DOWN,  string.byte('S'));
Key.bind(Key.LEFT,  string.byte('A'));
Key.bind(Key.RIGHT, string.byte('D'));

require(CAMPAIGN_MAIN);
