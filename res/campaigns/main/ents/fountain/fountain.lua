--
-- Fountain Model
--
--

require("ents.fountain.droplet");

local M = {}

local T = 0

local FOUNTAIN_MODEL = {
    Model = ENT_FOLDER .. "/fountain/fountain.mdl",
    Texture = ENT_FOLDER .. "/fountain/fountain.tga",
    Name = "Fountain",
    Description = "A beautiful fountain",
    Update = function(self, dt)
        T = T + dt;
        if(math.floor(T) % 2 == 1 and math.floor(T * 10) % 2 == 1 and  math.floor(T * 100) % 2 == 1) then
        position = self:position();
        drop = Item.new(DROPLET,
                        position:x(),
                        position:y() + 2,
                        position:z());
            end
    end
}

M.__init = function()
    Fountain = Model.register(FOUNTAIN_MODEL)
end

return M
