
module lua.lib.libitem;

import std.stdio;
import c.lua;

import gl.glb.glb;
import lua.api;
import lua.luah;
import lua.lib.libentity;
import entity.item;
import math.vector;

immutable Api libitem = {
    "Item",
    // functions
    [
        {"register", &libitem_register},
        {"new", &libitem_new},
    ],
    // constants
    [
        {"Main",        LUA_TNUMBER, 0},
        {"Secondary",   LUA_TNUMBER, 1},
        {"Potion",      LUA_TNUMBER, 2},
        {"Misc",        LUA_TNUMBER, 3},
    ],
    &libentity,
};

extern(C):

static int libitem_register(lua_State *l)
{
    int type =          table_get!int(l, 1, "Type", 0);
    bool autopickup =   table_get!bool(l, 1, "Autopickup", false);
    string texture  =   table_getstring(l, 1, "Sprite", "res/campaigns/main/items/unknown.tga");
    int frames      =   table_get!int(l, 1, "Frames", 1); //number of frames in sprite animation
    int sides       =   table_get!int(l, 1, "Sides", 1); // number of sides to the sprite
    bool shadow     =   table_get!bool(l, 1, "Shadow", true);

    ItemInfo info = new ItemInfo(l, texture, frames, sides); ///< automatically registers itself

    // add parameter table to registry (key of ActorInfo)
    lua_pushlightuserdata(l, cast(void*) info);
    lua_pushvalue(l, 1);
    lua_settable(l, LUA_REGISTRYINDEX);

    lua_pushinteger(l, info.id);
    return 1;
}

static int libitem_new(lua_State *l)
{
    int typeId = cast(int) lua_tointeger(l, 1);
    Item ent = new Item(typeId);
    lua_pushlightuserdata(l, cast(void*) ent);

    int entindex = lua_gettop(l);
    lua_getglobal(l, "Item"); //set metatable for actor
    lua_setmetatable(l, entindex);

    if(lua_isnumber(l, 2) && lua_isnumber(l, 3) && lua_isnumber(l, 4))
    {
        ent.position = Vec3(lua_tonumber(l, 2), lua_tonumber(l,3), lua_tonumber(l,4));
    }

    return 1;
}
