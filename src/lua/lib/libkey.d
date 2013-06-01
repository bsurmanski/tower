/**
 * libkey.d
 * tower
 * May 23, 2013
 * Brandon Surmanski
 */

module lua.lib.libkey;

import c.lua;
import lua.api;
import lua.luah;
import keys;

immutable Api libkey =
{
    "Key",
    [
        {"bind", &libkey_bind},
        {"setEnable", &libkey_setEnable},
    ],
    keyConsts 
};

extern(C):
int libkey_setEnable(lua_State *l)
{
    int enable = cast(int) lua_tointeger(l, 1); 
    //key_setEnable(enable);
    return 0;
}

int libkey_bind(lua_State *l)
{
    int action = cast(int) lua_tointeger(l, 1); 
    int key = cast(int) lua_tointeger(l, 2);
    //key_set(action, key);
    return 0;
}

enum
{
    GAME_PAUSE,
    GAME_SELECT,
    GAME_CANCEL,
    GAME_UP,
    GAME_DOWN,
    GAME_LEFT,
    GAME_RIGHT,
    ACTOR_MOVE_UP,
    ACTOR_MOVE_DOWN,
    ACTOR_MOVE_LEFT,
    ACTOR_MOVE_RIGHT,
    ACTOR_JUMP,
    ACTOR_MAIN_ATTACK,
    ACTOR_SECONDARY_ATTACK,
    ACTOR_DRINK_POTION,
    ACTOR_NEXT_ITEM,
    ACTOR_PREV_ITEM,
}

static immutable LuaConst keyConsts[] =
[
    {"PAUSE", LUA_TNUMBER, GAME_PAUSE},
    {"MENU_SELECT", LUA_TNUMBER, GAME_SELECT},
    {"MENU_CANCEL", LUA_TNUMBER, GAME_CANCEL},
    {"MENU_UP", LUA_TNUMBER, GAME_UP},
    {"MENU_DOWN", LUA_TNUMBER, GAME_DOWN},
    {"MENU_LEFT", LUA_TNUMBER, GAME_LEFT},
    {"MENU_RIGHT", LUA_TNUMBER, GAME_RIGHT},
    {"UP", LUA_TNUMBER, ACTOR_MOVE_UP},
    {"DOWN", LUA_TNUMBER, ACTOR_MOVE_DOWN},
    {"LEFT", LUA_TNUMBER, ACTOR_MOVE_LEFT},
    {"RIGHT", LUA_TNUMBER, ACTOR_MOVE_RIGHT},
    {"JUMP", LUA_TNUMBER, ACTOR_JUMP},
    {"MAIN_ATTACK", LUA_TNUMBER, ACTOR_MAIN_ATTACK},
    {"SECONDARY_ATTACK", LUA_TNUMBER, ACTOR_SECONDARY_ATTACK},
    {"DRINK_POTION", LUA_TNUMBER, ACTOR_DRINK_POTION},
    {"NEXT_ITEM", LUA_TNUMBER, ACTOR_NEXT_ITEM},
    {"PREV_ITEM", LUA_TNUMBER, ACTOR_PREV_ITEM},
];


