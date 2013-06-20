/**
 * lua.luah.d
 * tower
 * April 30, 2013
 * Brandon Surmanski
 */

module lua.luah;

import std.traits;
import std.conv;
import std.c.string;
import std.string;
import c.lua;

/*
 * lua is
 */

bool lua_is(T)(lua_State *l, int index)
if(isNumeric!T)
{
    return cast(bool) lua_isnumber(l, -1);
}

bool lua_is(T)(lua_State *l, int index)
if(isSomeString!T)
{
    return cast(bool) lua_isstring(l, -1);
}

bool lua_is(T)(lua_State *l, int index)
if(isBoolean!T)
{
    return cast(bool) lua_isboolean(l, -1);
}

bool lua_is(T)(lua_State *l, int index)
if(isPointer!T)
{
    return cast(bool) lua_islightuserdata(l, -1);
}

/*
 * lua to
 */

T lua_to(T)(lua_State *l, int index)
if(isFloatingPoint!T)
{
    return cast(T) lua_tonumber(l, index); 
}

T lua_to(T)(lua_State *l, int index)
if(isIntegral!T)
{
    return cast(T) lua_tointeger(l, index);
}

T lua_to(T)(lua_State *l, int index)
if(isSomeString!T)
{
    return to!string(lua_tostring(l, index)); 
}

T lua_to(T)(lua_State *l, int index)
if(isBoolean!T)
{
    return cast(T) lua_toboolean(l, index); 
}

T lua_to(T)(lua_State *l, int index)
if(isPointer!T)
{
    return cast(T) lua_topointer(l, index); 
}

/*
T lua_to(T)(lua_State *l, int index)
if(is(T == class))
{
    return cast(T) lua_touserdata(l, index);
}*/

/*
 * lua push
 */

void lua_push(T)(lua_State *l, T value)
if(is(T == void*))
{
    lua_pushlightuserdata(l, value);
}

/*
void lua_push(T)(lua_State *l, T value)
if(is(T == class))
{
    lua_pushlightuserdata(l, cast(void*) value);
}*/

void lua_push(T)(lua_State *l, T value)
if(isIntegral!T)
{
    lua_pushinteger(l, value);
}

void lua_push(T)(lua_State *l, T value)
if(isFloatingPoint!T)
{
    lua_pushnumber(l, value);
}

void lua_push(T)(lua_State *l, T value)
if(isBoolean!T)
{
    lua_pushboolean(l, value);
}

void lua_push(T)(lua_State *l, T value)
if(isSomeString!T)
{
    lua_pushstring(l, value.toStringz());
}

void lua_push(T)(lua_State *l, T value)
if(isSomeFunction!T)
{
    lua_pushcfunction(l, value); //TODO: not sure if this will work with D functions
}

T table_get(T)(lua_State *l, int table_index, string field, T d)
{
    if(!lua_istable(l, table_index)) return d;
    T ret = d;
    lua_getfield(l, table_index, field.toStringz());

    if(lua_is!T(l, -1))
    {
        ret = lua_to!T(l, -1);
    }

    lua_pop(l, 1);
    return ret;
} 

T table_get(K, T)(lua_State *l, int table_index, K key, T d)
{
    if(!lua_istable(l, table_index)) return d;
    T ret = d;
    lua_push(l, key);
    lua_gettable(l, table_index);
    if(lua_is!T(l, -1))
    {
        ret = lua_to!T(l, -1);
    }
    lua_pop(l, 1);
    return ret;
}

void table_set(K, T)(lua_State *l, int table_index, K key, T value)
{
    lua_push(l, key);
    lua_push(l, value);
    lua_settable(l, table_index);
}

void register_top(K)(lua_State *l, K key)
{
    lua_push(l, key);
    lua_pushvalue(l, -2);
    lua_settable(l, LUA_REGISTRYINDEX);
    lua_pop(l, 1);
}

alias table_get!string table_getstring;
alias table_get!int    table_getinteger;
alias table_get!float  table_getfloat;
alias table_get!bool   table_getboolean;
alias table_get!(void*)table_getuserdata;
