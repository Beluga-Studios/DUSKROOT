shader_type canvas_item;

uniform float time_speed = 1.0;
uniform float overlay_strength = 0.6;
uniform float wave_strength = 0.02;
uniform vec2 flame_scale = vec2(3.0, 1.5);
uniform vec2 flow_direction = vec2(0.0, 1.0); // upward motion

// Simple noise functions
float rand(vec2 co) {
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = rand(i);
    float b = rand(i + vec2(1.0, 0.0));
    float c = rand(i + vec2(0.0, 1.0));
    float d = rand(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)*u.y*(1.0 - u.x) + (d - b)*u.x*u.y;
}

// Converts HSV to RGB (for animated color cycling)
vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0/3.0, 1.0/3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void fragment() {
    vec2 uv = UV;
    float time = TIME * time_speed;

    // Base text or label image
    vec4 base = texture(TEXTURE, uv) * COLOR;

    // Flame shape
    float flame_noise = noise(uv * flame_scale + flow_direction * time * 0.8);
    float swirl = noise(uv * flame_scale * 0.4 + vec2(time * 0.5, -time * 0.2));
    float intensity = flame_noise * (1.0 - uv.y);
    intensity = pow(intensity, 2.0);

    // Distortion
    float offset = sin(uv.y * 8.0 + time * 4.0) * swirl * wave_strength;
    uv.x += offset;

    // Hue shift for multicolor glow
    float hue = mod(time * 0.1 + uv.y * 1.5 + swirl * 0.5, 1.0);
    vec3 flame_rgb = hsv2rgb(vec3(hue, 1.0, 1.0));

    // Mix flame with base
    vec3 final_color = mix(base.rgb, flame_rgb, overlay_strength * intensity);

    COLOR = vec4(final_color, base.a);
}
