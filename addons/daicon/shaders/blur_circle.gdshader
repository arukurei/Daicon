shader_type canvas_item;

const int MAX_POSITIONS = 100;

uniform vec2 CircleCentres[MAX_POSITIONS];
uniform int NumCircleCentres : hint_range(0, 100, 1) = 0;
uniform float CircleRadius = 100.0;
uniform float CircleBlur : hint_range(0.0, 1.0, 0.01) = 0.4; // Дефолт 0.4 (40% блюра)

void fragment()
{
	float circle_signal = 0.0;
	
	// Внутренний радиус, где круг 100% прозрачный:
	float inner_radius = CircleRadius * (1.0 - clamp(CircleBlur, 0.0, 1.0));
	
	for (int i = 0; i < NumCircleCentres; ++i)
	{
		float circle_dist = distance(CircleCentres[i], FRAGCOORD.xy);
		
		// Плавный переход от полной прозрачности (inner) до непрозрачности (outer)
		float mask = 1.0 - smoothstep(inner_radius, CircleRadius, circle_dist);
		circle_signal = max(circle_signal, mask);
	}
	
	vec4 tex_color = texture(TEXTURE, UV);
	COLOR = tex_color;
	COLOR.a *= (1.0 - circle_signal);
}