/**
 * lua.lib.actor.d
 * tower
 * April 29, 2013
 * Brandon Surmanski
 */

module lua.lib.libactor;

import std.string;
import std.stdio;
import c.lua;

import gl.glb.glb;
import lua.api;
import lua.luah;
import entity.entity;
import entity.actor;
import lua.lib.libentity;

immutable Api libactor = {
    "Actor",
    [
        {"register", &libactor_register},
        {"new", &libactor_new},
        {"focus", &libactor_focus},
        {"wealth", &libactor_wealth},
        {"health", &libactor_health},
    ],
    [],
    &libentity,
};

extern (C):
int libactor_register(lua_State *l)
{
    string spriteSheet = table_get!string(l, 1, "SpriteSheet", "res/campaigns/main/items/unknown.tga");
    int sides = table_get!int(l, 1, "Sides", 1);
    int frames = table_get!int(l, 1, "Frames", 1);
    ActorInfo info = new ActorInfo(l, spriteSheet);

    // add parameter table to registry (key of ActorInfo)
    // XXX if the D GC becomes a moving GC, then using the info pointer as the key may be invalid
    lua_pushlightuserdata(l, cast(void*) info);
    lua_pushvalue(l, 1);
    lua_settable(l, LUA_REGISTRYINDEX);

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

int libactor_health(lua_State *l)
{
    Actor actor = cast(Actor)cast(Entity)lua_touserdata(l, 1);
    if(!actor){return 0;}

    if(lua_isnumber(l, 2))
    {
        actor.health = cast(uint) lua_tointeger(l, 2);
    }

    lua_pushinteger(l, actor.health);
    return 1;
}

int libactor_wealth(lua_State *l)
{
    Actor actor = cast(Actor)cast(Entity)lua_touserdata(l, 1);
    if(!actor){return 0;}

    if(lua_isnumber(l, 2))
    {
        actor.wealth = cast(uint) lua_tointeger(l, 2);
    }

    lua_pushinteger(l, actor.health);
    return 1;
}

int libactor_new(lua_State *l)
{
    int typeId = cast(int) lua_tointeger(l, 1);
    Actor ent = new Actor(typeId);
    lua_pushlightuserdata(l, cast(void*) ent);
    lua_getglobal(l, "Actor"); //set metatable for actor
    lua_setmetatable(l, -2);
    return 1;
}
