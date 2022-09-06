shader_type canvas_item;

float detect_edge(sampler2D tex, vec2 uv, vec2 px_size, float thresh)
{
	vec4 sample = texture(tex, uv);
	vec4 right = texture(tex, uv + vec2(px_size.x, 0.0));
	vec4 up = texture(tex, uv + vec2(0.0, -px_size.y));
	vec4 left = texture(tex, uv + vec2(-px_size.x, 0.0));
	vec4 down = texture(tex, uv + vec2(0.0, px_size.y));
	return step(thresh,
		distance(right.rgb, sample.rgb) +
		distance(up.rgb, sample.rgb) +
		distance(left.rgb, sample.rgb) +
		distance(down.rgb, sample.rgb));
}

uniform vec4 fill_color : hint_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 edge_color : hint_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform float edge_threshold : hint_range(0.0, 4.0) = 0.5;
uniform vec4 inside_edge_color : hint_color = vec4(0.75, 0.0, 0.0, 1.0);
uniform float inside_edge_threshold : hint_range(0.0, 4.0) = 0.2;

void fragment()
{
	vec4 img = texture(TEXTURE, UV);
	float edge = detect_edge(TEXTURE, UV, TEXTURE_PIXEL_SIZE, edge_threshold);
	float inside_edge = detect_edge(SCREEN_TEXTURE, SCREEN_UV, SCREEN_PIXEL_SIZE, inside_edge_threshold);
	
	vec4 scn = texture(TEXTURE, UV);
	float a = step(0.5, scn.a);
	COLOR = edge * edge_color + fill_color * img.a + inside_edge * inside_edge_color * img.a;
}