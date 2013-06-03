--
-- Fountain Model
--
--

require(ENT_MODULE .. ".droplet.droplet");

FOUNTAIN_MODEL = {
    Model = ENT_FOLDER .. "/fountain/fountain.mdl",
    Texture = ENT_FOLDER .. "/fountain/fountain.tga",
    Name = "Fountain",
    Description = "A beautiful fountain",
    Update = function(self, dt)
        position = self:position();
        drop = Item.new(DROPLET,
                        position:x(),
                        position:y() + 2,
                        position:z() - 2);
    end
};

FOUNTAIN = Model.register(FOUNTAIN_MODEL);
