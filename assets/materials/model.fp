varying highp vec4 var_position;
varying highp vec4 screen_pos;
varying mediump vec3 var_normal;
varying mediump vec2 var_texcoord0;

uniform lowp sampler2D tex0;

void main() {
    vec4 color = texture2D(tex0, var_texcoord0.xy);

    if (color.a == 0.0) {
       discard;
    }

    float ambient_part = 0.8;
    
    vec3 diffuse = vec3(1.0 - ambient_part);
    diffuse = vec3(ambient_part) + diffuse * vec3(var_normal.y);

    vec4 final = vec4(color.rgb * diffuse.rgb, 1.0);
    // final.r = screen_pos.x;
    // final.rgb = vec3((screen_pos.z + 1.0)/20);
    gl_FragColor = final;
}