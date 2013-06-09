/**
 * actor.d
 * tower
 * April 29, 2013
 * Brandon Surmanski
 */

module entity.actor;

import std.algorithm;
import std.stdio;
import std.math;
import std.conv;

import c.lua;
import c.gl.glfw;
import gl.glb.glb;

import lua.lib.callback;
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
    this(lua_State *l, string spritesheet)
    {
        super(l, spritesheet, 1, 2);
    }
}

/**
 * an Actor is any character that has a 'personality'. Anything that moves,
 * talks, attacks etc.
 */
class Actor : Sprite 
{
    static Actor actorFocus = null;

    Entity _inventory[4];

    ubyte _selectedItem;
    ubyte _nitems;
    uint _healthmax;
    uint _health;
    uint _wealthmax;
    uint _wealth;

    @property uint wealth() { return _wealth; }
    @property void wealth(uint nwealth) { _wealth = min(_wealthmax, nwealth); }
    @property ref uint health() { return _health; }
    @property ref uint healthmax() { return _healthmax; }
    @property ref ubyte selectedItem() { return _selectedItem; }

    this(int id)
    {
        super(id);

        _selectedItem = 0;
        _nitems = 0;

        _healthmax = 100;
        _wealthmax = 100;
        _health = 60;
        _wealth = 0;

        for(int i = 0; i < 4; i++)
        {
            _inventory[i] = null;
        }
    }

    @property static void focus(Actor a)
    {
        actorFocus = a;
    }

    @property static Actor focus() 
    {
        return actorFocus;
    }

    static string typeName()
    {
        return "Actor";
    }

    override void draw(Camera cam)
    {
        if(this == focus) //TODO move to update. provide some way to get main camera from there
        {
            cam.position = position + Vec3(0.0f, 3.5f, 5.0f);
        }

        super.draw(cam);
    }


    override void update(float dt)
    {
        ActorInfo ainfo = cast(ActorInfo) info;
        if(this == focus) // we are the main character! control!!!!
        {
            if(glfwGetKey('1'))
            {
                _selectedItem = 0;
            }

            if(glfwGetKey('2'))
            {
                _selectedItem = 1;
            }

            if(glfwGetKey('3'))
            {
                _selectedItem = 2;
            }

            if(glfwGetKey('4'))
            {
                _selectedItem = 3;
            }

            frame = 0;
            if(glfwGetKey(GLFW_KEY_LEFT))
            {
                position.x -= 0.05f;
                scale.x = -1;
            }

            if(glfwGetKey(GLFW_KEY_DOWN))
            {
                position.z += 0.05f;
            }

            if(glfwGetKey(GLFW_KEY_RIGHT))
            {
                position.x += 0.05f;
                scale.x = 1;
            }

            if(glfwGetKey(GLFW_KEY_UP))
            {
                position.z -= 0.05f;
                frame = 1;
            }

            if(glfwGetKey('z'))
            {
                if(_inventory[_selectedItem])
                {
                    //TODO: attack, use, etc   
                }
            }
        }

        super.update(dt);
    }
}
