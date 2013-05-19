/**
 * lua.luah.d
 * tower
 * April 30, 2013
 * Brandon Surmanski
 */

module lua.luah;

import std.conv;
import std.c.string;
import std.string;
import c.lua;

T table_get(T)(lua_State *l, int table_index, string field, T d)
if (is(T == float) || 
   is(T == double) ||
   is(T == real) ||
   is(T == int) ||
   is(T == uint))
{
    if(!lua_istable(l, table_index)) return d;
    T ret = d;
    lua_getfield(l, table_index, field.toStringz());

    if(lua_isnumber(l, -1))
    {
        ret = cast(T) lua_tonumber(l, -1);
    }

    lua_pop(l, 1);
    return ret;
} 

T table_get(T)(lua_State *l, int table_index, string field, T d)
if(is(T == string))
{
    if(!lua_istable(l, table_index)) return d;

    T ret = d;
    lua_getfield(l, table_index, field.toStringz());
    if(lua_isstring(l, -1))
    {
        ret = to!string(lua_tostring(l, -1));
    }

    lua_pop(l, 1);
    return ret;
}

T table_get(T)(lua_State *l, int table_index, string field, T d)
if(is(T == bool))
{
    if(!lua_istable(l, table_index)) return d;

    T ret = d;
    lua_getfield(l, table_index, field.toStringz());
    if(lua_isboolean(l, -1))
    {
        ret = cast(T) lua_toboolean(l, -1);
    }

    lua_pop(l, 1);
    return ret;
}

T table_get(T)(lua_State *l, int table_index, string field, T d)
if(is(T == void*))
{
    if(!lua_istable(l, table_index)) return d;

    T ret = d;
    lua_getfield(l, table_index, field.toStringz());
    if(lua_isuserdata(l, -1) || lua_isfunction(l,-1))
    {
        ret = cast(T) lua_topointer(l, -1);
    }

    lua_pop(l, 1);
    return ret;
}

alias table_get!string table_getstring;
alias table_get!int    table_getinteger;
alias table_get!float  table_getfloat;
alias table_get!bool   table_getboolean;
alias table_get!(void*)table_getuserdata;
