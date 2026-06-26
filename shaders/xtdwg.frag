// Automatically converted with https://github.com/TheLeerName/ShadertoyToFlixel

#pragma header

#define iResolution vec3(openfl_TextureSize, 0.)
#define iChannel0 bitmap
#define texture flixel_texture2D

// end of ShadertoyToFlixel header

// =========================================================
//  Deuteranopia CORRECTION shader (Windows 10 style)
//  Daltonize method  shifts lost R-G info into blue channel
//
//  iChannel0 = your scene
// =========================================================


// How it works in one line:
//   simulate what deuteranope sees  diff = original - simulated
//    add diff into B channel (blue-yellow axis is intact)
//
// Pre-computed as a single mat3 (column-major for GLSL):
//
//  R_out =  1.0    * R  +  0.0    * G  +  0.0    * B
//  G_out =  0.0    * R  +  1.0    * G  +  0.0    * B
//  B_out =  0.079  * R  + (-0.468)* G  +  1.388  * B
//             red leak    green       orig B 
//
// The B row encodes the R-G difference that was invisible,
// making reds and greens distinguishable via blue-yellow axis.

mat3 correction = mat3(
//   col0 (RRGB)    col1 (GRGB)    col2 (BRGB)
    vec3(1.0,    0.0,    0.079),   // R input
    vec3(0.0,    1.0,   -0.468),   // G input
    vec3(0.0,    0.0,    1.388)    // B input
);

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;

    vec3 color    = texture(iChannel0, uv).rgb;
    vec3 original = color;

    color = clamp(correction * color, 0.0, 1.0);

    vec3 out_ = color;

    fragColor = vec4(out_, texture(iChannel0, fragCoord / iResolution.xy).a);
}

void main() {
	mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
}