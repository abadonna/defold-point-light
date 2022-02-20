varying mediump vec2 var_texcoord0;

uniform highp sampler2D tex0;

float rgba_to_float(vec4 rgba)
{
	return dot(rgba, vec4(1.0, 1.0/255.0, 1.0/65025.0, 1.0/16581375.0));
}


void main()
{
	//gl_FragColor = vec4(vec3(10.*rgba_to_float(texture2D(tex0,var_texcoord0))), 1.);
	gl_FragColor = vec4(vec3(texture2D(tex0,var_texcoord0).x * 0.1), 1.);
}