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
        --drop = Item.new(DROPLET);
        --droppos = Vector.new(self:position());
        --droppos:y(droppos:y() + 1);
        --drop:position(droppos);
    end
};

FOUNTAIN = Model.register(FOUNTAIN_MODEL);
