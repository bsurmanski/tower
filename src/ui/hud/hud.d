/**
 * hud.d
 * tower
 * May 06, 2013
 * Brandon Surmanski
 */

module ui.hud.hud;

import gl.glb.glb;

import ui.hud.itemSelectComponent;
import ui.hud.healthComponent;
import ui.hud.wealthComponent;
import ui.component;
import ui.imageComponent;

class Hud
{
    Component components[];

    this()
    {
        components = [];

        Component itemSelect = new ItemSelectComponent();
        components ~= itemSelect;

        Component healthBar = new HealthComponent();
        components ~= healthBar;

        Component wealth = new WealthComponent();
        components ~=  wealth;
    }

    void update(float dt)
    {
        foreach(comp; components)
        {
            comp.update(dt);
        }
    }

    void draw()
    {
        foreach(comp; components)
        {
            comp.draw();
        }
    }
}
