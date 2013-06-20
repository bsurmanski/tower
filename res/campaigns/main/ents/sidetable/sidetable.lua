--
-- Bed Model
--
--

local M = {}

local T = 0


M.__init = function()
    SIDETABLE = Model.register {
        Model = ENT_FOLDER .. "/sidetable/sidetable.mdl",
        Texture = ENT_FOLDER .. "/sidetable/sidetable.tga",
        Name = "Sidetable",
        Description = "A small table",
    }
end

return M
