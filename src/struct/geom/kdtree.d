/**
 * kdtree.d
 * tower
 * May 14, 2013
 * Brandon Surmanski
 */

module kdtree;

import std.math;

import math.vector;

private struct KdRange(T)
{
    uint _front = 0;
    uint _n = 0;
    Vec3 _target;

    float _distances[];
    KdNode!T *_nodes[];

    this(const ref Vec3 target, int max)
    {
        _target = target;
        _nodes.length = max; 
        _distances.length = max;
    }

    @property bool empty() { return _front >= _n; }
    @property KdNode!T *front() { assert(!empty, "KdRange is empty"); return _nodes[_front]; }
    @property KdNode!T *back() { assert(!empty, "KdRange is empty"); return _nodes[_n-1]; }
    
    bool threshold(float distance)
    {
        return !_n || (distance * distance) < _distances[_n - 1];
    }

    bool tryInsert(ref KdNode!T node)
    {
        bool ret = false;
        float node_dsq = _target.distanceSquared(node._position);

        if(!_n)
        {
            _distances[0] = node_dsq;
            _nodes[0] = &node;
            _n++;
        } else if(_n < _nodes.length || node_dsq < _distances[_n-1])
        {
            for(uint i = _n; i >= 0; i--)
            {
                if(i == 0 || node_dsq > _distances[i-1])
                {
                    if(_n < _nodes.length) _n++;

                    for(uint j = _n - 1; j > i; j--)
                    {
                        _distances[j] = _distances[j-1];
                        _nodes[j] = _nodes[j-1];
                    }
                    
                    _distances[i] = node_dsq;
                    _nodes[i] = &node;
                    ret = true;
                    break;
                }
            }
        }

        return ret; 
    }

    KdNode!T *popFront()
    {
        KdNode!T *ret = front;
        _front++;
        return ret;
    }
}

private struct KdNode(T)
{
    KdNode!T *_parent;
    KdNode!T *_children[2];
    Vec3 _position;
    T _val;

    @property Vec3 position() { return _position; }
    @property T value() { return _val; }


    this(KdNode!T *parent, const ref Vec3 point, ref T val)
    {
        _parent = parent;
        _position = point;
        _val = val;
    }

    int next_axis(int axis)
    {
        switch(axis)
        {
            case 0: return 1;
            case 1: return 2;
            case 2: return 0;
            default:assert(false, "what axis are you trying to access??");
        }
    }

    int next_side(int side)
    {
        return side == 0 ? 1 : 0;
    }

    size_t insert(const ref Vec3 point, ref T t, int axis)
    {
        size_t ret = 0;
        int side = (point[axis] > _position[axis] ? 1 : 0); 
        if(_children[side])
        {
            ret = _children[side].insert(point, t, next_axis(axis));
        } else
        {
            _children[side] = new KdNode(&this, point, t);
            ret = 1;
        }

        return ret;
    }

    void closest(const ref Vec3 point, int axis, KdRange!T *r)
    {
        int side = (point[axis] > _position[axis] ? 1 : 0);
        r.tryInsert(this);

        if(_children[side])
        {
            _children[side].closest(point, next_axis(axis), r);
        }
        side = next_side(side);
        if(_children[side])
        {
            if(r.threshold(fabs(point[axis] - _position[axis])))
            {
                _children[side].closest(point, next_axis(axis), r);
            }
        }
    }
}

struct KdTree(T)
{
    KdNode!T *_root = null;
    size_t _length;

    @property bool empty() { return !_root; }
    @property size_t length() { return _length; }

    size_t insert(const Vec3 point, T t)
    {
        if(empty)
        {
            _root = new KdNode!T(null, point, t);
            _length++;
            return 1;
        } 

        size_t inserted = _root.insert(point, t, 0); 
        _length += inserted;
        return inserted;
    }

    KdRange!T closest(const Vec3 point, uint n)
    {
        assert(length >= n, "The KdTree must have more values than searched!"); 
        KdRange!T range = KdRange!T(point, n);
        _root.closest(point, 0, &range);
        return range;
    }

    KdNode!T closest(const Vec3 point)
    {
        KdRange!T range = closest(point, 1);
        return *range.front;
    }
} unittest
{
    KdTree!int tree;
    import std.random;
    import std.stdio;
    
    Vec3 target = Vec3(0.0f, 0.0f, 0.0f);
    Vec3 closest;
    int closest_i;
    foreach(i; 0 .. 1000)
    {
        Vec3 vec = Vec3(uniform(-100.0f, 100.0f), uniform(-100.0f, 100.0f), uniform(-100.0f, 100.0f));

        if(i == 0 || vec.distanceSquared(target) < closest.distanceSquared(target))
        {
            closest = vec;
            closest_i = i;
        }

        tree.insert(vec, i);
    }

    foreach(node; tree.closest(target, 10))
    {
        writeln(node.position, " : ", node.value);
    }

    writeln(tree.closest(target).value, ": ", closest_i);
    writeln(tree.closest(target).position, ": ", closest);
    assert(tree.closest(target).value == closest_i);
}

alias TEST = KdTree!float;
