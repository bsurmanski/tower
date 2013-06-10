/**
 * module.d
 * tower
 * June 06, 2013
 * Brandon Surmanski
 */

module lua.luaModule;

import c.lua;
import c.lauxlib;

import std.string;

import lua.luah;
import lua.state;


class LuaModule
{
    this(State state, string filenm)
    {
        lua_State *l = state.state;
        luaL_loadfile(l, filenm.toStringz());
        lua_call(l, 0, 1);

        if(lua_istable(l, -1))
        {
            lua_getfield(l, -1, "__init"); // if module has __init method, call it
            if(lua_isfunction(l, -1))
            {
                lua_call(l, 0, 0); 
            } else
            {
                lua_pop(l, 1);
            }
            register_top(l, cast(void*) this); // register table into registry
        } else
        {
            lua_pop(l, 1);
        }
    }
}
