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
import entity.item;
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

    Sprite _inventory[4];

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

    @property override ActorInfo info()
    {
        return cast(ActorInfo) _info;
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

        for(int i = 0; i < 4; i++)
        {
            if(_inventory[i])
            {
                _inventory[i].draw(cam);
            }
        }

        super.draw(cam);
    }

    override void collide(Entity other, float dt)
    {
        super.collide(other, dt);
        if(Item item = cast(Item) other)
        {
            if(item.info.holdable)
            {
                drop(0);
                _inventory[0] = item;
                registry.remove(item);
                //item.destroy();     
            }
        }
    }

    void drop(int item)
    {
        if(_inventory[item])
        {
            registry.append(cast(Entity) _inventory[item]);
            _inventory[item] = null;
        }
    }


    override void update(float dt)
    {
        Vec3 tmp = position;
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

            side = 0;
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
                side = 1;
            }

            if(glfwGetKey('Z'))
            {
                if(_inventory[_selectedItem])
                {
                    _inventory[_selectedItem].velocity = Vec3(1, 0, 0);
                    drop(_selectedItem);
                    //TODO: attack, use, etc   
                }
            }
        }

        
        if(_inventory[0])
        {
            _inventory[0].position = position + Vec3(0.3f, 0.5f, -side * 0.1f + 0.05f);
            _inventory[0].side = side;
        }

        super.update(dt);
    }
}
