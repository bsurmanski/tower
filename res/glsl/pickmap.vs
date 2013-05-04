#version 130

uniform mat4 tmat;

in vec3 position;
in vec3 normal;
in vec2 uv;
in float material;
in ivec2 tileId;

flat   out int fmaterial;
flat   out ivec2 ftileId;

void main()
{
    gl_Position = tmat * vec4(position, 1.0f);
    fmaterial = int(material);
    ftileId = tileId;
}
