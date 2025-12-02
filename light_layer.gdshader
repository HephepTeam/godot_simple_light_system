shader_type canvas_item;

uniform vec4 shadow_color : source_color ;

uniform vec3 light_zone_color : source_color;
uniform vec3 light_outline_color: source_color;

bool color_equality(vec3 col1, vec3 col2, float maxDiff){
	return ((abs(col1.r-col2.r) < maxDiff) &&
	(abs(col1.g-col2.g) < maxDiff) &&
	(abs(col1.b-col2.b) < maxDiff));
}

void fragment() {
	vec3 col = texture(TEXTURE, SCREEN_UV).rgb;
	if (color_equality(light_zone_color, col, 0.01)){
		COLOR.a = 0.0 ;
	}
	else if (color_equality(light_outline_color, col, 0.01)){
		COLOR.rgb = shadow_color.rgb;
		COLOR.a = 0.6 ;
	}
	else{
		COLOR = shadow_color;

	}
	
}


