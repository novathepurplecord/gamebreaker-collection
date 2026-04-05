#pragma header

uniform float intensity;

void main() {
    vec2 uv = openfl_TextureCoordv;
    vec4 tex = flixel_texture2D(bitmap, uv);

    vec3 correction = vec3(tex.r, tex.g * 0.8 + tex.r * 0.2, tex.b);

    tex.rgb = mix(tex.rgb, correction, intensity);

    gl_FragColor = tex;
}