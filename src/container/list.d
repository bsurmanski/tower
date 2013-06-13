/**
 * list.d
 * tower
 * May 25, 2013
 * Brandon Surmanski
 */

module container.list;

import std.functional;
import std.traits;

struct List(T)
{
    Node!T *_first = null;
    Node!T *_last = null;
    size_t _length;

    @property size_t length() { return _length; }

    @property const nothrow
    bool empty()
    {
        assert(!!_first == !!_last, "List: internal error, inconsistant list");
        return _first is null;
    }

    @property ref T front()
    {
        assert(!empty, "List.front: List is empty");
        return _first._value;
    }

    @property ref T back()
    {
        assert(!empty, "List.front: List is empty");
        return _last._value;
    }

    @property Node!T *begin() { return _first; }
    @property Node!T *end() { return _last; }

    /* TODO
    Node!T *opSlice()
    {
        assert(!empty, "cannot slice empty list");
        return _first;
    }*/

    List!T opOpAssign(string op)(auto ref T rhs)
    if(op == "~")
    {
        this.insertBack(rhs);
        return this;
    }

    int opApply(int delegate(ref T) dg) 
    {
        int ret = 0;
        Node!T *node = _first; 
        while(node && !ret)
        {
            dg(node._value);
            node = node.next();
        }
        return ret;
    }

    int opApply(int delegate(int i, ref T) dg) 
    {
        int ret = 0;
        int i = 0;
        Node!T *node = _first; 
        while(node && !ret)
        {
            dg(i, node._value);
            i++;
            node = node.next();
        }
        return ret;
    }

    size_t insertBack(ref T val)
    {
        Node!T *node = new Node!T(val);

        if(!_last)
        {
            _first = node; 
            _last = node;
        } else
        {
            node.moveAfter(_last);
            _last = node;
        }

        _length++;

        return 1;
    }

    size_t insertFront(ref T val)
    {
        Node!T *node = new Node!T(val);

        if(!_first)
        {
            _first = node; 
            _last = node;
        } else
        {
            node.moveBefore(_first);
            _first = node;
        }

        _length++;

        return 1;
    }

    void append(U)(U val)
    if(isImplicitlyConvertible!(U, T))
    {
        insertBack(val);
    }

    T remove(T value)
    {
        for(Node!T *n = begin; n != null; n = n.next)
        {
            if(n.value == value)
            {
                return remove(n);
            }
        }
        return T.init;
    }

    T remove(Node!T *node)
    {
        if(node._prev)
        {
            node._prev._next = node._next;
        }

        if(node._next)
        {
            node._next._prev = node._prev;
        }

        if(node == _last)
        {
            _last = node._prev;
        }

        if(node == _first)
        {
            _first = node._next;
        }

        T ret = node._value;
        destroy(node);
        _length--;

        return ret;
    }

    /**
     * damn right bubble sort. The list should be mostly sorted anyways
     */
    void sort(alias less = "a < b")()
    {
        alias binaryFun!less lessFun;
        bool sorted = false;

        for(auto i = this.end(); i != this.begin() && !sorted; i = i.prev())
        {
            sorted = true;
            for(auto j = this.begin(); j != i; j = j.next())
            {
                auto next = j.next();
                if(lessFun(next.value, j.value))
                {
                    if(j == this._first)
                    {
                        this._first = next;
                    }

                    if(next == this._last)
                    {
                        this._last = j;
                    }

                    next.moveBefore(j); 


                    if(next == i)
                    {
                        i = j;
                    }

                    j = next;

                    sorted = false;
                }
            }
        }
    }

    bool sorted(alias less = "a < b")()
    {
        alias binaryFun!less lessFun;

        auto it = this.begin();
        while(it)
        {
            import std.stdio;
            if(it.next && lessFun(it.next.value, it.value))
            {
                return false;
            }

            it = it.next();
        }
        return true;
    }

    struct Node(T)
    {
        Node!T *_prev = null;
        Node!T *_next = null;
        T _value;

        Node!T *prev() { return _prev; }
        Node!T *next() { return _next; }
        T value() { return _value; }

        this(T val, Node!T *prev = null, Node!T *next = null)
        {
            _value = val;
            _prev = prev;
            _next = next;
            if(prev) prev._next = &this;
            if(next) prev._prev = &this;
        }

        ~this()
        {
            _prev = null;
            _next = null;
            destroy(_value);
        }

        void moveBefore(Node!T *node)
        {
            assert(node, "cannot insert null node");

            if(_next)
            {
                _next._prev = _prev; 
            }

            if(_prev)
            {
                _prev._next = _next;
            }

            this._prev = node._prev;
            this._next = node;

            if(node._prev)
            {
                node._prev._next = &this; 
            }

            node._prev = &this;
        }

        void moveAfter(Node!T *node)
        {
            assert(node, "cannot insert null node");

            if(_next)
            {
                _next._prev = _prev; 
            }

            if(_prev)
            {
                _prev._next = _next;
            }

            this._prev = node;
            this._next = node._next;

            if(node._next)
            {
                node._next._prev = &this; 
            }

            node._next = &this;
        }

        int opApply(int delegate(ref Node!T) dg) 
        {
            int ret = dg(this);

            if(!_next || ret)
            {
                return ret;
            }

            return _next.opApply(dg);
        }
    }
}
