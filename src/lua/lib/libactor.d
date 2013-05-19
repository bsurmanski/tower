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
        {"focus", &libactor_focus},
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
    string spriteSheet = table_get!string(l, 1, "SpriteSheet", "res/campaigns/main/items/unknown.tga");
    int sides = table_get!int(l, 1, "Sides", 1);
    int frames = table_get!int(l, 1, "Frames", 1);
    ActorInfo info = new ActorInfo(name, desc, spriteSheet);
    lua_pushinteger(l, info.id);
    return 1;
}

int libactor_focus(lua_State *l)
{
    if(lua_isuserdata(l, 1))
    {
        Actor ent = cast(Actor) lua_touserdata(l, 1);
        Actor.focus = ent;
    }

    lua_pushlightuserdata(l, cast(void*) Actor.focus);
    return 1;
}

int libactor_new(lua_State *l)
{
    int typeId = cast(int) lua_tointeger(l, 1);
    Actor ent = new Actor(typeId);
    lua_pushlightuserdata(l, cast(void*) ent);
    return 1;
}
