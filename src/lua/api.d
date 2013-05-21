/**
 * api.d
 * lua
 * April 29, 2013
 * Brandon Surmanski
 */

module lua.api;

import c.lua;

struct LuaFunc
{
    string name;
    lua_CFunction func;
}

struct LuaConst
{
    string name;
    int type;
    ulong value;
}

struct Api
{
    string name;
    LuaFunc[] functions;
    LuaConst[] constants;
    Api *parent = null;
}
