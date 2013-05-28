/**
 * matrix.d
 * tower
 * April 28, 2013
 * Brandon Surmanski
 */

module math.matrix;

import std.stdio;
import std.math;

import math.vector;

struct Matrix4
{
    private:
        float v[16] = [1,0,0,0,
                       0,1,0,0,
                       0,0,1,0,
                       0,0,0,1]; 

        enum {
            XX = 0,
            XY = 4,
            XZ = 8,
            XW = 12,

            YX = 1,
            YY = 5,
            YZ = 9,
            YW = 13,

            ZX = 2,
            ZY = 6,
            ZZ = 10,
            ZW = 14,

            WX = 3,
            WY = 7,
            WZ = 11,
            WW = 15
        };

    public:

/*{{{ Properties*/
        @property float *ptr() {return v.ptr;};

        @property ref float xx() {return v[0];};
        @property ref float xy() {return v[1];};
        @property ref float xz() {return v[2];};
        @property ref float xw() {return v[3];};

        @property ref float yx() {return v[4];};
        @property ref float yy() {return v[5];};
        @property ref float yz() {return v[6];};
        @property ref float yw() {return v[7];};

        @property ref float zx() {return v[8];};
        @property ref float zy() {return v[9];};
        @property ref float zz() {return v[10];};
        @property ref float zw() {return v[11];};

        @property ref float wx() {return v[12];};
        @property ref float wy() {return v[13];};
        @property ref float wz() {return v[14];};
        @property ref float ww() {return v[15];};
/*}}}*/

/*{{{ Constructors*/
        /**
         * frustum constructor
         */
        this(float l, float r, float b, float t, float n, float f)
        {
            v[XX] = 2.0f * n / (r - l); 
            v[XY] = 0.0f;
            v[XZ] = 0.0f;
            v[XW] = 0.0f;

            v[YX] = 0.0f;
            v[YY] = (2.0f * n) / (t - b);
            v[ZY] = (t + b) / (t - b);
            v[YW] = 0.0f;

            v[ZX] = (r + l) / (r - l);
            v[YZ] = 0.0f;
            v[ZZ] = -(f + n) / (f - n);
            v[ZW] = -1.0f;

            v[WX] = 0.0f;
            v[WY] = 0.0f;
            v[WZ] = -(f * n) / (f - n);
            v[WW] = 0.0f;
        }

        this(typeof(this) m)
        {
            this.v = m.v.dup;
        }

        this(float[16] arr)
        {
            this.v = arr.dup;
        }

        /**
         * orientation constructor
         */
        this(Vec4 up, Vec4 fwd)
        {
            //TODO 
        }
/*}}}*/

/*{{{ Op Overloads*/
        /**
         * copy array elements
         */

        ref float opIndex(int index)
        {
            return this.v[index]; 
        }

        /**
         * binary operators
         */
        typeof(this) opBinary(string op)(float rhs) const
        {
            Matrix4 ret;
            for(auto i = 0; i < 4; i++)
            {
                for(auto j = 0; j < 4; j++)
                {
                    mixin("ret.v[j + i * 4] = v[j + i * 4]" ~op~ "rhs;");
                }
            }
            return ret;
        }

        Vec4 opBinary(string op)(auto ref const Vec4 rhs)
        {
            Vec4 ret;
            for(auto j = 0; j < 4; j++)
            {
                ret[j] = v[j]         * rhs[0] + 
                         v[j + 4 * 1] * rhs[1] +
                         v[j + 4 * 2] * rhs[2] +
                         v[j + 4 * 3] * rhs[3];
            }
            return ret; 
        }

