/**
 * vector.d
 * tower
 * April 28, 2013
 * Brandon Surmanski
 */

module math.vector;

import std.conv;
import std.stdio;
import std.traits;
import std.math;

mixin template TVecN(uint N, T)
{
    private:
    T v[N];

    public:

    @property ref T[N] data() { return v; }
    @property ref const(T[N]) data() const { return v; }
    @property uint size() { return N; }
    @property ref T x() { return v[0]; }
    @property ref T y() { return v[1]; }

    alias TVECN = Unqual!(typeof(this));

    static if(is(T == int)) //avoid recursive alias
    {
        alias IVECN = TVECN;
    } else
    {
        mixin("alias IVECN = IVec"~to!string(N)~";");
    }
    
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

    TVECN opBinary(string op)(auto ref const T rhs) const
    {
        TVECN ret;

        for(auto i = 0; i < N; i++)
        {
            mixin("ret.v[i] = v[i]"~op~"rhs;");
        }
        return ret;
    }

    TVECN opBinary(string op)(auto ref const TVECN rhs) const
    {
        TVECN ret;

        for(auto i = 0; i < N; i++)
        {
            mixin("ret.v[i] = v[i]"~op~"rhs.v[i];");
        }

        return ret;
    }

    void opOpAssign(string op)(auto ref const T rhs)
    {
        for(auto i = 0; i < N; i++)
        {
            mixin("v[i] = v[i]"~op~"rhs;");
        }
    }

    void opOpAssign(string op)(auto ref const TVECN rhs)
    {
        for(auto i = 0; i < N; i++)
        {
            mixin("v[i] = v[i]"~op~"rhs.v[i];");
        }
    }

    /*
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

    void opAssign(ref const TVECN rhs)
    {
        this.v = rhs.v.dup;
    }

    void opAssign(const TVECN rhs)
    {
        this.v = rhs.v.dup;
    }*/

    void opAssign(U)(TVec!(N,U) v)
    {
        for(int i = 0; i < N; i++)
        {
            v[i] = cast(T) v[i];
        }
    }

    T opIndex(int index) const
    {
        return v[index];
    }

    ref T opIndex(int index)
    {
        return v[index];
    }

    T dot(TVECN rhs) const
    {
        T ret = 0;
        for(auto i = 0; i < N; i++)
        {
            ret += v[i] * rhs.v[i];
        }
        return ret;
    }

    TVECN map(T function(T) fn)
    {
        TVECN ret; 
        for(int i = 0; i < N; i++)
        {
            ret[i] = fn(v[i]);
        }
        return ret;
    }

    /**
     * floating point only operations
     */
    static if(is(T == float) || is(T == double))
    {
        IVECN floor() const
        {
            IVECN ret;

            for(int i = 0; i < N; i++)
            {
                ret[i] = to!int(std.math.floor(v[i]));
            }
            return ret;
        }

        IVECN ceil() const
        {
            IVECN ret;

            for(int i = 0; i < N; i++)
            {
                ret[i] = to!int(std.math.ceil(v[i]));
            }
            return ret;
        }

        IVECN round() const
        {
            IVECN ret;

            for(int i = 0; i < N; i++)
            {
                ret[i] = to!int(std.math.round(v[i]));
            }
            return ret;
        }

        T distance(const ref TVECN rhs) const
        {
            TVECN diff = this - rhs;
            return diff.length();
        }

        T distanceSquared(const ref TVECN rhs) const
        {
            TVECN diff = this - rhs;
            return diff.dot(diff);
        }

        T length() const
        {
            return sqrt(this.dot(this));
        }

        void normalize()
        {
            this.v = normalized().v;
        }

        TVECN normalized() const
        {
            TVECN ret;
            T lensq = this.dot(this);
            T invlen = 1.0f / sqrt(lensq);

            for(uint i = 0; i < N; i++)
            {
                ret.v[i] = v[i] * invlen;
            }
            return ret;
        }

        void project(ref const TVECN axis)
        {
            this.v = projected(axis).v;
        }

        TVECN projected(ref const TVECN axis) const
        {
            TVECN ret;
            T numer = this.dot(axis);
            T denom = axis.dot(axis);

            if(abs(denom) > T.epsilon)
            {
                ret = this * (numer / denom); 
            }
            return ret;
        }

        void orth(ref const TVECN axis)
        {
            this.v = this.orthed(axis).v;
        }

        TVECN orthed(ref const TVECN axis) const
        {
            TVECN ret = (this - this.projected(axis));
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
    mixin TVecN!(2, T);

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
    mixin TVecN!(3, T);

    this(UX, UY, UZ)(UX x, UY y, UZ z)
    if(isImplicitlyConvertible!(UX, T) &&
       isImplicitlyConvertible!(UY, T) &&
       isImplicitlyConvertible!(UZ, T))
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
    mixin TVecN!(4, T);

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
