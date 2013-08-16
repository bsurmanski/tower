/**
 * healthComponent.d
 * tower
 * May 11, 2013
 * Brandon Surmanski
 */

module ui.hud.healthComponent;

import ui.component;
import ui.glbComponent;
import ui.imageComponent;

import scene.entity.actor;

class HealthComponent : GlbComponent
{
    Component frame;
    Component bar;

    float total;

    this()
    {
        super();

        frame = new ImageComponent("res/tex/healthBarFrame.tga");
        frame.size[] *= 2;
        frame.top = 8;
        frame.left = 8;

        bar = new ImageComponent("res/tex/healthBar.tga");
        bar.size[] *= 2;
        bar.top = 10;
        bar.left = 10;

        total = bar.size[0];
    }

    override void update(float dt)
    {
        float hratio = cast(float) Actor.focus.health / cast(float) Actor.focus.healthmax;
        bar.size[0] = cast(int) (total * hratio); //TODO: crop instead of scaling
        bar.left = 10;
    }

    override void draw()
    {
        frame.draw();
        bar.draw();
    }
}
