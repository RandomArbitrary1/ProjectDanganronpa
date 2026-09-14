shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform float tint_strength : hint_range(0.0, 1.0, 0.01) = 0.0;
uniform vec4 tint_color : source_color = vec4(1.0, 0.8, 0.6, 1.0);

void fragment() {
    vec4 tex = texture(screen_texture, SCREEN_UV);
    vec3 color = tex.rgb;

    // Simple multiplicative tint
    vec3 tinted = color * tint_color.rgb;
    color = mix(color, tinted, tint_strength);

    COLOR = vec4(clamp(color, 0.0, 1.0), tex.a);
}