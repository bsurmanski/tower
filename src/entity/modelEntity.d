/**
 * modelEntity.d
 * tower
 * May 27, 2013
 * Brandon Surmanski
 */

module entity.modelEntity;

import std.math;

import c.lua;
import gl.glb.glb;

import math.matrix;
import container.geom.model;
import container.geom.mesh;
import entity.luaEntity;
import entity.entity;
import camera;

class ModelInfo : LuaEntityInfo
{
    //Model _model;
    Mesh _meshes[];
    Texture _textures[] = [];
    Texture _texture;
    Sampler _sampler;

    this(lua_State *l, string model, string texture)
    {
        _meshes ~= Mesh(model);
        _texture = Texture(0, "res/tex/cement.tga");
        _sampler = Sampler();
        _sampler.setFilter(Sampler.NEAREST, Sampler.NEAREST);
        _texture.setSampler(&_sampler);
        super(l);

        Matrix4 trans;
        for(auto i = 0; i < 25; i++)
        {
            trans.translate(1,0,0);
            add(Mesh(model), trans);
        }

        trans = Matrix4();
        trans.translate(10,0,0);
        for(auto i = 0; i < 25; i++)
        {
            trans.translate(0,0,1);
            add(Mesh(model), trans);
        }
    }

    void add(Mesh mesh, Matrix4 transform = Matrix4())
    {
        mesh.transform(transform);
        _meshes ~= mesh;
    }
}

class ModelEntity : LuaEntity
{
    static Program program;
    static Sampler sampler = void;

    this(int id)
    {
        super(id); 

        sampler = Sampler();
        sampler.setFilter(Sampler.NEAREST, Sampler.NEAREST);
        program = Program();
        program.source("res/glsl/drawmodel.vs", Shader.VERTEX_SHADER);
        program.source("res/glsl/drawmodel.fs", Shader.FRAGMENT_SHADER);
    }

    override void draw(Camera cam)
    {
        ModelInfo minfo = cast(ModelInfo) info;
        // now all the models are all slanty!
        Matrix4 mat = cam.getMatrix() * Matrix4().skewedy(-PI / 4);
        program.uniform(Shader.VERTEX_SHADER, 1, (float[16]).sizeof, true, mat.ptr);
        program.texture(Shader.FRAGMENT_SHADER, 0, minfo._texture);

        foreach(mesh; (cast(ModelInfo) info)._meshes)
        {
            program.draw(mesh.getVertexBuffer(), mesh.getIndexBuffer()); 
        }
    }

    override void update(float dt)
    {
        super.update(dt);
    }
}
