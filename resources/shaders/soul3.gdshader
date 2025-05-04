shader_type canvas_item;

uniform float time_speed = 1.0;
uniform float overlay_strength = 0.6;
uniform float wave_strength = 0.02;
uniform vec2 flame_scale = vec2(3.0, 1.5);
uniform vec2 flow_direction = vec2(0.0, 1.0); // upward flame motion

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

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
           (c - a) * u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

// ghostly flame color
vec3 ghost_flame_color(float t) {
    return mix(vec3(0.2, 0.4, 1.0), vec3(0.6, 0.0, 1.0), pow(t, 1.5));
}

void fragment() {
    vec2 uv = UV;
    float time = TIME * time_speed;

    // Sample the base label or image
    vec4 base = texture(TEXTURE, uv) * COLOR;

    // Flickering flame noise
    float flame_noise = noise(uv * flame_scale + flow_direction * time * 0.8);
    float swirl = noise(uv * flame_scale * 0.4 + vec2(time * 0.5, -time * 0.2));
    float intensity = flame_noise * (1.0 - uv.y);
    intensity = pow(intensity, 2.0);

    // Ghost flame color
    vec3 overlay = ghost_flame_color(intensity);

    // Subtle wave distortion (optional)
    float offset = sin(uv.y * 8.0 + time * 4.0) * swirl * wave_strength;
    uv.x += offset;

    // Combine base with overlay flame
    vec3 final_rgb = mix(base.rgb, overlay, overlay_strength * intensity);

    COLOR = vec4(final_rgb, base.a);
}
