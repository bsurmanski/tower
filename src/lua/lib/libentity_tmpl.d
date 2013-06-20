/**
 * libentity_tmpl.d
 * tower
 * June 01, 2013
 * Brandon Surmanski
 *
 * We need this module because for some reason, D can't access template functions if there is a
 * local template function with the same signature (but different static requirements)
 */

module lua.lib.libentity_tmpl;

import std.traits;

import c.lua;
import entity.luaEntity;
import entity.entity;
import entity.actor;
import entity.item;
import lua.luah;
import lua.luaValue;

void lua_push(T)(lua_State *l, T value)
if(is(Entity == T) || is(LuaEntity == T)) //TODO: change to all classes dirived from Entity
//if(is(T == class) && (Entity in BaseTypeTuple!(T)))
{
    import entity.actor;
    import entity.item;
    import entity.modelEntity;
    import std.stdio;
    //lua_pushlightuserdata(l, cast(void*) value);
    Entity *ent = cast(Entity*) lua_newuserdata(l, (Entity).sizeof);
    *ent = value;
    if(cast(Actor) value)
    {
        lua_getglobal(l, "Actor");
        lua_setmetatable(l, -2);
    } else if(cast(Item) value)
    {
        lua_getglobal(l, "Item");
        lua_setmetatable(l, -2);
    } else if (cast(ModelEntity) value)
    {
        lua_getglobal(l, "Model");
        lua_setmetatable(l, -2);
    }else
    {
        lua_getglobal(l, "Entity");
        lua_setmetatable(l, -2);
    }
}

T lua_to(T)(lua_State *l, int index)
if(is(Entity == T) || is(LuaEntity == T)) //TODO: change to all classes dirived from Entity
{
    return (*cast(Entity*) lua_touserdata(l, index));
}
