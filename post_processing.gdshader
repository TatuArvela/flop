shader_type canvas_item;

uniform float darken = 0.0;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
    COLOR = textureLod(screen_texture, SCREEN_UV, 0.0);
	COLOR.r *= (1.0 - darken);
	COLOR.g *= (1.0 - darken);
	COLOR.b *= (1.0 - darken);
}
