/**
 * item.d
 * tower
 * April 30, 2013
 * Brandon Surmanski
 */

module item;

import gl.glb.glb;

import std.math;

import matrix;
import camera;
import entity;
import sprite;

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
