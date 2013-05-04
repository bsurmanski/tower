/**
 * camera.d
 * tower
 * May 02, 2013
 * Brandon Surmanski
 */

module camera;

import std.math;

import matrix;
import vector;

/**
 * TODO: dirty flag for when pvmatrix needs to be updated
 */
class Camera
{
    Matrix4 _pmatrix;
    Matrix4 _vmatrix;
    Matrix4 _pvmatrix;

    Vector4 _position;

    this()
    {
        _pmatrix = Matrix4(-1, 1, -1, 1, 1, 1677216); 
    }

    @property
    Vector4 position()
    {
        return _position;
    }

    @property 
    void position(Vector4 newPosition)
    {
        _position = newPosition;

        _vmatrix = Matrix4();
        _vmatrix.translate(_position * -1.0f);
        _vmatrix.rotate(PI / 4.0f, 1.0f, 0, 0);

        _pvmatrix = _pmatrix * _vmatrix;
    }

    Matrix4 getMatrix()
    {
        return _pvmatrix;
    }
}
