/**
 * spriteEntity.d
 * tower
 * April 29, 2013
 * Brandon Surmanski
 */

module sprite;

import std.stdio;
import std.math;
import std.conv;

import c.gl.glfw;
import gl.glb.glb;

import camera;
import matrix;
import vector;
import entity;

/**
 * Represents shared data across an actor type. Kind of like a runtime class
 * templated usable by lua.
 */
abstract class SpriteInfo : EntityInfo
{
    Texture texture = void; 

    this(string name, string description, string textureFilenm)
    {
        super(name, description);

        texture = Texture(0, textureFilenm);
        texture.setSampler(&sampler);
    }
}

/**
 * an Actor is any character that has a 'personality'. Anything that moves,
 * talks, attacks etc.
 */
abstract class Sprite : Entity
{
    static bool init = false;
    static Program program;
    
    this(int id)
    {
        if(!init)
        {
            init = true;
            program = Program();
            program.source("res/glsl/drawtexture.vs", Shader.VERTEX_SHADER);
            program.source("res/glsl/drawtexture.fs", Shader.FRAGMENT_SHADER);
        }

        super(id);
    }

    override void draw(Camera cam)
    {
        this.drawShadow(cam, program);
        SpriteInfo sinfo = cast(SpriteInfo) info;
        const(int) *texturesz = sinfo.texture.size();
        Matrix4 mat; 
        mat.translate(0, 1, 0); //center sprite at bottom
        mat.rotate(-PI / 4.0f, 1.0f, 0, 0); //face sprite towards screen
        mat.scale(texturesz[0] / 32.0f, texturesz[1] / 32.0f, texturesz[1] / 32.0f, 1.0f);
        mat.translate(this.position);


        mat = cam.getMatrix() * mat;
        program.uniform(Shader.VERTEX_SHADER, 0, (float[16]).sizeof, true, mat.ptr);
        program.texture(Shader.FRAGMENT_SHADER, 0, sinfo.texture);
        program.draw(mesh.getVertexBuffer());
    }
}
