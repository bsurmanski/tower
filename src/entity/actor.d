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
    this(string name, string description, string textureFilenm)
    {
        super(name, description, textureFilenm);
    }
}

/**
 * an Actor is any character that has a 'personality'. Anything that moves,
 * talks, attacks etc.
 */
class Actor : Sprite 
{
    static Actor actorFocus = null;

    ubyte selectedItem;
    ubyte nitems;
    uint healthmax;
    uint health;
    uint wealth;

    this(int id)
    {
        selectedItem = 0;
        nitems = 0;

        healthmax = 100;
        health = 60;
        wealth = 0;
        super(id);
    }

    @property static void focus(Actor a)
    {
        actorFocus = a;
    }

    @property static Actor focus() 
    {
        return actorFocus;
    }

    override void draw(Camera cam)
    {
        cam.position = position + Vec4(0.0f, 3.5f, 5.0f, 0.0f);
        super.draw(cam);
    }


    override void update(float dt)
    {
        ActorInfo ainfo = cast(ActorInfo) info;
        if(this == focus) // we are the main character! control!!!!
        {
            if(glfwGetKey('1'))
            {
                selectedItem = 0;
            }

            if(glfwGetKey('2'))
            {
                selectedItem = 1;
            }

            if(glfwGetKey('3'))
            {
                selectedItem = 2;
            }

            if(glfwGetKey('4'))
            {
                selectedItem = 3;
            }

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
