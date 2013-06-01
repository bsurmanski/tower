/**
 * libvector_tmpl.d
 * tower
 * June 01, 2013
 * Brandon Surmanski
 */

module lua.lib.libvector_tmpl;

import c.lua;
import math.vector;
import lua.luah;

void lua_push(T)(lua_State *l, T value)
if(is(T == Vec3*))
{
    lua_pushlightuserdata(l, cast(void*) value);
    lua_getglobal(l, "Vector");
    lua_setmetatable(l, -2);
}
