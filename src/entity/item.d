/**
 * item.d
 * tower
 * April 30, 2013
 * Brandon Surmanski
 */

module entity.item;

import c.lua;
import gl.glb.glb;

import std.math;

import entity.entity;
import entity.sprite;
import math.matrix;
import camera;

class ItemInfo : SpriteInfo
{
    bool autopickup;
    int type;
    Texture texture = void;

    this(lua_State *l, string textureFilenm, int frames = 1, int sides = 1)
    {
        super(l,textureFilenm, frames, sides);
    }

    ~this()
    {
        destroy(texture);
        texture = Texture.init;
    }
}

class Item : Sprite 
{
    this(int id)
    {
        super(id);
    }

    override void update(float dt)
    {
        super.update(dt); 
    }
}
