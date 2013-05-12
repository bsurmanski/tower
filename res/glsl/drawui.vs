#version 130

uniform mat4 tmat;

in vec3 position;

smooth out vec3 fnormal;
smooth out vec2 ftexCoord;

void main()
{
    gl_Position = tmat * vec4(position, 1.0f);
    fnormal = (tmat * vec4(0,0,1,0)).xyz;
    ftexCoord = 0.5f * position.xy + vec2(0.5f);
}
