/**
 * component.d
 * tower
 * May 06, 2013
 * Brandon Surmanski
 */

module ui.component;

import entity.entity;

//Alignment
enum
{
    left,
    right,
    top,
    bottom
};

//Positioning
enum 
{
    normal,
    relative,
    absolute,
    fixed,
};

// Filter
enum
{
    nearest,
    linear,
}

abstract class Component
{
    Component parent = null;
    Component[] children;

    static int SCREEN_W = 640; //TODO: put this somewhere reasonable
    static int SCREEN_H = 480;

    // enumerated values
    int _position_enum = normal;
    int _filter_enum = nearest;

    // pixel space values
    int _position[2] = [0, 0]; ///< relative to bottom left of component, and bottom left of screen
    int _size[2] = [0,0];

    this(){}
    this(Component parent = null) { this.parent = parent; }

    @property ref int filter        () { return _filter_enum; }
    @property ref int width         () { return _size[0]; }
    @property ref int height        () { return _size[1]; }
    @property ref int[2] size       () { return _size; }

    @property ref int[2] position() { return _position; }
    @property void position(int [2] npos) { _position[] = npos[]; }
    @property int left () { return position[0]; }
    @property void left(int nleft) { position[0] = nleft; }
    @property int right () { return SCREEN_W - position[0] - _size[0]; }
    @property void right(int nright) { left = SCREEN_W - _size[0] - nright; }
    @property int top () { return SCREEN_H - position[1] - _size[1]; }
    @property void top(int ntop) { bottom = SCREEN_H - _size[1] - ntop; }
    @property int bottom () { return position[1]; }
    @property void bottom(int nbottom) { position[1] = nbottom; }
    @property int[2] center() { int[2] center = position[]; center[] += _size[] / 2; return center; }
    @property void center  (int[2] _ncenter) { position[] = _ncenter[]; position[] -= _size[] / 2;}
    @property int xcenter () { return position[0] + _size[0] / 2;; }
    @property void xcenter(int nxcenter) { position[0] = nxcenter - _size[0] / 2; }
    @property int ycenter () { return position[1] + _size[1] / 2;; }
    @property void ycenter(int nxcenter) { position[1] = nxcenter - _size[1] / 2; }

    void update(float dt){}
    abstract void draw();
    //abstract void listen(Entity ent);
}
