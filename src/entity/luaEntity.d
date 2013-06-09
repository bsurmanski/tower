/**
 * luaEntity.d
 * tower
 * May 27, 2013
 * Brandon Surmanski
 */

module entity.luaEntity;

import c.lua;

import std.string;

import entity.entity;
import lua.luaValue;
import lua.lib.callback;


abstract class LuaEntityInfo : EntityInfo
{
    lua_State *_state = null;

    @property lua_State *luaState() { return _state; }

    this(lua_State *state)
    {
        _state = state;
        super(); 
    }
}

abstract class LuaEntity : Entity, LuaValue
{
    this(int type)
    {
        super(type);
        luaCallback("New");
    }

    override void update(float dt)
    {
        super.update(dt);
        luaCallback("Update", dt);
    }

    override void collide(Entity other, float dt)
    {
        luaCallback("Collide", other, dt);
    }

    void luaCallback(T...)(string name, T args)
    {
        lua_State *l = (cast(LuaEntityInfo)this.info).luaState; 
        lua_callback(l, this.info, name, this, args);
    }

    static string typeName()
    {
        return "Entity";
    }

    void push(lua_State *l)
    {
        lua_pushlightuserdata(l, cast(void*) this);
        lua_getglobal(l, typeName().toStringz());
        lua_setmetatable(l, -2);
    }
}
