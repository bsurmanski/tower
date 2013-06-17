/**
 * grid.d
 * tower
 * May 26, 2013
 * Brandon Surmanski
 */

module container.geom.grid;

struct Grid(T)
{
    uint _w;
    uint _h;

    T _values[];

    this(uint w, uint h)
    {
        _w = w;
        _h = h;
        _values.length = (w * h);
    }

    this(uint w, uint h, T vals[])
    {
        _w = w;
        _h = h;
        _values = vals;
        _values.length = (w * h);
    }

    T opIndex(uint x, uint y)
    {
        assert(x < _w && y < _h, "Grid.opIndex: Index out of bounds");
        return _values[x + _w * y];   
    }

    void opIndexAssign(ref T val, uint x, uint y)
    {
        assert(x < _w && y < _h, "Grid.opIndexAssign: Index out of bounds");
        _values[x + _w * y] = val;
    }
}
