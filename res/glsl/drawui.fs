#version 130

uniform sampler2D tex0;

smooth in vec3 fnormal;
smooth in vec2 ftexCoord;

out vec4 fragColor;
out vec4 fragNormal;

void main()
{
    vec4 color = texture(tex0, ftexCoord); 

    if(color.a < 0.05) discard;

    fragColor = color;
    fragNormal = vec4(fnormal, 1.0f);
}