        typeof(this) opBinary(string op)(auto ref const typeof(this) rhs) const
        {
            Matrix4 ret; 
            ret.v = [0,0,0,0,
                     0,0,0,0,
                     0,0,0,0,
                     0,0,0,0];

            static if(op == "*")
            {
                for(auto i = 0; i < 4; i++)
                {
                    for(auto j = 0; j < 4; j++)
                    {
                        for(auto k = 0; k < 4; k++)
                        {
                            mixin("ret.v[j + i * 4] += v[i * 4 + k]" ~op~ "rhs.v[j + k * 4];");
                        }
                    }
                }
            } else
            {
                for(auto i = 0; i < 4; i++)
                {
                    for(auto j = 0; j < 4; j++)
                    {
                        mixin("ret.v[j + i * 4] = v[j + i * 4]" ~op~ "rhs.v[j + i * 4];");
                    }
                }
            }

            return ret;
        } unittest
        {
            Matrix4 a = Matrix4([2,0,0,0,
                                 0,2,0,0,
                                 0,0,2,0,
                                 0,0,0,2]);
            Matrix4 b;
            Matrix4 c = Matrix4([0,1,0,0,
                                 0,0,1,0,
                                 1,0,0,0,
                                 0,0,0,1]);


            //matrix-vector
            Vec4 test = Vec4(1.0f,2.0f,3.0f,4.0f);
            Vec4 mtest = c * test;
            assert(mtest == Vec4(3.0f,1.0f,2.0f,4.0f));

            // matrix matrix scale
            assert((a * b) == a);

            //matrix matrix convolve
            Matrix4 ca = c * a;
            Matrix4 c2 = c * 2;
            assert(ca == c2);
            assert((c * a) == (c * 2));
        }
/*}}}*/

/*{{{ Scale */
        void scale(float f)
        {
            scale(Vec4(f,f,f,f));
        }

        void scale(float x, float y, float z, float w = 1.0f)
        {
            scale(Vec4(x,y,z,w)); 
        }

        void scale(Vec4 v)
        {
            this.v = (scaled(v)).v;
        }

        Matrix4 scaled(float f) const
        {
            return scaled(Vec4(f,f,f,f));
        }

        Matrix4 scaled(Vec4 v) const
        {
            Matrix4 tmat;
            tmat.v[XX] = v[0];
            tmat.v[YY] = v[1];
            tmat.v[ZZ] = v[2];
            tmat.v[WW] = v[3];

            return tmat * this;
        }
/*}}}*/

/*{{{ Translate */
        void translate(float x, float y, float z)
        {
            translate(Vec3(x, y, z));
        }

        void translate(Vec3 v)
        {
            this.v = (translated(v)).v;
        }

        typeof(this) translated(float x, float y, float z) const
        {
            return translated(Vec3(x, y, z)); 
        }

        typeof(this) translated(Vec3 v) const
        {
            Matrix4 tmat;
            tmat.v[WX] = v[0];
            tmat.v[WY] = v[1];
            tmat.v[WZ] = v[2];
            //tmat.v[WW] = 1.0f;

            return tmat * this;
        }
/*}}}*/

/*{{{ Rotate*/
        void rotate(float angle, float x, float y, float z)
        {
            Vec4 vec = Vec4(x, y, z, 0.0f);
            rotate(angle, vec);
        }

        void rotate(float angle, Vec4 vec)
        {
            this.v = this.rotated(angle, vec).v;
        }

        Matrix4 rotated(float angle, Vec4 vec) const
        {
            Matrix4 aux;
            if(abs(angle) < float.epsilon) return Matrix4(this);

            float len = vec.length();
            if(len < float.epsilon) return Matrix4(this);

            Vec4 n = vec.normalized();

            float c = cos(angle);
            float t = 1.0f - c;
            float s = sin(angle);
            float x = vec[0];
            float y = vec[1];
            float z = vec[2];

            aux[XX] = t * x * x + c;
            aux[XY] = t * x * y + s * z;
            aux[XZ] = t * x * z - s * y;


            aux[YX] = t * y * y - s * z;
            aux[YY] = t * y * y + c;
            aux[YZ] = t * y * z + s * x;

            aux[ZX] = t * x * z + s * y;
            aux[ZY] = t * y * z - s * x;
            aux[ZZ] = t * z * z + c;

            aux[WX] = aux[WY] = aux[WZ] = 0.0f;
            aux[XW] = aux[YW] = aux[ZW] = 0.0f;
            aux[WW] = 1.0f;
            
            return (aux * this);
        }
/*}}}*/

/*{{{ Skew*/

        void skewy(float angle)
        {
            this.v = this.skewedy(angle).v;
        }

        Matrix4 skewedy(float angle)
        {
            Matrix4 m =[1, 0,          0, 0,
                        0, 1,          0, 0,
                        0, tan(angle), 1, 0,
                        0, 0,          0, 1,];

            return m * this;
        }

/*}}}*/

        void print()
        {
            writeln("[", v[XX], ", ", v[YX], ", ", v[ZX], ", ", v[WX]); 
            writeln(" ", v[XY], ", ", v[YY], ", ", v[ZY], ", ", v[WY]); 
            writeln(" ", v[XZ], ", ", v[YZ], ", ", v[ZZ], ", ", v[WZ]); 
            writeln(" ", v[XW], ", ", v[YW], ", ", v[ZW], ", ", v[WW], "]"); 
        }
}
