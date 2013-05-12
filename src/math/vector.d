/**
 * vector.d
 * tower
 * April 28, 2013
 * Brandon Surmanski
 */

module math.vector;

import std.stdio;
import std.math;

struct TVec2(T)
{
    T v[2];

    @property ref T x() { return v[0]; }
    @property ref T y() { return v[1]; }
    @property ref T[2] data() { return v; }

    @property TVec3!T Vec3() { return TVec3!T(v[0], v[1], cast(T) 0); }
    @property TVec4!T Vec4() { return TVec3!T(v[0], v[1], cast(T) 0, cast(T) 0); }

    this(T)(auto ref const T[] arr)
    in
    {
        assert(arr.length >= 2);
    }
    body
    {
        v = arr[0..2].dup;
    }
}

struct TVec3(T)
{
    T v[3];

    @property ref T x() { return v[0]; }
    @property ref T y() { return v[1]; }
    @property ref T z() { return v[2]; }
    @property ref T[3] data() { return v; }

    @property TVec4!T Vec4() { return TVec4!T(v[0], v[1], v[2], cast(T) 0); }

    this(T)(auto ref const T[] arr)
    in
    {
        assert(arr.length >= 3);
    }
    body
    {
        v = arr[0..3].dup;
    }
}

struct TVec4(T)
{
    private:
    T v[4];

    public:

    @property ref T x() { return v[0]; }
    @property ref T y() { return v[1]; }
    @property ref T z() { return v[2]; }
    @property ref T w() { return v[3]; }
    @property ref T[4] data() { return v; }
    @property TVec3!T Vec3() { return TVec3!T(v[0..3]); }

    this(T)(T x, T y, T z, T w)
    {
        v[0] = x;
        v[1] = y;
        v[2] = z;
        v[3] = w;
    }

    this(T)(auto ref const T[] arr)
    in {
        assert(arr.length >= 4);
    } body{
        this.v = arr[0..4].dup;    
    }

    this(T)(auto ref const T[4] arr)
    {
        v = arr.dup;
    }

    TVec4!T opBinary(string op)(auto ref const T rhs) const
    {
        TVec4!T ret;

        for(auto i = 0; i < 4; i++)
        {
            mixin("ret.v[i] = v[i]"~op~"rhs;");
        }
        return ret;
    }

    TVec4!T opBinary(string op)(auto ref const TVec4!T rhs) const
    {
        TVec4!T ret;

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

        typeof(this) normalized() const
        {
            TVec4!T ret;
            T lensq = this.dot(this);
            T invlen = 1.0f / sqrt(lensq);

            for(auto i = 0; i < 4; i++)
            {
                ret.v[i] = v[i] * invlen;
            }
            return ret;
        }

        void project(ref const typeof(this) axis)
        {
            this.v = projected(axis).v;
        }

        typeof(this) projected(ref const typeof(this) axis) const
        {
            TVec4!T ret;
            T numer = this.dot(axis);
            T denom = axis.dot(axis);

            if(abs(denom) > T.epsilon)
            {
                ret = this * (numer / denom); 
            }
            return ret;
        }

        void orth(ref const typeof(this) axis)
        {
            this.v = this.orthed(axis).v;
        }

        TVec4!T orthed(ref const typeof(this) axis) const
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

alias TVec4!float      Vec4;
alias TVec4!uint     UIVec4;
alias TVec4!int       IVec4;
alias TVec4!ushort   UHVec4;
alias TVec4!short     HVec4;

unittest{
    float[4] arr = [1,2,3,4];

    Vec4 v = arr;
}
