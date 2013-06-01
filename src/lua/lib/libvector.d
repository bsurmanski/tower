/**
 * libvector.d
 * tower
 * June 1, 2013
 * Brandon Surmanski
 */

module lua.lib.libvector;

import std.stdio;
import c.lua;

import math.vector;
import entity.luaEntity;
import entity.entity;
import lua.api;
import lua.luah;

immutable Api libvector = {
    "Vector",
    [
        {"new", &libvector_new},
        {"x", &libvector_x},
        {"y", &libvector_y},
        {"z", &libvector_z},
        /*{"w", &libvector_w},*/
        {"data", &libvector_data},
    ],
    []
};



extern (C):

int libvector_new(lua_State *l)
{
    //Vec3 vector = new Vec3(0,0,0);
    //TODO
    return 0;
}

int libvector_x(lua_State *l)
{
    Vec3 *vector = cast(Vec3*) lua_touserdata(l, 1);
    if(lua_isnumber(l,2))
    {
        vector.x = lua_tonumber(l, 2); 
        lua_pop(l, 1);
    }

    lua_pushnumber(l, vector.x);
    return 1;
}

int libvector_y(lua_State *l)
{
    Vec3 *vector = cast(Vec3*) lua_touserdata(l, 1);
    if(lua_isnumber(l,2))
    {
        vector.y = lua_tonumber(l, 2); 
        lua_pop(l, 1);
    }

    lua_pushnumber(l, vector.y);
    return 1;
}

int libvector_z(lua_State *l)
{
    Vec3 *vector = cast(Vec3*) lua_touserdata(l, 1);
    if(lua_isnumber(l,2))
    {
        vector.z = lua_tonumber(l, 2); 
        lua_pop(l, 1);
    }

    lua_pushnumber(l, vector.z);
    return 1;
}

/*
int libvector_w(lua_State *l)
{
    Vec3 *vector = cast(Vec3*) lua_touserdata(l, 1);
    if(lua_isnumber(l,2))
    {
        vector.w = lua_tonumber(l, 2); 
        lua_pop(l, 1);
    }

    lua_pushnumber(l, vector.w);
    return 1;
}*/

int libvector_data(lua_State *l)
{
    Vec3 *vector = cast(Vec3*) lua_touserdata(l, 1);
    if(lua_istable(l,2))
    {
        float data[3] = [
            table_get(l, 2, 0, 0.0),
            table_get(l, 2, 1, 0.0),
            table_get(l, 2, 2, 0.0)];
            vector.data = data;
            lua_pop(l, 1);
    }

    lua_newtable(l);
    table_set(l, -1, 0, vector.x);
    table_set(l, -1, 1, vector.y);
    table_set(l, -1, 2, vector.z);
    return 1;
}
