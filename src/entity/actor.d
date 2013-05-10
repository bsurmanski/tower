/**
 * actor.d
 * tower
 * April 29, 2013
 * Brandon Surmanski
 */

module entity.actor;

import std.stdio;
import std.math;
import std.conv;

import c.gl.glfw;
import gl.glb.glb;

import entity.entity;
import entity.sprite;
import math.matrix;
import math.vector;
import camera;

/**
 * Represents shared data across an actor type. Kind of like a runtime class
 * templated usable by lua.
 */
class ActorInfo : SpriteInfo
{

    bool isMain = false;

    this(string name, string description, string textureFilenm, bool isMain)
    {
        this.isMain = isMain;
        super(name, description, textureFilenm);
    }
}

/**
 * an Actor is any character that has a 'personality'. Anything that moves,
 * talks, attacks etc.
 */
class Actor : Sprite 
{
    ubyte currentItem;
    ubyte nitems;

    this(int id)
    {
        currentItem = 0;
        nitems = 0;
        super(id);
    }

    override void draw(Camera cam)
    {
        cam.position = position + Vector4(0.0f, 3.5f, 5.0f, 0.0f);
        super.draw(cam);
    }


    override void update(float dt)
    {
        ActorInfo ainfo = cast(ActorInfo) info;
        if(ainfo.isMain) // we are the main character! control!!!!
        {
            if(glfwGetKey('W'))
            {
                position.z -= 0.05f;
            }

            if(glfwGetKey('A'))
            {
                position.x -= 0.05f;
            }

            if(glfwGetKey('S'))
            {
                position.z += 0.05f;
            }

            if(glfwGetKey('D'))
            {
                position.x += 0.05f;
            }
        }
    }
}
