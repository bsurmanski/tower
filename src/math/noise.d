/**
 * noise.d
 * tower
 * May 16, 2013
 * Brandon Surmanski
 */

module math.noise;

import std.conv;
import std.math;

import math.vector;

private int seed = 55;

float lerp(float t, float a, float b)
in {
    assert(t >= 0.0f, "can only lerp between 0 to 1");
    assert(t <= 1.0f, "can only lerp between 0 to 1");
} body
{
    return (a+t*(b-a));
}

/**
 * applies a smoothing S-Curve function to  a value between 0-1
 */
float scurve(float t)
in {
    assert(t >= 0.0f, "can only s-curve a value between 0 and 1");
    assert(t <= 1.0f, "can only s-curve a value between 0 and 1"); 
} body
{
    return (t*t*t*(10.0f+t*(-15.0f+(6.0f*t))));
}

float random(int x)
{
    x += seed;
    x = (x<<13) ^ x;
    return (1.0 - ((x*(x*x*15731 + 789221) + 1376312589) & 0x7fffffff) / 1073741824.0);
}

float value(float x)
{
    int flx = to!int(floor(x));
    float dx0 = random(flx);
    float dx1 = random(flx + 1);
    return lerp(x-flx, dx0, dx1);
}

float perlin(float x)
{
    int flx = to!int(floor(x));
    float dx0 = random(flx);
    float dx1 = random(flx + 1);
    float u = (x - flx) * dx0;
    float v = (x - flx - 1) * dx1;
    return lerp(scurve(x-flx), u, v);
}

float fractal(float x, int n)
{
    float sum = 0;
    for(uint i = 1 << n; i > 0; i >> 1)
    {
        sum += perlin(x * i) / i; 
    }

    return sum;
}

float terbulent(float x, int n)
{
    float sum = 0;
    for(uint i = 1 << n; i > 0; i >> 1)
    {
        sum += fabs(perlin(x * i) / i);
    }

    return sum * 2.0f - 1.0f;
}

float random(IVec2 v)
{
    v += seed;
    v.x += v.y * 71;
    v.x = (v.x >> 13) ^ v.x;
    return (1.0 - ((v.x*(v.x*v.x*15731 + 789221) + 1376312589) & 0x7fffffff) / 1073741824.0);
}

Vec2 gradient(IVec2 v)
{
    v += seed;
    v.x = v.x * 17 + v.y * 89;
    v.y = v.x * 31 + v.y * 71;
    v = ((v >> 17) ^ v) & 0x7fffffff;

    Vec2 grad; // TODO: retrieve from gradient list
    return grad;
}

float value(Vec2 v)
{
    IVec2 flv = v.floor();
    float v0 = random(IVec2(flv.x, flv.y));
    float v1 = random(IVec2(flv.x+1, flv.y));
    float v2 = random(IVec2(flv.x+1, flv.y+1));
    float v3 = random(IVec2(flv.x, flv.y+1));

    float px0 = lerp(scurve(v.x-flv.x),v0,v1);
    float px1 = lerp(scurve(v.y-flv.y),v3,v2);

    return lerp(scurve(v.y-flv.y),px0,px1);
}
