--
-- Bed Model
--
--

local M = {}

local T = 0


M.__init = function()
    BED = Model.register {
        Model = ENT_FOLDER .. "/bed/bed.mdl",
        Texture = ENT_FOLDER .. "/bed/bed.tga",
        Name = "Bed",
        Description = "A terribly comfortable bed. But, this is no time to sleep!",
    }
end

return M
