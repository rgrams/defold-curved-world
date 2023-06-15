varying highp vec4 var_position;
varying mediump vec3 var_normal;
varying mediump vec2 var_texcoord0;

uniform lowp sampler2D tex0;

void main() {
    vec4 color = texture2D(tex0, var_texcoord0.xy);
    if (color.a == 0.0) {
       discard;
    }
	 float normal_effect = 0.2;
	 vec3 lighting = vec3(1.0 - normal_effect + normal_effect*var_normal.y);
    gl_FragColor = vec4(color.rgb * lighting.rgb, 1.0);
}
