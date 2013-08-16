/**
 * itemSelectComponent.d
 * tower
 * May 10, 2013
 * Brandon Surmanski
 */

module ui.hud.itemSelectComponent;

import std.math;

import ui.component;
import ui.glbComponent;
import ui.imageComponent;

import scene.entity.actor;

class ItemSelectComponent : GlbComponent
{
    Component selector; //XXX WTF, errors all out if ImageComponent
    ImageComponent frames[4];
    scope ImageComponent active[4];

    this()
    {
        super();

        foreach(i; 0 .. 4)
        {
            frames[i] = new ImageComponent("res/tex/itemFrame.tga"); 
            frames[i]._size[] *= 2;
            frames[i].top = 8 + (8 + frames[i].size[1]) * i;
            frames[i].right = 8;

            active[i] = null;
        }

        selector = new ImageComponent("res/tex/itemSelect.tga");
        selector.size[] *= 2;
        selector.center = frames[0].center;
    }

    override void update(float dt)
    {
        // ease selector to selected
        float EASE_CONST = (dt * 8);
        int to_y = frames[Actor.focus.selectedItem].top - 2; //TODO: -2 is hacky
        int dy = cast(int) ceil((to_y - selector.top) * EASE_CONST);
        if(dy == 0 && to_y != selector.top) dy = cast(int) copysign(1, to_y - selector.top);
        selector.top = selector.top + dy;

        for(int i = 0; i < 4; i++)
        {
            //active[i] = Actor.focus;
        }
    }

    override void draw()
    {
        for(int i = 0; i < 4; i++)
        {
            frames[i].draw();
            if(active[i])
            {
                active[i].draw();
            }
        }

        selector.draw();
    }
}
