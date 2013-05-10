/**
 * vector.d
 * tower
 * April 28, 2013
 * Brandon Surmanski
 */

module math.vector;

import std.stdio;
import std.math;

struct TVector4(T)
{
    private:
    T v[4];

    enum {
        X = 0,
        Y = 1,
        Z = 2,
        W = 3,
    };
    public:

    @property ref T x() { return v[0]; }
    @property ref T y() { return v[1]; }
    @property ref T z() { return v[2]; }
    @property ref T w() { return v[3]; }

    this(T)(T x, T y, T z, T w)
    {
        v[0] = x;
        v[1] = y;
        v[2] = z;
        v[3] = w;
    }

    this(T)(auto ref const T[] arr)
    in {
        assert(arr.length == 4);
    } body{
        this.v = arr.dup;    
    }

    this(T)(auto ref const T[4] arr)
    {
        v = arr.dup;
    }

    TVector4!T opBinary(string op)(auto ref const T rhs) const
    {
        TVector4!T ret;

        for(auto i = 0; i < 4; i++)
        {
            mixin("ret.v[i] = v[i]"~op~"rhs;");
        }
        return ret;
    }

    TVector4!T opBinary(string op)(auto ref const TVector4!T rhs) const
    {
        TVector4!T ret;

        for(auto i = 0; i < 4; i++)
        {
            mixin("ret.v[i] = v[i]"~op~"rhs.v[i];");
        }

        return ret;
    }

    void opAssign(ref const T[] arr)
    in {
        assert(arr.length == 4); 
    } body {
        this.v = arr.dup; 
    }

    void opAssign(ref const T[4] arr)
    {
        this.v = arr.dup;
    }

    void opAssign(typeof(this) rhs)
    {
        this.v = rhs.v.dup;
    }

    T opIndex(int index) const
    {
        return v[index];
    }

    ref T opIndex(int index)
    {
        return v[index];
    }

    T dot(typeof(this) rhs) const
    {
        T ret = 0;
        for(auto i = 0; i < 4; i++)
        {
            ret += v[0] * rhs.v[0];
        }
        return ret;
    }

    /**
     * floating point only operations
     */
    static if(is(T == float) || is(T == double))
    {
        T length() const
        {
            return hypot(hypot(hypot(v[0], v[1]), v[2]), v[3]);
        }

        void normalize()
        {
            this.v = normalized().v;
        }

        TVector4!T normalized() const
        {
            TVector4!T ret;
            T lensq = this.dot(this);
            T invlen = 1.0f / sqrt(lensq);

            for(auto i = 0; i < 4; i++)
            {
                ret.v[i] = v[i] * invlen;
            }
            return ret;
        }

        void project(ref const TVector4!T axis)
        {
            this.v = projected(axis).v;
        }

        TVector4!T projected(ref const TVector4!T axis) const
        {
            TVector4!T ret;
            T numer = this.dot(axis);
            T denom = axis.dot(axis);

            if(abs(denom) > T.epsilon)
            {
                ret = this * (numer / denom); 
            }
            return ret;
        }

        void orth(ref const TVector4!T axis)
        {
            this.v = this.orthed(axis).v;
        }

        TVector4!T orthed(ref const TVector4!T axis) const
        {
            typeof(this) ret = (this - this.projected(axis));
            return ret;
        }
    }

    void print() const
    {
        writeln(v);
    }
}

alias TVector4!float      Vector4;
alias TVector4!uint     UIVector4;
alias TVector4!int       IVector4;
alias TVector4!ushort   UHVector4;
alias TVector4!short     HVector4;

unittest{
    float[4] arr = [1,2,3,4];

    Vector4 v = arr;
}
