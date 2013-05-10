/**
 * item.d
 * tower
 * April 30, 2013
 * Brandon Surmanski
 */

module entity.item;

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

    this(string name, string description, string textureFilenm)
    {
        super(name, description, textureFilenm);
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
    
    }
}
