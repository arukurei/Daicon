shader_type canvas_item;

// needs to match the number of values being sent
const int MAX_POSITIONS = 100;

uniform vec2 CircleCentres[MAX_POSITIONS];
uniform int NumCircleCentres : hint_range(0, 100, 1) = 0;
uniform float CircleRadius = 75.0;
uniform float CircleBlur : hint_range(0.0, 1.0, 0.01) = 0.01;

void fragment()
{
	float circle_signal = 0.0;
	// loop over possible centres
	for ( int i = 0; i < NumCircleCentres; ++i )
	{
	// compute distance between fragment and circle centre
	float circle_dist = distance( CircleCentres[i], FRAGCOORD.xy );
	// compute signal based on circle radius
	circle_signal = max( circle_signal, smoothstep( CircleRadius, CircleRadius*(1.0-CircleBlur), circle_dist ) );
	}
	// read the base texture color
	vec4 tex_color = texture( TEXTURE, UV );
	// set output color to the read texture value
	COLOR = tex_color;
	// now modify the alpha by the circle
	COLOR.a *= ( 1.0 - circle_signal );
}