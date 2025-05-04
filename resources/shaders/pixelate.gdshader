shader_type canvas_item;

void fragment() {
    COLOR = texture(TEXTURE, UV); // No pixelation or alpha tweak
}
