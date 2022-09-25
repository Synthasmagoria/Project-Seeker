shader_type canvas_item;

uniform vec4 outline_color : hint_color;
uniform vec4 modulate : hint_color;

float cartesian_to_angle(vec2 st)
{
	return atan(st.y, st.x);
}

void fragment()
{
	vec4 up = texture(TEXTURE, UV + vec2(0.0, -TEXTURE_PIXEL_SIZE.y));
	vec4 left = texture(TEXTURE, UV + vec2(-TEXTURE_PIXEL_SIZE.x, 0.0));
	vec4 down = texture(TEXTURE, UV + vec2(0.0, TEXTURE_PIXEL_SIZE.y));
	vec4 right = texture(TEXTURE, UV + vec2(TEXTURE_PIXEL_SIZE.x, 0.0));
	vec4 pixel = texture(TEXTURE, UV);
	
	float a = float(up.a < pixel.a) + float(left.a < pixel.a) + float(down.a < pixel.a) + float(right.a < pixel.a);
	a = min(a, 1.0);
	
	float ang = cartesian_to_angle(UV - 0.5);
	float yes = step(mod(ang + TIME, 1.5), 1.0);
	
	COLOR = pixel * modulate * (1.0 - a) + a * outline_color * yes;
}