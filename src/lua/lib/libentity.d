/**
 * libentity.d
 * tower
 * April 30, 2013
 * Brandon Surmanski
 */

module lua.lib.libentity;

import std.stdio;
import c.lua;

import lua.lib.libvector_tmpl;
import lua.lib.libentity_tmpl;
import math.vector;
import scene.entity.luaEntity;
import scene.entity.entity;
import lua.api;
import lua.luah;

immutable Api libentity = {
    "Entity",
    [
        {"__eq", &libentity___eq},
        {"move", &libentity_move},
        {"moveTo", &libentity_moveTo},
        {"info", &libentity_info},
        {"destroy", &libentity_destroy},
        {"position", &libentity_position},
        {"velocity", &libentity_velocity},
        {"acceleration", &libentity_acceleration},
        {"rotation", &libentity_rotation},
        {"vrotation", &libentity_vrotation},
    ],
    []
};

extern (C):

int libentity___eq(lua_State *l)
{
    Entity ent1 = cast(Entity) lua.lib.libentity_tmpl.lua_to!Entity(l, 1);
    Entity ent2 = cast(Entity) lua.lib.libentity_tmpl.lua_to!Entity(l, 2);
    lua_pushboolean(l, ent1 == ent2);
    return 1;
}

int libentity_move(lua_State *l)
{
    Entity ent = cast(Entity) lua.lib.libentity_tmpl.lua_to!Entity(l, 1);
    Vec3 offset;
    offset.x = lua_tonumber(l, 2);
    offset.y = lua_tonumber(l, 3);
    offset.z = lua_tonumber(l, 4);

    if(ent)
    {
        ent.position = ent.position + offset;
    }
    return 0;
}

int libentity_moveTo(lua_State *l)
{
    Entity ent = cast(Entity) lua.lib.libentity_tmpl.lua_to!Entity(l, 1);
    Vec3 offset;
    offset.x = lua_tonumber(l, 2);
    offset.y = lua_tonumber(l, 3);
    offset.z = lua_tonumber(l, 4);

    if(ent)
    {
        ent.position = offset;
    }
    return 0;
}

int libentity_position(lua_State *l)
{
    Entity ent = cast(Entity) lua.lib.libentity_tmpl.lua_to!Entity(l, 1);
    if(lua_isuserdata(l, 2))
    {
        Vec3 *newpos = cast(Vec3*) lua_touserdata(l, 2);
        ent.position = *newpos;
    }

    if(lua_isnumber(l, 2) && lua_isnumber(l, 3) && lua_isnumber(l, 4))
    {
        ent.position = Vec3(lua_tonumber(l, 2), lua_tonumber(l,3), lua_tonumber(l,4));
    }


    Vec3 *vec = cast(Vec3*) lua_newuserdata(l, Vec3.sizeof);
    vec.data = ent.position.data;
    lua_getglobal(l, "Vector");
    lua_setmetatable(l, -2);
    return 1;
}

int libentity_velocity(lua_State *l)
{
    Entity ent = cast(Entity) lua.lib.libentity_tmpl.lua_to!Entity(l, 1);
    if(lua_isuserdata(l, 2))
    {
        Vec3 *newvec = cast(Vec3*) lua_touserdata(l, 2);
        ent.velocity = *newvec;
    }

    if(lua_isnumber(l, 2) && lua_isnumber(l, 3) && lua_isnumber(l, 4))
    {
        ent.velocity = Vec3(lua_tonumber(l, 2), lua_tonumber(l,3), lua_tonumber(l,4));
    }

    Vec3 *vec = cast(Vec3*) lua_newuserdata(l, Vec3.sizeof);
    vec.data = ent.velocity.data;
    lua_getglobal(l, "Vector");
    lua_setmetatable(l, -2);

    return 1;
}

int libentity_acceleration(lua_State *l)
{
    Entity ent = cast(Entity) lua.lib.libentity_tmpl.lua_to!Entity(l, 1);
    if(lua_isuserdata(l, 2))
    {
        Vec3 *newvec = cast(Vec3*) lua_touserdata(l, 2);
        ent.acceleration = *newvec;
    }

    if(lua_isnumber(l, 2) && lua_isnumber(l, 3) && lua_isnumber(l, 4))
    {
        ent.acceleration = Vec3(lua_tonumber(l, 2), lua_tonumber(l,3), lua_tonumber(l,4));
    }

    Vec3 *vec = cast(Vec3*) lua_newuserdata(l, Vec3.sizeof);
    vec.data = ent.acceleration.data;
    lua_getglobal(l, "Vector");
    lua_setmetatable(l, -2);

    return 1;
}

int libentity_rotation(lua_State *l)
{
    Entity ent = cast(Entity) lua.lib.libentity_tmpl.lua_to!Entity(l, 1);
    if(lua_isnumber(l, 2))
    {
        float r = lua_tonumber(l, 2);
        ent.rotation = r;
    }
    lua_push(l, ent.rotation);
    return 1;
}

int libentity_vrotation(lua_State *l)
{
    Entity ent = cast(Entity) lua.lib.libentity_tmpl.lua_to!Entity(l, 1);
    if(lua_isnumber(l, 2))
    {
        float r = lua_tonumber(l, 2);
        ent.vrotation = r;
    }
    lua_push(l, ent.vrotation);
    return 1;
}

int libentity_info(lua_State *l)
{
    Entity ent = cast(Entity) lua.lib.libentity_tmpl.lua_to!Entity(l, 1);
    lua_pushlightuserdata(l, cast(void*) ent.info);
    lua_gettable(l, LUA_REGISTRYINDEX);
    return 1;
}

int libentity_destroy(lua_State *l)
{
    Entity ent = cast(Entity) lua.lib.libentity_tmpl.lua_to!Entity(l, 1);
    ent.destroy();
    return 0;
}
