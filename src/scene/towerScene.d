/**
 * towerScene.d
 * tower
 * July 07, 2013
 * Brandon Surmanski
 */

import gl.glb.glb;

import scene.scene;
import camera;

class TowerScene : Scene
{
    static bool _init;
    static Texture _shadow = void;
    static Sampler _sampler = void;

    this()
    {
        if(!_init)
        {
            _sampler = Sampler(); 
            _sampler.setFilter(Sampler.NEAREST, Sampler.NEAREST);
            _shadow = Texture(0, "res/tex/shadow.tga");
            _shadow.setSampler(&_sampler);
        }

        super();
    }

    this(string filenm)
    {
        this();
        super(filenm);
    }

    void drawShadow(Camera cam, ref Program program)
    {
        glDisable(GL_DEPTH_TEST);
        glDepthMask(false);

        Matrix4 mat; 
        mat.rotate(-PI / 2.0f, 1.0f, 0.0f, 0.0f);
        const(int) *texturesz = info._shadow.size();
        mat.scale(texturesz[0] / 32.0f, texturesz[1] / 32.0f, texturesz[1] / 32.0f);

        Vec3 pos = this.position;
        pos.y = 0;
        mat.translate(pos);

        mat = cast(Matrix4) cam.transformation * mat;
       
        program.uniform(Shader.VERTEX_SHADER, 0, (float[16]).sizeof, true, mat.ptr);
        program.texture(Shader.FRAGMENT_SHADER, 0, info._shadow);
        program.draw(Mesh.getUnitQuad().getVertexBuffer());

        glDepthMask(true);
        glEnable(GL_DEPTH_TEST);
    }
}
