/**
 * libentity.d
 * tower
 * April 30, 2013
 * Brandon Surmanski
 */

module lua.lib.libentity;

import std.stdio;
import c.lua;

import lua.lib.libvector_tmpl;
import lua.lib.libentity_tmpl;
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
        {"position", &libentity_position},
    ],
    []
};

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

int libentity_position(lua_State *l)
{
    Entity ent = cast(Entity) lua_touserdata(l, 1);
    if(lua_isuserdata(l, 2))
    {
        Vec3 *newpos = cast(Vec3*) lua_touserdata(l, 2);
        ent.position = *newpos;
    }
    //TODO
    lua_push(l, &ent.position);
    return 1;
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
