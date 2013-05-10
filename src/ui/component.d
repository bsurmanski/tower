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
    static int SCREEN_W = 640; //TODO: put this somewhere reasonable
    static int SCREEN_H = 480;

    // enumerated values
    int _position_enum = normal;
    int _filter_enum = nearest;

    // pixel space values
    int _position[2] = [0, 0]; ///< relative to bottom left of component, and bottom left of screen
    int _size[2] = [0,0];

    this(){}

    @property ref int filter        () { return _filter_enum; }
    @property ref int width         () { return _size[0]; }
    @property ref int height        () { return _size[1]; }
    @property ref int[2] size       () { return _size; }

    @property int left() { return _position[0]; }
    @property void left(int nleft) { _position[0] = nleft; }
    @property int right() { return SCREEN_W - _position[0] - _size[0]; }
    @property void right(int nright) { _position[0] = SCREEN_W - _size[0] - nright; }
    @property int top() { return SCREEN_H - _position[1] - _size[1]; }
    @property void top(int ntop) { _position[1] = SCREEN_H - _size[1] - ntop; };

    abstract void draw();
    //abstract void listen(Entity ent);
}
