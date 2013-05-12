/**
 * vector.d
 * tower
 * April 28, 2013
 * Brandon Surmanski
 */

module math.vector;

import std.stdio;
import std.traits;
import std.math;

mixin template TVec(uint N, T)
{
    private:
    T v[N];

    public:

    @property ref T[N] data() { return v; }
    @property uint size() { return N; }
    @property ref T x() { return v[0]; }
    @property ref T y() { return v[1]; }

    alias Unqual!(typeof(this)) UTYPE;

    static if(N >= 3)
    {
        @property ref T z() { return v[2]; }
    }

    static if(N >= 4)
    {
        @property ref T w() { return v[3]; }
    }

    /* XXX: mixin constructors do not work...
    this(T)(auto ref const T[] arr)
    in {
        assert(arr.length >= size);
    } body{
        this.v = arr[0..size].dup;    
    }

    this(T)(auto ref const T[size] arr)
    {
        v = arr.dup;
    }
    */

    UTYPE opBinary(string op)(auto ref const T rhs) const
    {
        UTYPE ret;

        for(auto i = 0; i < N; i++)
        {
            mixin("ret.v[i] = v[i]"~op~"rhs;");
        }
        return ret;
    }

    UTYPE opBinary(string op)(auto ref const UTYPE rhs) const
    {
        UTYPE ret;

        for(auto i = 0; i < N; i++)
        {
            mixin("ret.v[i] = v[i]"~op~"rhs.v[i];");
        }

        return ret;
    }

    void opAssign(ref const T[] arr)
    in {
        assert(arr.length == N); 
    } body {
        this.v = arr.dup; 
    }

    void opAssign(ref const T[N] arr)
    {
        this.v = arr.dup;
    }

    void opAssign(UTYPE rhs)
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

    T dot(UTYPE rhs) const
    {
        T ret = 0;
        for(auto i = 0; i < N; i++)
        {
            ret += v[i] * rhs.v[i];
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
            return sqrt(this.dot(this));
        }

        void normalize()
        {
            this.v = normalized().v;
        }

        UTYPE normalized() const
        {
            UTYPE ret;
            T lensq = this.dot(this);
            T invlen = 1.0f / sqrt(lensq);

            for(uint i = 0; i < N; i++)
            {
                ret.v[i] = v[i] * invlen;
            }
            return ret;
        }

        void project(ref const UTYPE axis)
        {
            this.v = projected(axis).v;
        }

        UTYPE projected(ref const UTYPE axis) const
        {
            UTYPE ret;
            T numer = this.dot(axis);
            T denom = axis.dot(axis);

            if(abs(denom) > T.epsilon)
            {
                ret = this * (numer / denom); 
            }
            return ret;
        }

        void orth(ref const UTYPE axis)
        {
            this.v = this.orthed(axis).v;
        }

        UTYPE orthed(ref const UTYPE axis) const
        {
            UTYPE ret = (this - this.projected(axis));
            return ret;
        }
    }

    void print() const
    {
        writeln(v);
    }
}

struct TVec2(T)
{
    mixin TVec!(2, T);

    this(T)(T x, T y)
    {
        v = [x, y];
    }

    this(T)(auto ref const T[] arr)
    in {
        assert(arr.length >= size);
    } body{
        this.v = arr[0..size].dup;    
    }

    this(T)(auto ref const T[size] arr)
    {
        v = arr.dup;
    }

    this(T)(TVec3!T vec)
    {
        v[0..size] = vec.v[0..size];
    }

    this(T)(TVec4!T vec)
    {
        v[0..size] = vec.v[0..size];
    }
}

struct TVec3(T)
{
    mixin TVec!(3, T);

    this(T)(T x, T y, T z)
    {
        v[0] = x;
        v[1] = y;
        v[2] = z;
    }

    this(T)(auto ref const T[] arr)
    in {
        assert(arr.length >= size);
    } body{
        this.v = arr[0..size].dup;    
    }

    this(T)(auto ref const T[size] arr)
    {
        v = arr.dup;
    }

    this(T)(TVec2!T vec)
    {
        v[0..size] = [vec.v[0..2], cast(T) 0];
    }

    this(T)(TVec4!T vec)
    {
        v[0..size] = vec.v[0..size];
    }
}

struct TVec4(T)
{
    mixin TVec!(4, T);

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

    this(T)(TVec2!T vec)
    {
        v[0..size] = [vec.v[0..2], cast(T) 0, cast(T) 0];
    }

    this(T)(TVec3!T vec)
    {
        v[0..size] = [vec.v[0..3], cast(T) 0];
    }
}

alias TVec2!float      Vec2;
alias TVec2!uint     UIVec2;
alias TVec2!int       IVec2;
alias TVec2!ushort   UHVec2;
alias TVec2!short     HVec2;

alias TVec3!float      Vec3;
alias TVec3!uint     UIVec3;
alias TVec3!int       IVec3;
alias TVec3!ushort   UHVec3;
alias TVec3!short     HVec3;

alias TVec4!float      Vec4;
alias TVec4!uint     UIVec4;
alias TVec4!int       IVec4;
alias TVec4!ushort   UHVec4;
alias TVec4!short     HVec4;

unittest{
    float[4] arr = [1,2,3,4];

    Vec4 v = arr;

    Vec3 v3 = Vec3(v);
}
