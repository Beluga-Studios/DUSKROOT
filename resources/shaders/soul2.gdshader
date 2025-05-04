shader_type canvas_item;

uniform float time_speed = 1.0;
uniform float distortion_strength = 0.02;
uniform float flame_intensity = 1.5;
uniform vec2 flame_scale = vec2(4.0, 1.5);
uniform vec2 flow_direction = vec2(0.0, 1.0); // upward motion

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

    return mix(a, b, u.x) +
           (c - a)* u.y * (1.0 - u.x) +
           (d - b)* u.x * u.y;
}

void fragment() {
    vec2 uv = UV;
    float time = TIME * time_speed;

    // Sample base texture and modulate with vertex color
    vec4 base = texture(TEXTURE, uv) * COLOR;

    // Animated noise for flame flicker
    float base_noise = noise(uv * flame_scale + flow_direction * time * 0.8);
    float swirl = noise(uv * flame_scale * 0.5 + vec2(time * 0.5, -time * 0.2));
    float flame_shape = base_noise * (1.0 - uv.y);
    flame_shape = pow(flame_shape, 1.8);

    // Distort UV horizontally for flicker
    float offset = sin(uv.y * 10.0 + time * 3.0) * distortion_strength * swirl;
    uv.x += offset;

    float intensity = flame_shape * flame_intensity;
    float alpha = clamp(intensity, 0.0, 1.0);

    // Soft fade out near top
    alpha *= smoothstep(0.9, 0.0, uv.y);

    // Final color with ghost flame tint
    vec3 flame_tint = mix(vec3(0.2, 0.4, 1.0), vec3(0.6, 0.0, 1.0), pow(intensity, 1.5));
    vec3 final_color = base.rgb * flame_tint;

    COLOR = vec4(final_color, base.a * alpha);
}
