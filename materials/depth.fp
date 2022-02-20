varying highp vec4 var_position;
uniform mediump vec4 light;

const float far = 100.;

vec4 float_to_rgba(float v)
{
    vec4 enc = vec4(1.0, 255.0, 65025.0, 16581375.0) * v;
    enc      = fract(enc);
    enc     -= enc.yzww * vec4(1.0/255.0,1.0/255.0,1.0/255.0,0.0);
    return enc;
}

void main()
{
    float d = length(var_position.xyz - light.xyz);
    //gl_FragColor = float_to_rgba(d / far);  //FORMAT_RGBA
    gl_FragColor = vec4(d); 
}

