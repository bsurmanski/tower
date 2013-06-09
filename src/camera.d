/**
 * camera.d
 * tower
 * May 02, 2013
 * Brandon Surmanski
 */

module camera;

import std.math;

import math.matrix;
import math.vector;

class Camera
{
    private:

    Matrix4 _pmatrix;
    Matrix4 _vmatrix;
    Matrix4 _pvmatrix;
    Matrix4 _basis; // axis basis

    bool _pvdirty = false;

    Vec3 _position;

    public:

    this()
    {
        _pmatrix = Matrix4(-1, 1, -1, 1, 1, 1677216); 
        _basis = Matrix4().skewedy(-PI / 4);
    }

    @property
    Vec3 position()
    {
        return _position;
    }

    @property 
    void position(Vec3 newPosition)
    {
        _position = newPosition;

        _vmatrix = Matrix4();
        _vmatrix.translate(_position * -1.0f);
        _vmatrix.rotate(PI / 4.0f, 1.0f, 0, 0);

        _pvdirty = true;

    }

    Matrix4 perspectiveMatrix()
    {
        return _pmatrix;
    }

    Matrix4 viewMatrix()
    {
        return _vmatrix;
    }

    Matrix4 getMatrix()
    {
        if(_pvdirty)
        {
            _pvmatrix = _pmatrix * _vmatrix;
            _pvdirty = false;
        }

        return _pvmatrix;
    }

    Matrix4 basisMatrix()
    {
        return _basis; 
    }
}
