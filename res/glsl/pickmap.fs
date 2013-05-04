#version 130

uniform sampler2DArray textures;

smooth in vec3 fnormal;
smooth in vec2 fuv;
flat in int fmaterial;
flat in ivec2 ftileId;

out ivec2 fragColor;

void main()
{
    fragColor = ftileId;
}
