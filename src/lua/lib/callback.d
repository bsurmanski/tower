/**
 * callback.d
 * tower
 * May 23, 2013
 * Brandon Surmanski
 */

module lua.lib.callback;

import std.traits;
import std.string;

import lua.lib.libentity_tmpl; // for entity push
import lua.lib.libvector_tmpl; // for vector push

import c.lua;
import lua.luah;
import math.vector;
import entity.entity;
import entity.actor;

/**
 * TODO: add callbacks:
 * new(self)
 * delete(self)
 * update(self, dt)
 * collide(self, other)
 * damage(self, cause)
 * die(self)
 * pickup(self, cause)
 * use(self, user)
 */

/*
void lua_push(T)(lua_State *l, T value)
if(is(T == class))
{
    lua_pushlightuserdata(l, cast(void*) value);
    lua_getglobal(l, "Actor");
    lua_setmetatable(l, -2);
}*/


/**
 * expects that the callback function is in a table found within the lua registry.
 * @param l the lua state to call the function within
 * @param key the index into the registry to find the table containing the callback function
 * @param funcname the key into the table which the callback function resides
 * @param args the arguments which to call the function with.
 * 
 * There is no returned results from the lua function
 */
void lua_callback(U, T...)(lua_State *l, U key, string funcname, T args)
{
    lua_push(l, cast(void*) key);
    lua_gettable(l, LUA_REGISTRYINDEX);
    if(!lua_istable(l, -1)) { lua_pop(l, 1); return; } //no callback, pop and return
    lua_getfield(l, -1, funcname.toStringz());
    if(!lua_isfunction(l, -1)) { lua_pop(l, 2); return;} //no callback, pop and return

    // push arguments to stack
    foreach(arg; args)
    {
        lua_push(l, arg);
    }

    lua_call(l, args.length, 0);
    lua_pop(l, 1); // pop table from stack
}
