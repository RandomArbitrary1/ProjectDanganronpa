shader_type canvas_item;

uniform float distort_amount : hint_range(-2.0, 2.0) = 0.0;
uniform vec2 vanish_point = vec2(0.0, 0.0); // top-left in UV space (0-1)

void fragment() {
	vec2 dir = UV - vanish_point;
	
	// Perspective-divide-style warp: pulls/pushes UVs relative to distance from vanish point
	float depth = 1.0 + distort_amount * (dir.x + dir.y);
	vec2 distorted_uv = vanish_point + dir / depth;
	
	// Clamp so we don't sample garbage outside the texture and get streaking/black edges
	if (distorted_uv.x < 0.0 || distorted_uv.x > 1.0 || distorted_uv.y < 0.0 || distorted_uv.y > 1.0) {
		COLOR = vec4(0.0);
	} else {
		COLOR = texture(TEXTURE, distorted_uv);
	}
}