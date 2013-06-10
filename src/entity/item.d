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
    bool holdable;
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

    @property override ItemInfo info()
    {
        return cast(ItemInfo) _info;
    }

    static string typeName()
    {
        return "Item";
    }

    override void update(float dt)
    {
        super.update(dt); 
    }
}
