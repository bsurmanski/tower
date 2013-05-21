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
import entity.entity;
import lua.api;
import lua.luah;

immutable Api libentity = {
    "Entity",
    [
        {"move", &libentity_move},
        {"moveTo", &libentity_moveTo},
        {"info", &libentity_info},
    ],
    []
};

void lua_update(Entity entity, float dt)
{
    EntityInfo info = entity.info;
    lua_State *l = info.luastate;

    lua_pushlightuserdata(l, cast(void*) (entity.info));
    lua_gettable(l, LUA_REGISTRYINDEX);
    import std.stdio;
    if(!lua_istable(l, -1)) { lua_pop(l, 1); return; }
    lua_getfield(l, -1, "Update");
    if(!lua_isfunction(l, -1))
    {
        lua_pop(l, 2);
        return;
    }
    lua_pushlightuserdata(l, cast(void*) entity); //self
    lua_pushvalue(l, -3); // copy of TABLE
    lua_pushnumber(l, dt);
    lua_call(l, 3, 0); // Update(self, REGTABLE, dt);
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
