module main;

import c.gl.glfw;
import c.gl.gl;
import c.gl.glext;
import gl.glb.glb;

import std.stdio;
import std.math;

import lua.luaModule;
import lua.lib.all;
import container.geom.mesh;
import scene.scene;
import math.vector;
import math.matrix;
import scene.entity.entity;
import scene.entity.modelEntity;
import ui.hud.hud;
import map.map;
import scene.camera;

GLuint primQuery;
Camera cam;
Hud hud_display;
bool running;
Scene dscene;
 

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
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_TEXTURE_CUBE_MAP_SEAMLESS);
    glEnable(GL_SCISSOR_TEST);
    glEnable(GL_DEBUG_OUTPUT);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glDepthFunc(GL_LEQUAL);
    
    glGenQueries(1, &primQuery);

    running = true;

    cam = new Camera();
    cam.basis = Matrix4().skewedy(-PI / 4);
    //cam.position = Vec3(0.0f, 1.5f, 0.0f);

    //auto ent = new ModelEntity(state.state, "res/mdl/testroom.mdl", "res/tex/testroom.tga");

    dscene = new Scene("res/towerscene.scn");
    //dscene.add(ent);


    hud_display = new Hud();
}

void draw()
{
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    Entity.drawAll(cam);

    dscene.draw(cam);

    hud_display.draw();

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

    hud_display.update(dt);
    Entity.updateAll(dt);

    import scene.entity.actor;
    if(Actor.focus)
    {
        cam.position = Actor.focus.position + Vec3(0.0f, 3.5f, 5.0f); 
    }
}

void finalize()
{
    destroy(Entity.registry);
    destroy(EntityInfo.registry);
    glfwCloseWindow();
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
}
