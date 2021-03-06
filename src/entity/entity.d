/**
 * entity.d
 * tower
 * April 29, 2013
 * Brandon Surmanski
 */

module entity.entity;

import std.math;
import std.algorithm;
import std.container;
import std.range;

import c.gl.gl;
import gl.glb.glb;

import container.geom.mesh;
import container.list;
import math.bv.ball;
import math.matrix;
import math.vector;
import camera;

abstract class EntityInfo
{
    static EntityInfo[] registry;

    static bool _entityinit = false;
    bool _shadowed = true;
    static Texture _shadow = void;
    static Sampler _sampler = void;

    int _id = -1;

    @property int id() { return _id; }
    @property bool shadowed() { return _shadowed; }
    @property void shadowed(bool val) { _shadowed = val; }

    this()
    {
        this._id = cast(int) registry.length;

        if(!_entityinit)
        {
            _entityinit = true;
            _sampler = Sampler();
            _sampler.setFilter(Sampler.NEAREST, Sampler.NEAREST);
            _shadow = Texture(0, "res/tex/shadow.tga");
            _shadow.setSampler(&_sampler);
        }

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
    Vec3 position;
    Vec3 velocity;
    Vec3 acceleration;
    Vec3 scale;
    Ball3 bounds;

    EntityInfo _info;

    this(int type)
    {
        this.type = type;
        position = Vec3(0,0,0);
        velocity = Vec3(0,0,0);
        acceleration = Vec3(0,0,0);
        scale = Vec3(1,1,1);
        rotation = 0.0f;
        _info = EntityInfo.get(type);

        bounds.radius = 0.2;

        registry.insertBack(this);

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
    void update(float dt)
    {
        if(phys)
        {
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

        // XXX DEBUG
        assert(registry.sorted!("a.position.z < b.position.z")());
    }

    static void drawAll(Camera cam)
    {
        foreach(e; registry)
        {
            e.draw(cam);
        }
    }

    void destroy()
    {
        this.marked = true; 
    }

    void drawShadow(Camera cam, ref Program program)
    {
        glDisable(GL_DEPTH_TEST);
        glDepthMask(false);

        Matrix4 mat; 
        mat.rotate(-PI / 2.0f, 1.0f, 0.0f, 0.0f);
        const(int) *texturesz = info._shadow.size();
        mat.scale(texturesz[0] / 32.0f, texturesz[1] / 32.0f, texturesz[1] / 32.0f);

        Vec3 pos = this.position;
        pos.y = 0;
        mat.translate(pos);

        mat = cast(Matrix4) cam.transformation * mat;
       
        program.uniform(Shader.VERTEX_SHADER, 0, (float[16]).sizeof, true, mat.ptr);
        program.texture(Shader.FRAGMENT_SHADER, 0, info._shadow);
        program.draw(Mesh.getUnitQuad().getVertexBuffer());

        glDepthMask(true);
        glEnable(GL_DEPTH_TEST);
    }

}
