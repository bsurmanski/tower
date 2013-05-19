/**
 * ball.d
 * tower
 * May 13, 2013
 * Brandon Surmanski
 */

module math.bv.ball;

import std.math;
import std.conv;
import std.traits;

import math.vector;

private float square(float num) { return num * num; }

mixin template BallN(uint N)
{
    mixin("alias VECN = Vec"~to!string(N)~";");
    alias BALLN = Unqual!(typeof(this));

    float _radius;
    VECN _center;

    @property ref VECN center() { return _center; }
    @property ref float radius() { return _radius; }

    void scale(float f)
    {
        _radius *= f;
    }

    void translate(VECN v)
    {
        _center += v;
    }

    void expand(float f)
    {
        _radius += f;
    }

    /**
     * true if two balls intersect
     */
    bool collides(BALLN rhs)
    {
        return _center.distanceSquared(rhs._center) < square(_radius + rhs._radius); 
    }

    /**
     * true if this entirely contains rhs
     */
    bool contains(BALLN rhs)
    {
        return _radius > rhs._radius && 
               _center.distanceSquared(rhs._center) < square(_radius - rhs._radius); 
    }

    /**
     * true if ball contains point
     */
    bool contains(const ref VECN point)
    {
        return _center.distanceSquared(point) < square(_radius);
    }

    /**
     * true if ball contains *all* points
     */
    bool contains(const ref VECN points[])
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

    /**
     * expands the bv to contain the point. returns true if the bv needed to expand
     */
    bool enclose(const ref VECN point)
    {
        float dist = _center.distanceSquared(point);
        if(dist > square(_radius))
        {
            _radius = sqrt(dist);
            return true;
        }
        return false;
    }

    /**
     * expands the bv to contain all points. returns true if the bv needed to expand
     */
    bool enclose(const ref VECN points[])
    {
        bool ret = false;
        foreach(point; points)
        {
            ret |= enclose(point);
        }
        return ret;
    }
}

struct Ball2
{
    mixin BallN!(2);

    this(ref Vec2 center, float radius)
    {
        _center = center;
        _radius = radius;
    }
}

struct Ball3
{
    mixin BallN!(3);

    this(ref Vec3 center, float radius)
    {
        _center = center;
        _radius = radius;
    }
}

