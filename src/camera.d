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
        _pvdirty = true;
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

    @property Matrix4 basis() { return _basis; }
    @property void basis(Matrix4 m) { _basis = m; }

    @property Matrix4 perspective() { return _pmatrix; }
    @property void perspective(Matrix4 m) { _pmatrix = m; }

    @property Matrix4 view() { return _vmatrix; }
    @property void view(Matrix4 m) { _vmatrix = m; }

    @property Matrix4 transformation() 
    {
        if(_pvdirty)
        {
            _pvmatrix = _pmatrix * _vmatrix;
            _pvdirty = false;
        }
        return _pvmatrix; 
    }

}
