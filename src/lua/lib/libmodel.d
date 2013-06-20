module lua.lib.libmodel;

import std.stdio;
import c.lua;

import gl.glb.glb;
import lua.api;
import lua.luah;
import entity.modelEntity;
import entity.entity;
import lua.lib.libentity;
import lua.lib.libentity_tmpl;

immutable Api libmodel = {
    "Model",
    // functions
    [
        {"register", &libmodel_register},
        {"new", &libmodel_new},
    ],
    // constants
    [
    ],
    &libentity,
};

extern(C):

static int libmodel_register(lua_State *l)
{
    string model    =   table_getstring(l, 1, "Model", "");
    string texture  =   table_getstring(l, 1, "Texture", "res/campaigns/main/items/unknown.tga");

    ModelInfo info = new ModelInfo(l, model, texture); ///< automatically registers itself

    // add parameter table to registry 
    lua_pushlightuserdata(l, cast(void*) info);
    lua_pushvalue(l, 1);
    lua_settable(l, LUA_REGISTRYINDEX);

    lua_pushinteger(l, info.id);
    return 1;
}

static int libmodel_new(lua_State *l)
{
    int typeId = cast(int) lua_tointeger(l, 1);
    auto ent = new ModelEntity(typeId);
    lua_push(l, cast(Entity) ent);
    return 1;
}
