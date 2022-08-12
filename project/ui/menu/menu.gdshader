shader_type canvas_item;


uniform float dist_factor = 64.0;
uniform vec2 uv_factor = vec2(1.0);

const float SS_THICKNESS = 0.009;
const float SS_SMOOTHING = 0.094;
float plot(float x, float y)
{
	return step(x, y - SS_THICKNESS) - step(x, y + SS_THICKNESS);
}
float smoothplot(float x, float y)
{
	return smoothstep(y - SS_THICKNESS, y - SS_THICKNESS - SS_SMOOTHING, x) -
		smoothstep(y + SS_THICKNESS + SS_SMOOTHING, y + SS_THICKNESS, x);
}

void fragment()
{
	vec2 pos = fract(UV * uv_factor) + vec2(
		sin(UV.x * dist_factor + TIME), cos(UV.y * dist_factor - TIME * 0.896)) * 0.1;
	COLOR = vec4(smoothplot(pos.x, pos.y) + smoothplot(1.0 - pos.y, pos.x));
}