/**
 * entity.d
 * tower
 * April 29, 2013
 * Brandon Surmanski
 */

module entity.entity;

import std.math;
import std.algorithm;

import c.lua;
import c.gl.gl;
import gl.glb.glb;

import lua.lib.callback;
import math.bv.ball;
import math.matrix;
import math.vector;
import camera;
import mesh;

abstract class EntityInfo
{
    static EntityInfo[] registry;

    static bool init = false;
    static Texture shadow = void;
    static Sampler sampler = void;

    lua_State *luastate = null;
    int id = -1;

    this(lua_State *l)
    {
        this.luastate = l;
        this.id = cast(int) registry.length;

        if(!init)
        {
            init = true;
            sampler = Sampler();
            sampler.setFilter(Sampler.NEAREST, Sampler.NEAREST);
            shadow = Texture(0, "res/tex/shadow.tga");
            shadow.setSampler(&sampler);
        }

        registry ~= this;
    }

    ~this()
    {
        luastate = null;
    }

    static EntityInfo get(int id)
    {
        assert(id >= 0 && registry.length > id);
        return registry[id];
    }
}

abstract class Entity
{
    static Entity[] registry;

    int type;
    float rotation;
    Vec3 position;
    Vec3 scale;
    Vec3 velocity;
    import math.bv.ball; //XXX WTF? why doesnt it know?
    Ball3 bounds;

    EntityInfo info;

    this(int type)
    {
        this.type = type;
        position = Vec3(0,0,0);
        velocity = Vec3(0,0,0);
        scale = Vec3(1,1,1);
        rotation = 0.0f;
        info = EntityInfo.get(type); 

        bounds.radius = 0.2;

        registry ~= this;

        luaCallback("New");
    }

    ~this()
    {
        info = null;
    }

    void draw(Camera cam);
    void update(float dt);
    //void input(
    void collide(Entity other, float dt)
    {
        this.luaCallback("Collide", other, dt);
    }
    
    static void updateAll(float dt)
    {
        foreach(i, e; registry)
        {
            e.update(dt);

            ///XXX basic collision; TODO proper response
            e.bounds.center = e.position;
            for(auto j = 0; j < i; j++)
            {
                Entity e2 = registry[j];
                if(e.bounds.collides(e2.bounds))
                {
                    e.collide(e2, dt);
                    e2.collide(e, dt);
                    //Actor a = (cast(Actor)e);
                    //a.wealth = a.wealth + 1;
                    //writeln(a.wealth);
                    //e2.position = Vec3(0,0,0); 
                }
            }
        }
        sort!("a.position.z < b.position.z")(registry);
    }

    static void drawAll(Camera cam)
    {
        foreach(e; registry)
        {
            e.draw(cam);
        }
    }

    void drawShadow(Camera cam, ref Program program)
    {
        glDisable(GL_DEPTH_TEST);
        glDepthMask(false);

        Matrix4 mat; 
        mat.rotate(-PI / 2.0f, 1.0f, 0.0f, 0.0f);
        const(int) *texturesz = info.shadow.size();
        mat.scale(texturesz[0] / 32.0f, texturesz[1] / 32.0f, texturesz[1] / 32.0f);
        mat.translate(this.position);

        mat = cast(Matrix4) cam.getMatrix() * mat;
       
        program.uniform(Shader.VERTEX_SHADER, 0, (float[16]).sizeof, true, mat.ptr);
        program.texture(Shader.FRAGMENT_SHADER, 0, info.shadow);
        program.draw(Mesh.getUnitQuad().getVertexBuffer());

        glDepthMask(true);
        glEnable(GL_DEPTH_TEST);
    }

    void luaCallback(T...)(string name, T args)
    {
        lua_State *l = this.info.luastate; 
        lua_callback(l, this.info, name, this, args);
    }
}
