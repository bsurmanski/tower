
module ui.imageComponent;

import gl.glb.glb;

import math.matrix;
import mesh;
import ui.component;
import ui.glbComponent;


class ImageComponent : GlbComponent
{
    Texture texture = void;

    this(string imagenm)
    {
        super(); 

        texture = Texture(0, imagenm);
        texture.setSampler(&_nearest_sampler);

        const int *texsize = texture.size();
        this.width = texsize[0];
        this.height = texsize[1];
    }

    override void draw()
    {
        Matrix4 mat; 

        mat.translate(1.0f, 1.0f, 0.0f);
        mat.scale(this.width / 2.0f, this.height / 2.0f, 1.0f);
        mat.translate(_position[0], _position[1], 0.0f);
        mat.scale( 2.0f / SCREEN_W, 2.0f / SCREEN_H, 1.0f);
        mat.translate(-1.0f, -1.0f, 0.0f);

        _program.uniform(Shader.VERTEX_SHADER, 0, (float[16]).sizeof, true, mat.ptr);
        _program.texture(Shader.FRAGMENT_SHADER, 0, texture);
        _program.draw(Mesh.getUnitQuad().getVertexBuffer());
    }
}
