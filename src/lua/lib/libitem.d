
module lua.lib.libitem;

import std.stdio;
import c.lua;

import gl.glb.glb;
import lua.api;
import lua.luah;
import entity.item;
import lua.lib.libentity;

immutable Api libitem = {
    "item",
    // functions
    [
        {"register", &libitem_register},
        {"new", &libitem_new},
        {"move", &libentity_move},
        {"moveTo", &libentity_moveTo},
    ],
    // constants
    [
        {"Main",        LUA_TNUMBER, 0},
        {"Secondary",   LUA_TNUMBER, 1},
        {"Potion",      LUA_TNUMBER, 2},
        {"Misc",        LUA_TNUMBER, 3},
    ]
};

extern(C):

static int libitem_register(lua_State *l)
{
    int type =          table_get!int(l, 1, "Type", 0);
    bool autopickup =   table_get!bool(l, 1, "Autopickup", false);
    string texture  =   table_get!string(l, 1, "Sprite", "res/campaigns/main/items/unknown.tga");
    string name     =   table_get!string(l, 1, "Name", "");
    string desc     =   table_get!string(l, 1, "Description", "");

    ItemInfo info = new ItemInfo(name, desc, texture); ///< automatically registers itself
    lua_pushinteger(l, info.id);
    return 1;
}

static int libitem_new(lua_State *l)
{
    int typeId = cast(int) lua_tointeger(l, 1);
    Item ent = new Item(typeId);
    lua_pushlightuserdata(l, cast(void*) ent);
    return 1;
}
