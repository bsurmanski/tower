/**
 * box.d
 * tower
 * May 11, 2013
 * Brandon Surmanski
 */

import math.vector;

class Box3
{
    float p1[3];
    float p2[3];

    this(float[3] p1, float[3] p2)
    {
        this.p1 = p1.dup;
        this.p2 = p2.dup;
    }

    this(Vector4 p1, Vector4 p2)
    {
        this.p1 = p1.data.dup;
        this.p2 = p2.data.dup;
    }
}
