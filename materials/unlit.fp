varying mediump vec2 var_texcoord0;
varying mediump vec4 var_texcoord1;

varying mediump vec4 var_position;

uniform lowp sampler2D tex0;
uniform lowp sampler2D tex1;

uniform lowp vec4 tint;
uniform mediump vec4 light;

float rgba_to_float(vec4 rgba)
{
    return dot(rgba, vec4(1.0, 1.0/255.0, 1.0/65025.0, 1.0/16581375.0));
}


vec2 sample(vec3 v, out float face)
{
    vec3 vAbs = abs(v);
    float ma;
    vec2 uv;
    if (vAbs.z >= vAbs.x && vAbs.z >= vAbs.y) {
        face = v.z < 0.0 ? 5.0 : 4.0;
        ma = 0.5 / vAbs.z;
        uv = vec2(v.z < 0.0 ? -v.x : v.x, -v.y);
    }
    else if(vAbs.y >= vAbs.x) {
        face = v.y < 0.0 ? 3.0 : 2.0;
        ma = 0.5 / vAbs.y;
        uv = vec2(v.x, v.y < 0.0 ? -v.z : v.z);
    }
    else {
        face = v.x < 0.0 ? 1.0 : 0.0;
        ma = 0.5 / vAbs.x;
        uv = vec2(v.x < 0.0 ? v.z : -v.z, -v.y);
    }

    return uv * ma + 0.5;   
}

const float linear = 0.07;
const float quadratic = 0.017;

void main()
{
    vec4 color = texture2D(tex0, var_texcoord0.xy);

    vec3 dir = var_position.xyz - light.xyz; 
  
    float face;
    vec2 uv = sample(dir, face);

    if (face == 4.) { 
        uv.x += 1.;
    }else if (face == 1.) { 
        uv.x += 2.;
    }else if (face == 0.) { 
        uv.x += 3.;
    }else if (face == 2.) { 
        uv.y += 1.;
    }else if (face == 3.) { 
        uv.y += 1.;
        uv.x += 1.;
    }
    
    uv *= 0.25;
    
    float visibility = 1.;

    //float far = 100.;
    //float depth = rgba_to_float(texture2D(tex1, uv)) * far.; //FORMAT_RGBA

    float depth = texture2D(tex1, uv).x;
    const float depth_bias = 0.2;

    float distance = length(dir);
    float attenuation = 1.0; // / (1. + linear * distance + quadratic * (distance * distance));   

    

    if ((depth < distance - depth_bias) && ( depth > 0.1)) {
        visibility = 0.2;
    }
    
    gl_FragColor = vec4(color.xyz * attenuation * visibility, 1.);
}

