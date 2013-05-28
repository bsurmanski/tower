/**
 * spriteEntity.d
 * tower
 * April 29, 2013
 * Brandon Surmanski
 */

module entity.sprite;

import std.stdio;
import std.math;
import std.conv;

import c.lua;
import c.gl.glfw;
import gl.glb.glb;

import container.geom.mesh;
import entity.entity;
import entity.luaEntity;
import math.matrix;
import math.vector;
import camera;

/**
 * Represents shared data across an actor type. Kind of like a runtime class
 * templated usable by lua.
 */
abstract class SpriteInfo : LuaEntityInfo
{
    Texture *_texture[]; 
    int _frames;
    int _sides;
    int _width;
    int _height;

    Texture *getTexture(int frame, int side)
    {
        return _texture[frame + _frames * side];
    }

    this(lua_State *l, string textureFilenm)
    {
        super(l);

        _texture.length = 1;
        _texture[0] = new Texture(0, textureFilenm);
        _texture[0].setSampler(&sampler);

        _frames = 1;
        _sides = 1;
        _width = _texture[0].width;
        _height = _texture[0].height;
    }

    this(lua_State *l, string texture, int frames = 1, int sides = 1)
    {
        super(l);

        _frames = frames;
        _sides = sides;
        _texture.length = frames * sides;

        scope Texture master = Texture(0, texture);
        assert(master.width % frames == 0, 
               "Invalid sprite. Width must be divisible by number of frames.");
        assert(master.height % sides == 0,
               "Invalid sprite. Height must be divisible by number of sides.");

        _width = master.width / frames;
        _height = master.height / sides;
        for(uint side = 0; side < _sides; side++)
        {
            for(uint frame = 0; frame < _frames; frame++)
            {
                uint i = frame + _frames * (_sides - side - 1); // reading is from bottom?
                _texture[i] = new Texture(0, Texture.RGBA, _width, _height, 1, null);
                _texture[i].copy(master, 0, 0, [frame * _width, side * _height, 1],
                                 [0,0,0],[_width, _height, 1]);
                _texture[i].setSampler(&sampler);
            }
        }
    }
}

/**
 * an Actor is any character that has a 'personality'. Anything that moves,
 * talks, attacks etc.
 */
abstract class Sprite : LuaEntity
{
    static bool init = false;
    static Program program;

    int _frame = 0;

    @property int frame() { return _frame; }
    @property void frame(int f) { _frame = f % to!int((cast(SpriteInfo) info)._frames + 1); }
    
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
        const(int) *texturesz = (*sinfo._texture[_frame]).size();
        Matrix4 mat; 
        mat.translate(0, 1, 0); //center sprite at bottom
        mat.rotate(-PI / 4.0f, 1.0f, 0, 0); //face sprite towards screen
        mat.scale(sinfo._width / 32.0f, sinfo._height / 32.0f, sinfo._height / 32.0f, 1.0f);
        mat.scale(scale.x, scale.y, scale.z);
        mat.translate(this.position);

        Matrix4 dmat;
        dmat.translate(0, 1, 0); //center sprite at bottom
        //dmat.rotate(-PI / 4.0f, 1.0f, 0, 0); //face sprite towards screen
        dmat.scale(sinfo._width / 32.0f, sinfo._height / 32.0f, sinfo._height / 32.0f, 1.0f);
        dmat.scale(scale.x, scale.y, scale.z);
        dmat.translate(this.position);
        dmat = cam.getMatrix() * dmat;

        mat = cam.getMatrix() * mat;
        program.uniform(Shader.VERTEX_SHADER, 0, (float[16]).sizeof, true, mat.ptr);
        program.uniform(Shader.VERTEX_SHADER, 1, (float[16]).sizeof, true, dmat.ptr);
        program.texture(Shader.FRAGMENT_SHADER, 0, *sinfo.getTexture(0, _frame));
        program.draw(Mesh.getUnitQuad().getVertexBuffer());
    }
}
