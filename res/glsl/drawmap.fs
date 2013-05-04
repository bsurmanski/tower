#version 130

uniform sampler2DArray textures;

smooth in vec3 fnormal;
smooth in vec2 fuv;
flat in int fmaterial;
flat in ivec2 fid;

out vec4 fragColor;
out vec4 fragNormal;

void main()
{
    vec4 color = texture(textures, vec3(fuv, float(fmaterial)));

    // darken odd squares
    if(mod(fid[0] + fid[1], 2) == 1)
    {
        color -= vec4(0.075f, 0.075f, 0.075f, 0.0f);  
    }

    fragColor = color;
    fragNormal = vec4(normalize(fnormal), 1.0f);
}
