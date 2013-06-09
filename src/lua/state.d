/**
 * api.d
 * tower
 * April 29, 2013
 * Brandon Surmanski
 */

module lua.state;

import std.algorithm;
import std.file;
import std.stdio;
import std.conv;
import std.string;
import std.c.string;
import std.c.stdlib;
import c.lua;
import c.lauxlib;
import c.lualib;

import lua.api;

import lua.luaModule;

class State
{
    lua_State *state;
    int memsz;

    extern(C) static void *luaStateAlloc(void *ud, void *ptr, size_t osize, size_t nsize)
    {
        State s = cast(State) ud;
        s.memsz += (nsize - osize);
        if(nsize == 0)
        {
            free(ptr);
            return null;
        }
        return realloc(ptr, nsize);
    }

    extern(C) static int luaStatePanic(lua_State *l)
    {
        lua_Debug ar = void;
        lua_getstack(l, 0, &ar);
        lua_getinfo(l, ">nSl".toStringz(), &ar);
        string panicStr = to!string(lua_tostring(l, lua_gettop(l)));
        string srcStr = to!string(ar.source);
        string nameStr = to!string(ar.name);
        writeln("Lua Panic: ", panicStr , " :", nameStr, ": ", ar.currentline, ", ", srcStr);
        return 0;
    }

    this()
    {
        memsz = 0;
        state = lua_newstate(&luaStateAlloc, cast(void*) this);
        lua_atpanic(state, &luaStatePanic);
        luaL_openlibs(state);
        addToPath("./?.lua;res/?.lua;res/lua/?.lua");
    }

    ~this()
    {
        lua_close(state);
    }

    private void register(ref Api api, int tableindex)
    {
        foreach(func; api.functions)
        {
            lua_pushstring(state, func.name.toStringz());
            lua_pushcfunction(state, func.func);
            lua_settable(state, tableindex);
        }

        foreach(constant; api.constants)
        {
            lua_pushstring(state, constant.name.toStringz());
            switch(constant.type)
            {
                case LUA_TNUMBER:
                    lua_pushnumber(state, constant.value);
                    break;

                case LUA_TBOOLEAN:
                    lua_pushboolean(state, cast(bool) constant.value);
                    break;

                case LUA_TSTRING:
                    lua_pushstring(state, cast(const char*) constant.value);

                case LUA_TUSERDATA:
                case LUA_TLIGHTUSERDATA:
                    lua_pushlightuserdata(state, cast(void*) constant.value);
                default:
                    lua_pop(state, 1);
            }
            lua_settable(state, tableindex);
        }

        if(api.parent)
        {
            register(*api.parent, tableindex);
        }
    }

    void register(ref Api api)
    {
        lua_newtable(state);
        int tableindex = lua_gettop(state);
        lua_pushstring(state, "__index");
        lua_pushvalue(state, -2);
        lua_settable(state, tableindex);

        register(api, tableindex);

        lua_pushstring(state, "__name");
        lua_pushstring(state, api.name.toStringz());
        lua_settable(state, tableindex);

        lua_setglobal(state, api.name.toStringz());
    }

    void register(Api[] apis)
    {
        foreach(api; apis)
        {
            this.register(api);
        }
    }

    void addToPath(string path)
    {
        lua_getglobal(state, "package");
        lua_getfield(state, -1, "path");
        string curpath = to!string(lua_tostring(state, -1));
        string newpath = curpath ~ path ~ ";";
        lua_pop(state, 1); //remove path string from stack
        lua_pushstring(state, newpath.toStringz());
        lua_setfield(state, -2, "path");
        lua_pop(state, 1);
    }

    void load(string filenm)
    {
        luaL_loadfile(state, filenm.toStringz()); 
    }

    void run(string filenm)
    {
        if(filenm.isDir())
        {
            foreach(mod; dirEntries(filenm, SpanMode.shallow))
            {
                if(mod.isDir)
                {
                    foreach(lua; filter!`a.name.endsWith(".lua")`(dirEntries(mod.name, SpanMode.shallow)))
                    {
                        LuaModule lmod = new LuaModule(this, lua);
                    }
                }
            }
        } else if(filenm.isFile())
        {
            luaL_loadfile(state, filenm.toStringz());
            lua_call(state, 0, 0);
        }
    }

    void run(string filenm, int nres)
    {
        luaL_loadfile(state, filenm.toStringz());
        lua_call(state, 0, nres);
    }
}
