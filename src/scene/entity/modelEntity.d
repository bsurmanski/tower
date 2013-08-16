/**
 * modelEntity.d
 * tower
 * May 27, 2013
 * Brandon Surmanski
 */

module scene.entity.modelEntity;

import std.math;

import c.lua;
import c.gl.gl;
import gl.glb.glb;

import math.matrix;
import container.geom.mesh;
import scene.entity.luaEntity;
import scene.entity.entity;
import scene.camera;

class ModelInfo : LuaEntityInfo
{
    Mesh _meshes[];
    Texture _texture;

    this(lua_State *l, string model, string texture)
    {
        super(l);
        _meshes ~= Mesh(model);
        _texture = Texture(0, texture);
        _texture.setSampler(&_sampler);
    }

    this(lua_State *l, Mesh mesh, Texture texture)
    {
        super(l); 
        _meshes ~= mesh;
        _texture = texture;
        _texture.setSampler(&_sampler);
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

    //one off models
    this(lua_State *state, string model, string texture)
    {
        ModelInfo info = new ModelInfo(state, model, texture);
        this(info.id);
    }

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
        glEnable(GL_CULL_FACE);
        Matrix4 mat;
        mat.translate(position); 
        mat = cam.transformation * mat * cam.basis;
        program.uniform(Shader.VERTEX_SHADER, 1, (float[16]).sizeof, true, mat.ptr);
        program.texture(Shader.FRAGMENT_SHADER, 0, info._texture);

        foreach(mesh; (cast(ModelInfo) info)._meshes)
        {
            program.draw(mesh.getVertexBuffer(), mesh.getIndexBuffer()); 
        }
        glDisable(GL_CULL_FACE);
    }

    override void update(float dt)
    {
        super.update(dt);
    }
}