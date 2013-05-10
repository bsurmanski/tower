/**
 * lua.lib.actor.d
 * tower
 * April 29, 2013
 * Brandon Surmanski
 */

module lua.lib.libactor;

import std.stdio;
import c.lua;

import gl.glb.glb;
import lua.api;
import lua.luah;
import entity.actor;
import lua.lib.libentity;

immutable Api libactor = {
    "actor",
    [
        {"register", &libactor_register},
        {"new", &libactor_new},
        {"move", &libentity_move},
        {"moveTo", &libentity_moveTo},
    ],
    []
};

extern (C):
int libactor_register(lua_State *l)
{
    string name    = table_get!string(l, 1, "Name", "");
    string desc    = table_get!string(l, 1, "Description", "");
    string texture = table_get!string(l, 1, "Sprite", "res/campaigns/main/items/unknown.tga");
    bool isMain    = table_get!bool(l, 1, "Main", false);
    ActorInfo info = new ActorInfo(name, desc, texture, isMain);
    lua_pushinteger(l, info.id);
    return 1;
}

int libactor_new(lua_State *l)
{
    int typeId = cast(int) lua_tointeger(l, 1);
    Actor ent = new Actor(typeId);
    lua_pushlightuserdata(l, cast(void*) ent);
    return 1;
}
