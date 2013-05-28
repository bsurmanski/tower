/**
 * modelEntity.d
 * tower
 * May 27, 2013
 * Brandon Surmanski
 */

module entity.modelEntity;

import c.lua;

import container.geom.model;
import entity.luaEntity;
import entity.entity;
import camera;

class ModelInfo : LuaEntityInfo
{
    Model _model;

    this(lua_State *l)
    {
        super(l);
    }
}

class ModelEntity : LuaEntity
{
    this()
    {
        super(0); 
    }

    override void draw(Camera cam)
    {}

    override void update(float dt)
    {
        super.update(dt);
    }
}
