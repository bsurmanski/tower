/**
 * box.d
 * tower
 * May 11, 2013
 * Brandon Surmanski
 */

module math.bv.box;

import std.math;
import std.conv;
import std.traits;

import math.vector;

mixin template BoxN(uint N)
{
    mixin ("alias VECN = Vec"~to!string(N)~";");
    alias BOXN = Unqual!(typeof(this));

    VECN _extent; //all entries must be positive
    VECN _center;
 
    /* XXX constructors dont seem to work with mixin templates
    this(ref const VECN mins, ref const VECN maxs)
    {
        _center = (mins / 2.0f + maxs / 2.0f);
        _extent = _center - mins;
    }*/

    void scale(float f)
    {
        _extent *= f;
    }

    void translate(const ref VECN v)
    {
        _center += v;
    }
    
    void expand(float f)
    {
        _extent += f;
    }

    bool collides(const ref BOXN rhs) const
    {
        for(uint i = 0; i < N; i++)
        {
            if(fabs(_center[i] - rhs._center[i]) > fabs(_extent[i]) + fabs(rhs._extent[i]))
            {
                return false;
            }
        }
        return true;
    }

    bool contains(const ref BOXN rhs) const
    {
        for(uint i = 0; i < N; i++)
        {
            if(fabs(_extent[i]) < fabs(rhs._extent[i]) || 
               fabs(_center[i] - rhs._center[i]) > fabs(_extent[i] - rhs._extent[i]))
            {
                return false;
            }
        }
        return true;
    }

    bool contains(const ref VECN point)
    {
        for(uint i = 0; i < N; i++)
        {
            if(fabs(_center[i] - point[i]) > fabs(_extent[i]))
            {
                return false;
            }
        }
        return true;
    }

    bool contains(const ref VECN[] points)
    {
        foreach(point; points)
        {
            if(!contains(point))
            {
                return false;
            }
        }
        return true;
    }

    bool enclose(const ref VECN point)
    {
        bool ret = false;
        for(uint i = 0; i < N; i++)
        {
            float dpc = point[i] - _center[i]; //distance point-center
            float dext = fabs(dpc) - fabs(_extent[i]); //delta extent
            if(dext > 0)
            {
                _extent[i] = fabs(_extent[i]) + dext / 2.0f;
                _center[i] = _center[i] + copysign(dext / 2.0f, dpc);
                ret = true;
            }
        }
        return ret;
    }

    bool enclose(const ref VECN[] points)
    {
        bool ret = false;
        foreach(point; points)
        {
            ret |= enclose(point);
        }
        return ret;
    }
}

struct Box3
{
    mixin BoxN!(3);

    this(ref Vec3 center, ref Vec3 extent)
    {
        _center = center;
        _center = extent;
    }
}
