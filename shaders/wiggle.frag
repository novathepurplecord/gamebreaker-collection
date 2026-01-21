// Automatically converted with https://github.com/TheLeerName/ShadertoyToFlixel

#pragma header

#define iResolution vec3(openfl_TextureSize, 0.)
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D

// end of ShadertoyToFlixel header

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = fragCoord.xy / iResolution.xy;
    
    // ----- Options -----
    
    float intensity = 3.0;
    float strength = 0.01;
    float wavering = 8.0;
    float zoom = 1.2;
    
    // ----- Waving -----
    
    float y = 0.3 * sin((uv.y + iTime) * intensity) * (strength * 3.0);
    float x = 
        0.8 * sin((uv.y + iTime) * intensity) * strength + 
        0.1 * sin((uv.x + iTime) * wavering) * (strength * 3.0);
        
    vec2 offset = vec2(y, x);
    
    // ----- Output -----
    
    fragColor = texture(iChannel0, (uv + offset));
}

void main() {
	mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
}