/**
 * libentity_tmpl.d
 * tower
 * June 01, 2013
 * Brandon Surmanski
 */

module lua.lib.libentity_tmpl;

import c.lua;
import entity.luaEntity;
import entity.entity;
import entity.actor;
import entity.item;
import lua.luah;
import lua.luaValue;

void lua_push(T)(lua_State *l, T value)
if(is(Entity == T) || is(LuaEntity == T)) //TODO: change to all classes dirived from Entity
{
    import entity.actor;
    import entity.item;
    import std.stdio;
    lua_pushlightuserdata(l, cast(void*) value);
    if(cast(Actor) value)
    {
        lua_getglobal(l, "Actor");
        lua_setmetatable(l, -2);
    } else if(cast(Item) value)
    {
        lua_getglobal(l, "Item");
        lua_setmetatable(l, -2);
    } else
    {
        lua_getglobal(l, "Entity");
        lua_setmetatable(l, -2);
    }
}
