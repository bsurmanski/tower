/**
 * model.d
 * tower
 * May 26, 2013
 * Brandon Surmanski
 */

module container.geom.model;

import container.geom.mesh;
import gl.glb.glb; //TODO replace?
import math.matrix;
import camera;

import std.math;

class Model
{
    Mesh _meshes[];
    Texture _textures[];

    //XXX
    static Program program;
    static Sampler sampler = void;

    this(Mesh meshes[], Texture textures[])
    {
        _meshes = meshes.dup; 
        _textures = textures.dup;

        sampler = Sampler();
        sampler.setFilter(Sampler.NEAREST, Sampler.NEAREST);
        program = Program();
        program.source("res/glsl/drawmodel.vs", Shader.VERTEX_SHADER);
        program.source("res/glsl/drawmodel.fs", Shader.FRAGMENT_SHADER);
    }

    void opOpAssign(string op)(const Mesh mesh)
    if(op == "~")
    {
        _meshes ~= mesh;
    }

    void opOpAssign(string op)(const Texture texture)
    {
        _textures ~= texture;
    }

    void draw(Camera cam)
    {
        // okay, everything is all slanty!
        Matrix4 mat = cam.getMatrix() * Matrix4().skewedy(-PI / 4);
        program.uniform(Shader.VERTEX_SHADER, 1, (float[16]).sizeof, true, mat.ptr);
        //program.texture(Shader.FRAGMENT_SHADER, 0, 

        foreach(mesh; _meshes)
        {
            program.draw(mesh.getVertexBuffer(), mesh.getIndexBuffer());
        }
    }
}
