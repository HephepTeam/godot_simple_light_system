shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
uniform vec4 black_point : source_color = vec4(0.0);

vec4 set_black_point(vec4 color) {
	float bp_avg = black_point.r + black_point.g + black_point.b;
	float color_avg = color.r + color.g + color.b;

	if (color_avg < bp_avg) {
		return black_point;
	} else {
		return color;
	}
}


void fragment() {
	vec4 col = texture(screen_texture, SCREEN_UV);
	COLOR = set_black_point(col);
}


