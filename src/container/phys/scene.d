module container.phys.scene;

import std.file;
import std.stdio;

import math.quat;
import math.vector;
import entity.entity;
import container.geom.mesh;


class Scene
{
    Entity roots[];
    //Resource resources[];

    struct Header
    {
        char magic[3];
        ubyte ver;
        ushort npacks;
        ushort nents;
        ubyte padding[8];
        char name[16];
    }

    struct PackHeader
    {
        ubyte type;
        ubyte ident[3];
        uint datasz;
        ubyte padding[8];
        char name[16];
    }

    struct EntHeader
    {
        ushort parentId;
        ushort nrefs;
        float[3] position;
        float[3] quat;
        float[3] scale;
    }

    this(string filenm)
    {
        File file = File(filenm, "r");
        this(file);
        file.close();
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
            file.seek(pHeaders[i].datasz, SEEK_CUR); //skip datasz TODO read data instead of skip
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
            long mod = (EntHeader.sizeof + eHeaders[i].nrefs * ushort.sizeof) % 16;
            if(mod) // skip 16 byte pack padding
            {
                file.seek(16 - mod, SEEK_CUR); //TODO: some how doesnt match up
            }
        }
        return;
    }
}
