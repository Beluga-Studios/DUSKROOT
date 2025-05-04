shader_type canvas_item;

uniform float time_speed = 1.0;
uniform float flame_intensity = 0.5;
uniform float distortion_strength = 0.03;
uniform vec2 flame_scale = vec2(5.0, 2.0); // Controls flame shape

float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898,78.233))) * 43758.5453);
}

float noise(vec2 p){
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = rand(i);
    float b = rand(i + vec2(1.0, 0.0));
    float c = rand(i + vec2(0.0, 1.0));
    float d = rand(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0 - 2.0*f);
    return mix(a, b, u.x) +
           (c - a)* u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

// Fire gradient function
vec3 fire_gradient(float t) {
    return mix(
        mix(vec3(0.0, 0.0, 0.0), vec3(1.0, 0.0, 0.0), clamp(t * 2.0, 0.0, 1.0)),
        mix(vec3(1.0, 0.0, 0.0), vec3(1.0, 1.0, 0.0), clamp((t - 0.5) * 2.0, 0.0, 1.0)),
        t
    );
}

void fragment() {
    vec2 uv = UV;
    float time = TIME * time_speed;

    // Distort UVs with moving noise to create flame flicker
    float n = noise(uv * flame_scale + vec2(0.0, time * 1.5));
    float offset = sin(uv.y * 10.0 + time * 5.0) * distortion_strength;
    uv.x += offset * n;

    // Flame shape: fade out at top, more intense at bottom
    float flame = noise(uv * flame_scale + vec2(0.0, time * 0.8));
    flame *= 1.0 - uv.y; // taper off upward
    flame = pow(flame, 1.8) * flame_intensity;

    // Color
    vec3 color = fire_gradient(flame);
    COLOR = vec4(color, flame);
}
