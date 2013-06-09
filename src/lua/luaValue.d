/**
 * luaValue.d
 * tower
 * June 07, 2013
 * Brandon Surmanski
 */

module lua.luaValue;

import c.lua;


interface LuaValue
{
    void push(lua_State *state);

    static final LuaValue getValue(lua_State *state, int index)
    {
        return cast(LuaValue) lua_touserdata(state, index);
    }
}
