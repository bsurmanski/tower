/**
 * font.d
 * tower
 * June 1, 2013
 * Brandon Surmanski
 */

module ui.font;

import gl.glb.glb;

class Font
{
    Texture textures[]; 

    this(string fontfile)
    {
        scope Texture font = Texture(0, fontfile);

        int i = 0;
        foreach(c; ' ' .. 'Z')
        {
            Texture texture = Texture(0, Texture.RGBA, 10, 10, 1, null);
            texture.copy(font, 0, 0, [0, i * 10, 0], [0, 0, 0], [10, 10, 1]);
            textures ~= texture;
            i++;
        }
    }
}
