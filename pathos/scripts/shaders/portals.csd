CSD1   d015912c70ef45784476f64a6e80947a    %
     @      Y
  `   8  �  $  �  W      #version 130

uniform mat4 projection;
uniform mat4 modelview;

in vec4 in_position;

out vec3 ps_vertexpos;
out vec4 ps_screenpos;

void main()
{
	vec4 position = in_position*modelview;

	vec4 finalPosition = position*projection;
	gl_Position = finalPosition;
	ps_screenpos = finalPosition;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2DRect texture0;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float screenwidth;
uniform float screenheight;

in vec3 ps_vertexpos;
in vec4 ps_screenpos;

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
	vec2 ps_texcoord;
	ps_texcoord.x = ((ps_screenpos.x / ps_screenpos.w * 0.5) + 0.5) * screenwidth;
	ps_texcoord.y = ((ps_screenpos.y / ps_screenpos.w * 0.5) + 0.5) * screenheight;
	
	vec4 finalColor = texture(texture0, ps_texcoord);
	
	oColor = finalColor;
}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

in vec4 in_position;

out vec3 ps_vertexpos;
out vec4 ps_screenpos;

void main()
{
	vec4 position = in_position*modelview;

	ps_vertexpos = position.xyz;
	vec4 finalPosition = position*projection;
	gl_Position = finalPosition;
	ps_screenpos = finalPosition;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2DRect texture0;

uniform vec2 fogparams;
uniform vec3 fogcolor;
uniform float screenwidth;
uniform float screenheight;

in vec3 ps_vertexpos;
in vec4 ps_screenpos;

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
	vec2 ps_texcoord;
	ps_texcoord.x = ((ps_screenpos.x / ps_screenpos.w * 0.5) + 0.5) * screenwidth;
	ps_texcoord.y = ((ps_screenpos.y / ps_screenpos.w * 0.5) + 0.5) * screenheight;
	
	vec4 finalColor = texture(texture0, ps_texcoord);
	
	float fogcoord = length(ps_vertexpos);
		
		float fogfactor = (fogparams.x - fogcoord)*fogparams.y;
		fogfactor = 1.0-SplineFraction(clamp(fogfactor, 0.0, 1.0), 1.0);
		
		finalColor.xyz = mix(finalColor.xyz, fogcolor, fogfactor);
	oColor = finalColor;
}
fog                                U
            