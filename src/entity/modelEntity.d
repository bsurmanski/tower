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
        _texture = Texture(0, texture);
        _sampler = Sampler();
        _sampler.setFilter(Sampler.NEAREST, Sampler.NEAREST);
        _texture.setSampler(&_sampler);
        super(l);
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

    @property override ModelInfo info()
    {
        return cast(ModelInfo) _info;
    }

    override void draw(Camera cam)
    {
        // now all the models are all slanty!
        Matrix4 mat;
        mat.translate(position); 
        mat = cam.transformation * mat * cam.basis;
        program.uniform(Shader.VERTEX_SHADER, 1, (float[16]).sizeof, true, mat.ptr);
        program.texture(Shader.FRAGMENT_SHADER, 0, info._texture);

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
