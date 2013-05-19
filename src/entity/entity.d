/**
 * entity.d
 * tower
 * April 29, 2013
 * Brandon Surmanski
 */

module entity.entity;

import std.math;
import std.algorithm;

import c.gl.gl;
import gl.glb.glb;

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

    int id = -1;
    string name = "";
    string description = "";

    this(string name, string description)
    {
        this.name = name;
        this.description = description;
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

    static EntityInfo get(int id)
    {
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
    Ball3 bounds;

    EntityInfo info;
    void *data; ///<type specific data

    this(int type, void *data = null)
    {
        this.type = type;
        this.data = data;
        position = Vec3(0,0,0);
        velocity = Vec3(0,0,0);
        scale = Vec3(1,1,1);
        rotation = 0.0f;
        info = EntityInfo.get(type); 

        bounds.radius = 0.2;

        registry ~= this;
    }

    void draw(Camera cam);
    void update(float dt);
    
    static void updateAll(float dt)
    {
        foreach(e; registry)
        {
            e.update(dt);

            ///XXX basic collision; TODO proper response
            import entity.actor;
            import std.stdio;
            e.bounds.center = e.position;
            if(e == Actor.focus)
            foreach(e2; registry)
            {
                if(e != e2 && e.bounds.collides(e2.bounds))
                {
                    Actor a = (cast(Actor)e);
                    a.wealth = a.wealth + 1;
                    writeln(a.wealth);
                    e2.position = Vec3(0,0,0); 
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
}
