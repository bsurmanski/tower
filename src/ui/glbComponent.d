
module ui.glbComponent;

import gl.glb.glb;
import ui.component;

abstract class GlbComponent : Component
{
    static Sampler _nearest_sampler;
    static Sampler _linear_sampler;
    static Program _program;
    static bool _init = false;

    this()
    {
        super();

        if(!_init)
        {
            _nearest_sampler = Sampler();
            _linear_sampler = Sampler();
            _program = Program();

            _nearest_sampler.setFilter(Sampler.NEAREST, Sampler.NEAREST);
            _linear_sampler.setFilter(Sampler.LINEAR, Sampler.LINEAR);

            _program = Program();
            _program.source("res/glsl/drawtexture.vs", Shader.VERTEX_SHADER);
            _program.source("res/glsl/drawtexture.fs", Shader.FRAGMENT_SHADER);
        }
    }
}
