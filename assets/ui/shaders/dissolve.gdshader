shader_type canvas_item;

uniform float factor: hint_range(0.0, 1.0);
uniform sampler2D dissolve_map: filter_nearest;
void fragment() {
	vec4 colorA = vec4(0.0);
	vec4 colorB = vec4(0.0,0.0,0.0,1.0);
	vec4 map = texture(dissolve_map, UV);
	// adding 0.1 * (1. - factor) to compensate for pure black on dissolve map
	// not disappearing when factor is 0
	vec4 final_color = mix(colorA, colorB, step(map.r + 0.1 * (1. - factor), factor));
	COLOR = vec4(final_color.rgb * COLOR.rgb, final_color.a * COLOR.a);
}