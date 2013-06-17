/**
 * map.d
 * tower
 * April 26, 2013
 * Brandon Surmanski
 */

module map.map;

import std.math;
import std.stdio;

import gl.glb.glb;
import gl.glb.texture;
import c.gl.gl;
import c.gl.glext;

import container.geom.mesh;
import container.geom.grid;
import camera;
import math.matrix;

struct Tile
{
    ushort height;
    ushort texture;
}

struct Map
{
    static bool init = false;
    static Program program;
    static Sampler sampler = void;

    uint w;
    uint h;

    Grid!Tile tiles;

    Mesh mesh;
    Texture textureArray;

    this(uint w, uint h, Tile tiles[])
    {
        if(!init)
        {
            init = true;
            sampler = Sampler();
            sampler.setFilter(Sampler.NEAREST, Sampler.NEAREST);
            program = Program();        
            program.source("res/glsl/drawmap.vs", Shader.VERTEX_SHADER);
            program.source("res/glsl/drawmap.fs", Shader.FRAGMENT_SHADER);
        }

        this.w = w;
        this.h = h;
        this.tiles = Grid!Tile(w, h, tiles);//= tiles.dup;
        
        textureArray = Texture(Texture.RGBA, 16, 16, 16, 
                                   [
                                    "res/tex/grass.tga",
                                    "res/tex/water.tga",
                                    "res/tex/test.tga"
                                   ]);

        textureArray.setSampler(&sampler);


        // create new vertex array
        Vertex verts[] = new Vertex[w * h * 4];
        foreach(j; 0 .. h)
        {
             foreach(i; 0 .. w)
             {
                int index = (w * j + i);
                int vindex = 4 * index;
                float height = this.tiles[i, j].height / 8.0f;
                verts[vindex] = Vertex([i - 0.5f, height, j - 0.5f],
                                           [0, short.max, 0],
                                           [0, 0], 
                                           this.tiles[i, j].texture,
                                           [i, j]);

                verts[vindex + 1] = Vertex([i - 0.5f, height, j + 0.5f],
                                          [0, short.max, 0],
                                          [0, ushort.max],
                                          this.tiles[i, j].texture,
                                          [i, j]);

                verts[vindex + 2] = Vertex([i + 0.5f, height, j + 0.5f],
                                           [0, short.max, 0],
                                           [ushort.max, ushort.max],
                                           this.tiles[i, j].texture,
                                           [i, j]);

                verts[vindex + 3] = Vertex([i + 0.5f, height, j - 0.5f],
                                           [0, short.max, 0],
                                           [ushort.max, 0],
                                           this.tiles[i, j].texture,
                                           [i, j]);
             }
        }

        // create new face array
        Face faces[] = new Face[w * h * 2];
        foreach(j; 0 .. h)
        {
             foreach(i; 0 .. w)
            {
                ushort vindex = cast(ushort)((w * j + i) * 4);
                int findex = 2 * (w * j + i);
                faces[findex] = Face([vindex, 
                                      cast(ushort)(vindex + 1), 
                                      cast(ushort)(vindex + 2)]);
                faces[findex + 1] = Face([vindex, 
                                          cast(ushort)(vindex + 2), 
                                          cast(ushort)(vindex + 3)]);
            }
        }

        // add verts and faces to mesh
        mesh ~= verts;
        mesh ~= faces;
    }

    void draw(Camera cam)
    {
        //glDisable(GL_DEPTH_TEST);
        //glDisable(GL_CULL_FACE);
        Matrix4 mat;
        mat = cam.transformation;

        program.uniform(Shader.VERTEX_SHADER, 0, (float[16]).sizeof, true, mat.ptr);
        program.texture(Shader.FRAGMENT_SHADER, 0, textureArray);
        program.draw(mesh.getVertexBuffer(), mesh.getIndexBuffer());
    }
}
