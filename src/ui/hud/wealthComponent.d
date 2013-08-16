/**
 * wealthComponent.d
 * tower
 * May 11, 2013
 * Brandon Surmanski
 */

module ui.hud.wealthComponent;

import ui.component;
import ui.glbComponent;
import ui.imageComponent;

import scene.entity.actor;

class WealthComponent : GlbComponent
{
    Component icon;

    this()
    {
        super();

        icon = new ImageComponent("res/tex/coin.tga");
        icon.size[] *= 2;
        icon.bottom = 8;
        icon.left = 8;
    }

    override void draw()
    {
        icon.draw();
    }
}
