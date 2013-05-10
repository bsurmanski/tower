/**
 * hud.d
 * tower
 * May 06, 2013
 * Brandon Surmanski
 */

module ui.hud.hud;

import gl.glb.glb;

import ui.component;
import ui.imageComponent;

class Hud
{
    Component components[];

    this()
    {
        components = [];
        
        Component bat = new ImageComponent("res/tex/bat.tga");
        bat.size[] *= 4;
        bat.right = 8;
        components ~= bat;
    }

    void draw()
    {
        foreach(comp; components)
        {
            comp.draw();
        }
    }
}
