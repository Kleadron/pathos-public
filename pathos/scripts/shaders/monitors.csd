CSD1   f3c13001de99ed157029b4637119168f    �     @         �   &  �  �  Z  &  �  �  	  E  P
  �  �  E  7  y  #version 130

uniform mat4 projection;
uniform mat4 modelview;

in vec4 in_position;
in vec2 in_texcoord;

out vec2 ps_texcoord;
out vec3 ps_vertexpos;

void main()
{
	ps_texcoord = in_texcoord;

	vec4 position = in_position*modelview;

	gl_Position = position*projection;
}
#version 130

uniform sampler2D texture0;
uniform sampler2D scantexture;

uniform vec2 fogparams;
uniform vec3 fogcolor;

in vec2 ps_texcoord;
in vec3 ps_vertexpos;

out vec4 oColor;

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 texColor = texture(texture0, ps_texcoord);
	vec4 finalColor = texColor;
	vec4 scanColor = texture(scantexture, ps_texcoord);
	finalColor.xyz = mix(finalColor.xyz, scanColor.xyz, scanColor.w);
	
	oColor = finalColor;
}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

in vec4 in_position;
in vec2 in_texcoord;

out vec2 ps_texcoord;
out vec3 ps_vertexpos;

void main()
{
	ps_texcoord = in_texcoord;

	vec4 position = in_position*modelview;

	gl_Position = position*projection;
}
#version 130

uniform sampler2D texture0;
uniform sampler2D scantexture;

uniform vec2 fogparams;
uniform vec3 fogcolor;

in vec2 ps_texcoord;
in vec3 ps_vertexpos;

out vec4 oColor;

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 texColor = texture(texture0, ps_texcoord);
	vec3 weights = vec3(0.320000, 0.590000, 0.090000);
		
		vec4 finalColor;
		finalColor.x = dot(texColor.xyz, weights);
		finalColor.y = dot(texColor.xyz, weights);
		finalColor.z = dot(texColor.xyz, weights);
		finalColor.w = texColor.w;
	vec4 scanColor = texture(scantexture, ps_texcoord);
	finalColor.xyz = mix(finalColor.xyz, scanColor.xyz, scanColor.w);
	
	oColor = finalColor;
}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

in vec4 in_position;
in vec2 in_texcoord;

out vec2 ps_texcoord;
out vec3 ps_vertexpos;

void main()
{
	ps_texcoord = in_texcoord;

	vec4 position = in_position*modelview;

	ps_vertexpos = position.xyz;
	gl_Position = position*projection;
}
#version 130

uniform sampler2D texture0;
uniform sampler2D scantexture;

uniform vec2 fogparams;
uniform vec3 fogcolor;

in vec2 ps_texcoord;
in vec3 ps_vertexpos;

out vec4 oColor;

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 texColor = texture(texture0, ps_texcoord);
	vec4 finalColor = texColor;
	vec4 scanColor = texture(scantexture, ps_texcoord);
	finalColor.xyz = mix(finalColor.xyz, scanColor.xyz, scanColor.w);
	
	float fogcoord = length(ps_vertexpos);
		
		float fogfactor = (fogparams.x - fogcoord)*fogparams.y;
		fogfactor = 1.0-SplineFraction(clamp(fogfactor, 0.0, 1.0), 1.0);
		
		finalColor.xyz = mix(finalColor.xyz, fogcolor, fogfactor);
	oColor = finalColor;
}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

in vec4 in_position;
in vec2 in_texcoord;

out vec2 ps_texcoord;
out vec3 ps_vertexpos;

void main()
{
	ps_texcoord = in_texcoord;

	vec4 position = in_position*modelview;

	ps_vertexpos = position.xyz;
	gl_Position = position*projection;
}
#version 130

uniform sampler2D texture0;
uniform sampler2D scantexture;

uniform vec2 fogparams;
uniform vec3 fogcolor;

in vec2 ps_texcoord;
in vec3 ps_vertexpos;

out vec4 oColor;

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}

void main()
{
	vec4 texColor = texture(texture0, ps_texcoord);
	vec3 weights = vec3(0.320000, 0.590000, 0.090000);
		
		vec4 finalColor;
		finalColor.x = dot(texColor.xyz, weights);
		finalColor.y = dot(texColor.xyz, weights);
		finalColor.z = dot(texColor.xyz, weights);
		finalColor.w = texColor.w;
	vec4 scanColor = texture(scantexture, ps_texcoord);
	finalColor.xyz = mix(finalColor.xyz, scanColor.xyz, scanColor.w);
	
	float fogcoord = length(ps_vertexpos);
		
		float fogfactor = (fogparams.x - fogcoord)*fogparams.y;
		fogfactor = 1.0-SplineFraction(clamp(fogfactor, 0.0, 1.0), 1.0);
		
		finalColor.xyz = mix(finalColor.xyz, fogcolor, fogfactor);
	oColor = finalColor;
}
fog                                         grayscale                                               