shader_type canvas_item;

uniform float time_speed = 1.0;
uniform float glitch_intensity = 0.02;
uniform float scanline_intensity = 0.1;

void fragment() {
    vec2 uv = UV;

    // Time-based flicker
    float time = TIME * time_speed;

    // Horizontal glitch offset
    float glitch = sin(uv.y * 120.0 + time * 20.0) * glitch_intensity;

    // Scanline darkness
    float scanline = sin(uv.y * 300.0 + time * 10.0) * scanline_intensity;

    // Final color
    COLOR = texture(TEXTURE, uv + vec2(glitch, 0.0));
    COLOR.rgb -= scanline;
}
