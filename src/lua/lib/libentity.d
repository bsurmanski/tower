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
    "entity",
    [
        {"move", &libentity_move},
        {"moveTo", &libentity_moveTo},
    ],
    []
};

extern (C):

int libentity_move(lua_State *l)
{
    Entity ent = cast(Entity) lua_touserdata(l, 1);
    Vector4 offset;
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
    Vector4 offset;
    offset.x = lua_tonumber(l, 2);
    offset.y = lua_tonumber(l, 3);
    offset.z = lua_tonumber(l, 4);
    offset.w = 0.0f;

    if(ent)
    {
        ent.position = offset;
    }
    return 0;
}
