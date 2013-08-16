/**
 * spriteEntity.d
 * tower
 * April 29, 2013
 * Brandon Surmanski
 */

module scene.entity.sprite;

import std.stdio;
import std.math;
import std.conv;

import c.lua;
import c.gl.glfw;
import gl.glb.glb;

import container.geom.mesh;
import scene.entity.entity;
import scene.entity.luaEntity;
import math.matrix;
import math.vector;
import scene.camera;

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
        _texture[0].setSampler(&_sampler);

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
                _texture[i].copy(master, 0, 0, [frame * _width, side * _height, 0],
                                 [0,0,0],[_width, _height, 1]);
                _texture[i].setSampler(&_sampler);
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
    int _side = 0;

    @property int frame() { return _frame; }
    @property void frame(int f) { _frame = f % cast(int)(info._frames); }

    //TODO: make sides index independently
    @property int side() { return _side; }
    @property void side(int s) { _side = s % cast(int)(info._sides); }
    
    this(int id)
    {
        if(!init)
        {
            init = true;
            program = Program("res/glsl/drawtexture.vs", "res/glsl/drawtexture.fs");
        }

        super(id);
    }

    @property override SpriteInfo info()
    {
        return cast(SpriteInfo) _info;
    }

    override void update(float dt)
    {
        if(phys)
        {
            if(position.y > 0)
            {
                acceleration.y = -3.0f;
            } else if(velocity.y < 0)
            {
                //bounce
                position.y = 0;
                vrotation *= 0.7f;
                velocity.x *= 0.7f;
                velocity.y *= -0.5f;
                velocity.z *= 0.7f;
                acceleration.y = 0.0f;
            }
        }
        super.update(dt);
    }

    override void draw(Camera cam)
    {
        if(info.shadowed)
        {
            this.drawShadow(cam, program);
        }

        const(int) *texturesz = (*info._texture[_frame]).size();
        Matrix4 mat; 

        mat.scale(info._width / 32.0f, info._height / 32.0f, info._height / 32.0f, 1.0f);
        mat.scale(scale.x, scale.y, scale.z);

        mat.rotate(rotation, 0, 0, 1); //rotate sprite about center
        mat.translate(0, info._height / 32.0f, 0); //center sprite at bottom
        mat.rotate(-PI / 4.0f, 1.0f, 0, 0); //face sprite towards screen

        // skew y axis along z axis.
        Vec4 pos = cam.basis * Vec4(position.x, position.y, position.z, 1.0f) ;
        mat.translate(cast(Vec3) pos);

        mat = cam.transformation * mat;
        program.uniform(Shader.VERTEX_SHADER, 0, (float[16]).sizeof, true, mat.ptr);
        program.texture(Shader.FRAGMENT_SHADER, 0, *info.getTexture(_frame, _side));
        program.draw(Mesh.getUnitQuad().getVertexBuffer());
    }
}
