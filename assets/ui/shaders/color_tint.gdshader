shader_type canvas_item;

uniform sampler2D screen_tex : hint_screen_texture, filter_linear_mipmap;
uniform vec4 tint_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform float opacity : hint_range(0.0, 1.0) = 0.1;
uniform float saturation : hint_range(0.0, 2.0) = 1.0;

void fragment() {
	vec3 color = texture(screen_tex, SCREEN_UV).rgb;
	float gray = dot(color, vec3(0.299, 0.587, 0.114));
	color = mix(vec3(gray), color, saturation);
	color = mix(color, color * tint_color.rgb, 1.0);
	COLOR = vec4(color, opacity);
}