/**
 * mesh.d
 * tower
 * April 25, 2013
 * Brandon Surmanski
 */

module container.geom.mesh;

import c.gl.glb.glb;
import gl.glb.glb;

import math.matrix;
import std.file;
import std.stdio;
import std.conv;

struct Vertex
{
    float position[3];
    short normal[3];
    ushort uv[2];
    ushort material;
    //ubyte id[2];    //bone id, position, etc 
    //ubyte weight[2];
    //ubyte PADDING[4];
    uint id[2];
} unittest
{
    assert(Vertex.sizeof == 32);
}

struct Face
{
    ushort vertIds[3];

    ushort vertex(int i)
    in {
        assert(0 < i && i < 3);
    } body {
        return vertIds[i];
    }
}

private struct Header
{
    char  magic[3];
    ubyte ver;
    uint  nverts;
    uint  nfaces;
    char  name[16];
    ubyte PADDING[4];
} unittest
{
    assert(Header.sizeof == 32);
}

struct Mesh
{
    uint  material;
    ubyte nbones;

    char name[16];

    bool vdirty;
    bool fdirty;

    Vertex verts[];
    Face faces[];

    Buffer *vbuffer = null;
    Buffer *ibuffer = null;

    this(const Vertex verts[])
    {
        //ibuffer = Buffer.init;
        //vbuffer = Buffer.init;
        add(verts);
        if(verts.length) vdirty = true;
        fdirty = false;
    }

    this(const Vertex verts[], const Face faces[])
    {
        //ibuffer = Buffer.init;
        //vbuffer = Buffer.init;
        add(verts);  
        add(faces);

        if(verts.length) vdirty = true;
        if(faces.length) fdirty = true;
    }

    this(string filenm)
    {
        //ibuffer = Buffer.init;
        //vbuffer = Buffer.init;
        File file = File(filenm, "r"); 

        Header header;
        file.rawRead((&header)[0..1]);

        verts.length = header.nverts;
        faces.length = header.nfaces;
        file.rawRead(verts); 
        file.rawRead(faces);
        file.close();

        vdirty = true;
        fdirty = true;
    }

    ~this(){}

    void opOpAssign(string op)(const Face f[])
    if(op == "~")
    {
        this.add(f); 
    }

    void opOpAssign(string op)(const Vertex v[])
    if(op == "~")
    {
        this.add(v); 
    }

    void opOpAssign(string op)(const Face f)
    if(op == "~")
    {
        this.add(f); 
    }

    void opOpAssign(string op)(const Vertex v)
    if(op == "~")
    {
        this.add(v); 
    }

    void opOpAssign(string op)(const Mesh m)
    if(op == "~")
    {
        this.add(m); 
    }

    /**
     * adds a set of faces to this mesh
     */
    void add(const Face f[])
    {
        faces ~= f;
        fdirty = true;
    }

    /**
     * adds a set of vertices to this mesh
     */
    void add(const Vertex v[])
    {
        verts ~= v;
        vdirty = true;
    }

    /**
     * adds a single face to this mesh
     */
    void add(const Face f)
    {
        faces ~= f;
        fdirty = true;
    }

    /**
     * adds a single vertex to this mesh
     */
    void add(const Vertex v)
    {
        verts ~= v;
        vdirty = true;
    }

    void add(Mesh m)
    {
        int flen = to!int(faces.length);
        verts ~= m.verts;
        faces ~= m.faces;
        foreach(ref face; faces[flen .. $])
        {
            foreach(ref fvert; face.vertIds)
            {
                fvert += flen; 
            }
        }
        fdirty = true;
        vdirty = true;
    }

    void transform(Matrix4 matrix)
    {
            writeln(matrix);
        foreach(ref v; verts)
        {
            import math.vector;
            writeln(v.position);
            v.position = 
                (matrix * Vec4([v.position[0], v.position[1], v.position[2], 1.0f])).data[0..3].dup;
            //v.normal = (matrix * [v.normal[0], v.normal[1], v.normal[2], 0.0f])[0..4];
            //TODO: normal (note: normal is packed as short)
        }
    }


    void setName(string str)
    in {
        assert(str.length <= 16);
    } body {
        for(auto i = 0; i < name.length; i++)
        {
            if(i < str.length)
            {
                name[i] = str[i];
            } else
            {
                name[i] = 0;
            }
        }
    }

    ref Buffer getVertexBuffer()
    {
        static GLBVertexLayout vlayout[] =
        [
            {3, GLB_FLOAT,  false,  32, 0},  //position
            {3, GLB_SHORT,  true,   32, 12}, //normal
            {2, GLB_USHORT, true,   32, 18}, //uv
            {1, GLB_USHORT, false,  32, 22}, //material
            {2, GLB_UINT, false,  32, 24}, //material
            //{2, GLB_UBYTE,  false,  32, 24}, //boneid
            //{2, GLB_UBYTE,  true,   32, 26}, //boneweight
        ];

        if(vdirty)
        {
            if(vbuffer)
            {
                destroy(vbuffer);
            }

            vbuffer = new Buffer(verts, vlayout);
            vdirty = false;
        }

        return *vbuffer;
    }

    ref Buffer getIndexBuffer()
    {
        if(fdirty)
        {
            if(ibuffer)
            {
                destroy(ibuffer);
            }

            ibuffer = new Buffer(faces, GLB_USHORT, Buffer.STATIC_DRAW);
            fdirty = false;
        }
        return *ibuffer;
    }

    void write(string filenm)
    {
        Header header =
        {
            "MDL",
            3,
            to!int(verts.length),
            to!int(faces.length),
            name
        };

        File file = File(filenm, "w");
        file.write(header);
        file.write(verts);
        file.write(faces);
        file.close();
    }

    static ref Mesh getUnitQuad() { return _quad; }

    static const Vertex[] quad_verts =  
    [
         // Triangle 1
         {
             [-1,-1,0],
             [0,0,1],
             [0,0]
         },
         {
             [1,-1,0],
             [0,0,1],
             [1,0]
         },
         {
             [1,1,0],
             [0,0,1],
             [1,1]
         },
         
         // Triangle 2
         {
             [-1,-1,0],
             [0,0,1],
             [0,0]
         },
         {
             [1,1,0],
             [0,0,1],
             [1,1]
         },
         {
             [-1,1,0],
             [0,0,1],
             [0,1]
         }
     ];

    static Mesh _quad = Mesh(quad_verts);
}
