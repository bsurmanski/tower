#version 130

uniform mat4 tmat;
uniform mat4 dtmat; //used for depth calculations

in vec3 position;

smooth out vec3 fnormal;
smooth out vec2 ftexCoord;
smooth out float f_depth;

void main()
{
    gl_Position = tmat * vec4(position, 1.0f);
    fnormal = (tmat * vec4(0,0,1,0)).xyz;
    ftexCoord = 0.5f * position.xy + vec2(0.5f);

    vec4 dpos = dtmat * vec4(position, 1.0f);
    f_depth = dpos.z / dpos.w; //w divide
    //f_depth = gl_Position.z / gl_Position.w;// / gl_Position.w;// / gl_Position.w; //w divide
}
