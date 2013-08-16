/**
 * entity.d
 * tower
 * April 29, 2013
 * Brandon Surmanski
 */

module scene.entity.entity;

import std.math;
import std.algorithm;
import std.container;
import std.range;

import c.gl.gl;
import gl.glb.glb;

import scene.scene;
import container.geom.mesh;
import container.list;
import math.bv.ball;
import math.matrix;
import math.vector;
import scene.camera;

abstract class EntityInfo
{
    static EntityInfo[] registry;

    int _id = -1;

    @property int id() { return _id; }

    this()
    {
        this._id = cast(int) registry.length;

        registry ~= this;
    }

    ~this()
    {
        _id = -1;
    }

    static EntityInfo get(int id)
    {
        assert(id >= 0 && id < registry.length);
        assert(registry[id]);
        return registry[id];
    }
}

abstract class Entity
{
    static List!Entity registry;

    bool marked = false;
    bool phys = true;
    int type;
    float rotation;
    float vrotation;
    Vec3 position;
    Vec3 velocity;
    Vec3 acceleration;
    Vec3 scale;
    Ball3 bounds;
    Entity _parent;
    Entity _children[];

    EntityInfo _info;

    this()
    {
        position = Vec3(0,0,0);
        velocity = Vec3(0,0,0);
        acceleration = Vec3(0,0,0);
        scale = Vec3(1,1,1);
        rotation = 0.0f;
        vrotation = 0.0f;
        _parent = null;
        _info = null;

        bounds.radius = 0.2;

        registry.insertBack(this);
    }

    this(int type)
    {
        this.type = type;
        _info = EntityInfo.get(type);
        this();
    }

    ~this()
    {
        _info = null;
    }

    @property EntityInfo info()
    {
        return _info;
    }

    void draw(Camera cam);
    void collide(Entity other, float dt);
    void update(Scene scene, float dt)
    {
        if(phys)
        {
            rotation += vrotation * dt;
            velocity += acceleration * dt; //TODO RK4 integration. move up
            position += velocity * dt;
        }
    }
    //void input(
    
    static void updateAll(float dt)
    {
        foreach(e; registry)
        {
            if(!e.marked)
            {
                e.update(dt);

                e.bounds.center = e.position;
                foreach(e2; registry)
                {
                    if(e == e2) break;
                    if(e.bounds.collides(e2.bounds) && !e2.marked)
                    {
                        e.collide(e2, dt); //TODO: allow for e to be removed without breaking
                        e2.collide(e, dt);
                    }
                }
            }
        }

        auto it = registry.begin();
        while(it) // search for marked entities, and remove
        {
            if(it.value.marked)
            {
                //destroy(it.value);
                auto rmv = it;
                it = it.next();
                Entity ent = registry.remove(rmv); 
            } else
            {
                it = it.next();
            }
        }

        registry.sort!("a.position.z < b.position.z")();
    }

    void destroy()
    {
        this.marked = true; 
    }
}
