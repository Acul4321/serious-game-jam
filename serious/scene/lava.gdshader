shader_type canvas_item;

uniform float scroll_speed : hint_range(0.0, 2.0) = 0.08;
uniform float angle_degrees : hint_range(0.0, 360.0) = 45.0;
uniform float repeat_x : hint_range(1.0, 20.0) = 20.0;
uniform float repeat_y : hint_range(1.0, 20.0) = 12.0;
uniform float row_offset : hint_range(0.0, 1.0) = 1.0;

uniform sampler2D texture_to_scroll : source_color;

void fragment() {
	float angle_rad = radians(angle_degrees);
	vec2 direction = vec2(cos(angle_rad), sin(angle_rad));

	vec2 offset_uv = UV - TIME * scroll_speed * direction;

	float row = floor(offset_uv.y * repeat_y);
	float offset = mod(row, 2.0) > 0.0 ? row_offset * 0.324 : 0.0;

	offset_uv.x += offset;

	vec2 scaled_uv = vec2(
		fract(offset_uv.x * repeat_x),
		fract(offset_uv.y * repeat_y)
	);

	vec2 texel_size = 1.0 / vec2(textureSize(texture_to_scroll, 0));
	vec2 snapped_uv = round(scaled_uv / texel_size) * texel_size;

	COLOR = texture(texture_to_scroll, snapped_uv);
}