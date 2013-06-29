/**
 * quat.d
 * tower
 * June 22, 2013
 * Brandon Surmanski
 */

module math.quat;

import math.matrix;

struct QuatT(T)
{
    static immutable N = 4; //dimensionality
    T v[N] = [0, 0, 0, 1];

    @property ref T[N] data() { return v; }
    @property ref const(T[N]) data() const { return v; }
    @property ref T x() { return v[0]; }
    @property ref T y() { return v[1]; }
    @property ref T z() { return v[2]; }
    @property ref T w() { return v[3]; }

    //static QuatT!T identity() {QuatT!T quat(); return quat;}

    QuatT!T opBinary(string op)(auto ref const T rhs) const
    {
        QuatT!T ret;
        for(auto i = 0; i < N; i++)
        {
            mixin("ret.v[i] = v[i]"~op~"rhs;");
        }
        return ret;
    }

    QuatT!T opBinary(string op)(auto ref const QuatT!T rhs) const
    if(op == "*")
    {
        QuatT!T ret;
        ret.w = w * rhs.w - x * rhs.x - y * rhs.y - z * rhs.z;
        ret.x = w * rhs.x + x * rhs.w + y * rhs.z - z * rhs.y;
        ret.y = w * rhs.y + y * rhs.w + z * rhs.x - x * rhs.z;
        ret.z = w * rhs.z + z * rhs.w + x * rhs.y - y * rhs.x;
        return ret;
    }

    T dot(QuatT!T rhs)
    {
        return x * rhs.x + y * rhs.y + z * rhs.z + w * rhs.w;
    }

    T lensq()
    {
        return dot(this);
    }

    void normalize()
    {
        T lsqinv = 1 / lensq(); 
        x *= lsqinv;
        y *= lsqinv;
        z *= lsqinv;
        w *= lsqinv;
    }

    QuatT!T normalized()
    {
        QuatT!T quat = this;
        quat.normalize();
        return quat;
    }

    void congugate()
    {
        w = -w;
    }

    QuatT!T congugated()
    {
        QuatT!T quat = this;
        quat.w = -w;
        return quat;
    }

    Matrix4 matrix()
    {
        float ww = w * w;  
        float wx2 = 2.0f * w * x;
        float wy2 = 2.0f * w * y;
        float wz2 = 2.0f * w * z;
        float xx = x * x;
        float xy2 = 2.0f * x * y;
        float xz2 = 2.0f * x * z;
        float yy = y * y;
        float yz2 = 2.0f * y * z;
        float zz = z * z;
        
        Matrix4 ret = Matrix4([ww + xx - yy - zz, xy2 - wz2, xz2 + wy2, 0.0f,
                               xy2 + wz2, ww - xx + yy - zz, yz2 - wx2, 0.0f, 
                               xz2 - wy2, yz2 + wx2, ww - xx - yy + zz, 0.0f,
                               0.0f, 0.0f, 0.0f, 1.0f]);
        return ret;
    }
}

alias QuatT!float Quat;
alias QuatT!double DQuat;
