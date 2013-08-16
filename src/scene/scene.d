module scene.scene;

import std.file;
import std.stdio;

import math.quat;
import math.vector;
import scene.entity.entity;
import container.geom.mesh;
import container.list;

import scene.camera;
import scene.entity.modelEntity;

class Scene
{
    Entity roots[];
    List!Entity entities;
    //Resource resources[]; //TODO
    //
    Mesh meshes[];
    Camera cameras[];
    Camera active_camera;

    private struct Header
    {
        char magic[3];
        ubyte ver;
        ushort npacks;
        ushort nents;
        ubyte padding[8];
        char name[16];
    }

    private struct PackHeader
    {
        ubyte type;
        ubyte ident[3];
        uint datasz;
        ubyte padding[8];
        char name[16];
    }

    private struct EntHeader
    {
        ushort parentId;
        ushort nrefs;
        float[3] position;
        float[3] quat;
        float[3] scale;
    }

    this()
    {
    
    }

    this(string filenm)
    {
        File file = File(filenm, "r");
        this(file);
        file.close();
    }

    void readPack(File file, PackHeader pHeader)
    {
        long end = file.tell() + pHeader.datasz;
        if(pHeader.ident == "MDL")
        {
            Mesh mesh = Mesh(file);
            meshes ~= mesh;
            //TODO add entity
            //auto minfo = new ModelInfo(main.state.state, mesh, test);
            //ents ~= new ModelEntity(minfo.id);
        } //else if(pHeader.ident == "TGA")
        //{
            
        //}
        else //unknown type, skip
        {
            file.seek(pHeader.datasz, SEEK_CUR); //skip datasz TODO read data instead of skip
        }

        assert(file.tell() <= end); // not allowed to overread
        file.seek(end);
    }

    this(File file)
    {
        Header header;
        file.rawRead((&header)[0..1]);
        PackHeader[] pHeaders;
        EntHeader[] eHeaders;
        pHeaders.length = header.npacks;
        eHeaders.length = header.nents;
        
        // read packs
        for(int i = 0; i < header.npacks; i++)
        {
            file.rawRead(pHeaders[i..i+1]);
            readPack(file, pHeaders[i]);
            long mod = (PackHeader.sizeof + pHeaders[i].datasz) % 16;
            if(mod) // skip 16 byte pack padding
            {
                file.seek(16 - mod, SEEK_CUR);
            }
        }

        // read ents
        for(int i = 0; i < header.nents; i++)
        {
            file.rawRead(eHeaders[i..i+1]); 
            file.seek(eHeaders[i].nrefs * ushort.sizeof, SEEK_CUR); //TODO do something with refs
            long mod = (EntHeader.sizeof + eHeaders[i].nrefs * ushort.sizeof) % 16;
            if(mod) // skip 16 byte pack padding
            {
                file.seek(16 - mod, SEEK_CUR); //TODO: some how doesnt match up
            }
        }
        return;
    }

    void add(Entity e)
    {
    
    }

    void update(float dt)
    {
        foreach(ent; roots)
        {
            ent.update(this, dt);
        }
    }

    void draw()
    {
        foreach(ent; roots)
        {
            ent.draw(this);
        }
    }
}
