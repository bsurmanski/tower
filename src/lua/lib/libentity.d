/**
 * libentity.d
 * tower
 * April 30, 2013
 * Brandon Surmanski
 */

module lua.lib.libentity;

import std.stdio;
import c.lua;

import math.vector;
import entity.luaEntity;
import entity.entity;
import lua.api;
import lua.luah;

immutable Api libentity = {
    "Entity",
    [
        {"move", &libentity_move},
        {"moveTo", &libentity_moveTo},
        {"info", &libentity_info},
        {"destroy", &libentity_destroy},
    ],
    []
};

//TODO: messy!
void lua_push(T)(lua_State *l, T value)
if(is(Entity == T) || is(LuaEntity == T)) //TODO: change to all classes dirived from Entity
{
    import entity.actor;
    import entity.item;
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


extern (C):

int libentity_move(lua_State *l)
{
    Entity ent = cast(Entity) lua_touserdata(l, 1);
    Vec3 offset;
    offset.x = lua_tonumber(l, 2);
    offset.y = lua_tonumber(l, 3);
    offset.z = lua_tonumber(l, 4);

    if(ent)
    {
        ent.position = ent.position + offset;
    }
    return 0;
}

int libentity_moveTo(lua_State *l)
{
    Entity ent = cast(Entity) lua_touserdata(l, 1);
    Vec3 offset;
    offset.x = lua_tonumber(l, 2);
    offset.y = lua_tonumber(l, 3);
    offset.z = lua_tonumber(l, 4);

    if(ent)
    {
        ent.position = offset;
    }
    return 0;
}

int libentity_info(lua_State *l)
{
    Entity ent = cast(Entity) lua_touserdata(l, 1);
    lua_pushlightuserdata(l, cast(void*) ent.info);
    lua_gettable(l, LUA_REGISTRYINDEX);
    return 1;
}

int libentity_destroy(lua_State *l)
{
    Entity ent = cast(Entity) lua_touserdata(l, 1);
    ent.marked = true;
    writeln("destroying...");
    return 0;
}
