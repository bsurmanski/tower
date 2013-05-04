module main;

import c.gl.glfw;
import c.gl.gl;
import c.gl.glext;
import gl.glb.glb;

import std.stdio;

import lua.state;
import lua.lib.all;
import camera;
import vector;
import entity;
import mesh;
import map;

GLuint primQuery;
Buffer buffer = void;
Mesh quad = void;
Map testmap = void;
Camera cam;
bool running;

 

extern (C) int quit()
{
    running = false;
    return 1;
}

void init(int w, int h)
{
    glfwInit();
    glfwOpenWindowHint(GLFW_WINDOW_NO_RESIZE, 1);
    glfwOpenWindow(w, h, 8, 8, 8, 8, 32, 0, GLFW_WINDOW);
    glfwSetWindowCloseCallback(&quit);
    glClearColor(0.2f, 0.2f, 0.2f, 1.0f);
    glEnable(GL_BLEND);
    glEnable(GL_CULL_FACE);
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_TEXTURE_CUBE_MAP_SEAMLESS);
    glEnable(GL_SCISSOR_TEST);
    glEnable(GL_DEBUG_OUTPUT);
    //glDepthFunc(GL_LEQUAL);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glGenQueries(1, &primQuery);

    running = true;

    cam = new Camera();
    cam.position = Vector4(0.0f, 3.5f, 0.0f, 0.0f);

    //TODO load tiles
    Tile[] tiles = new Tile[32 * 32];
    testmap = Map(32, 32, tiles);

    State state = new State();
    state.register(luaApis);
    state.run("res/default.lua");
}

void draw()
{
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    testmap.draw(cam);
    Entity.drawAll(cam);
    glfwSwapBuffers();
}

void update()
{
    if(glfwGetKey(' '))
    {
        quit();
    }

    int nprims = 0;
    glGetQueryObjectiv(primQuery, GL_QUERY_RESULT, &nprims);
    static double t0 = 0.0, t1 = 0.0, dt;
    t1 = glfwGetTime();
    dt = t1 - t0;
    t0 = t1;
    write("FPS: ", 1.0 / dt, "; TRIS: ", nprims, "       \r");
    stdout.flush();

    Entity.updateAll(dt);
}

void main()
{
    init(640, 480);
    while(running)
    {
        update();
        glBeginQuery(GL_PRIMITIVES_GENERATED, primQuery);
        draw();
        glEndQuery(GL_PRIMITIVES_GENERATED);
    }

    glfwCloseWindow();
}
