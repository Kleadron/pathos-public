CSD1   2eafda7c55ad65ed57fb5a0002dea000    �    @      � @  �  �  ,  "  �  �  P  (  �  �  (	  !  �  �#  L	  -  �  �/    �7  �  �:  >  �B  �  �E  
  �O  �  NR  :
  �\  �  5`  S  �r  �  5v  w  ��  �  Y�  �  X�  �  �  #  (�  �  ջ  A  �  �  ��  e  (�  �  ��  �  ��  �  o   #version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 normalmatrix_v;

uniform float texscale;

in vec4 in_position;
in vec2 in_texcoords;
in vec2 in_lightcoords;
in vec3 in_tangent;
in vec3 in_binormal;
in vec3 in_normal;

out vec4 ps_screencoords;
out vec3 ps_eyecoords;
out vec2 ps_texcoords;
out vec2 ps_lightcoords;

void main()
{
	vec4 position = in_position*modelview;
	vec4 eye_position = position*projection;

	ps_screencoords = eye_position;
	ps_eyecoords = position.xyz;

	ps_texcoords.x = in_texcoords.x*texscale;
	ps_texcoords.y = in_texcoords.y*texscale;
	
	ps_lightcoords = in_lightcoords;
	gl_Position = eye_position;
}
#version 130

uniform sampler2D normalMap;
uniform sampler2D lightMap;
uniform sampler2D refractMap;
uniform sampler2D reflectMap;
uniform sampler2DRect rectangleRefractMap;
uniform sampler2D diffuseMap;
uniform sampler2D lightvecsMap;

uniform mat4 normalmatrix;

uniform vec3 fogcolor;
uniform vec2 fogparams;

uniform float fresnel;
uniform float time;
uniform float strength;
uniform float lightstrength;
uniform float specularstrength;
uniform float phongexponent;

uniform vec2 scroll;
uniform vec2 rectscale;

in vec4 ps_screencoords;
in vec3 ps_eyecoords;
in vec2 ps_texcoords;
in vec2 ps_lightcoords;

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
	vec4 finalColor;

	vec2 texcoord = ps_texcoords + scroll;

	vec2 texc0 = vec2(texcoord.x+time*0.20, texcoord.y+time*0.15);
	vec2 texc1 = vec2(texcoord.x-time*0.13, texcoord.y+time*0.11);

	vec4 norm1 = texture(normalMap, texc0);
	vec4 norm2 = texture(normalMap, texc1);

	vec2 texc2 = vec2(texcoord.x+time*0.17, texcoord.y+time*0.15);
	vec2 texc3 = vec2(texcoord.x-time*0.14, texcoord.y-time*0.16);

	vec4 norm3 = texture(normalMap, texc2);
	vec4 norm4 = texture(normalMap, texc3);	

	vec3 norm_combine = normalize((norm1*0.25 + norm2*0.25 + norm3*0.25 + norm4*0.25).xyz * 2.0 - 1.0);

	vec2 coordUV1 = (ps_screencoords.xy / (2*ps_screencoords.w) ) + 0.5 + norm_combine.xy*0.1*strength;
		vec4 refractcolor = texture(refractMap, coordUV1);
		vec4 lightmapcolor = texture(lightMap, ps_lightcoords);
		finalColor = refractcolor + lightmapcolor * lightstrength;
		
		oColor = finalColor;
}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 normalmatrix_v;

uniform float texscale;

in vec4 in_position;
in vec2 in_texcoords;
in vec2 in_lightcoords;
in vec3 in_tangent;
in vec3 in_binormal;
in vec3 in_normal;

out vec4 ps_screencoords;
out vec3 ps_eyecoords;
out vec2 ps_texcoords;
out vec2 ps_lightcoords;

void main()
{
	vec4 position = in_position*modelview;
	vec4 eye_position = position*projection;

	ps_screencoords = eye_position;
	ps_eyecoords = position.xyz;

	ps_texcoords.x = in_texcoords.x*texscale;
	ps_texcoords.y = in_texcoords.y*texscale;
	
	ps_lightcoords = in_lightcoords;
	gl_Position = eye_position;
}
#version 130

uniform sampler2D normalMap;
uniform sampler2D lightMap;
uniform sampler2D refractMap;
uniform sampler2D reflectMap;
uniform sampler2DRect rectangleRefractMap;
uniform sampler2D diffuseMap;
uniform sampler2D lightvecsMap;

uniform mat4 normalmatrix;

uniform vec3 fogcolor;
uniform vec2 fogparams;

uniform float fresnel;
uniform float time;
uniform float strength;
uniform float lightstrength;
uniform float specularstrength;
uniform float phongexponent;

uniform vec2 scroll;
uniform vec2 rectscale;

in vec4 ps_screencoords;
in vec3 ps_eyecoords;
in vec2 ps_texcoords;
in vec2 ps_lightcoords;

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
	vec4 finalColor;

	vec2 texcoord = ps_texcoords + scroll;

	vec2 texc0 = vec2(texcoord.x+time*0.20, texcoord.y+time*0.15);
	vec2 texc1 = vec2(texcoord.x-time*0.13, texcoord.y+time*0.11);

	vec4 norm1 = texture(normalMap, texc0);
	vec4 norm2 = texture(normalMap, texc1);

	vec2 texc2 = vec2(texcoord.x+time*0.17, texcoord.y+time*0.15);
	vec2 texc3 = vec2(texcoord.x-time*0.14, texcoord.y-time*0.16);

	vec4 norm3 = texture(normalMap, texc2);
	vec4 norm4 = texture(normalMap, texc3);	

	vec3 norm_combine = normalize((norm1*0.25 + norm2*0.25 + norm3*0.25 + norm4*0.25).xyz * 2.0 - 1.0);

	vec2 coordUV1 = (ps_screencoords.xy / (2*ps_screencoords.w) ) + 0.5 + norm_combine.xy*0.1*strength;
		coordUV1 *= rectscale;
			vec4 refractcolor = texture(rectangleRefractMap, coordUV1);
		vec4 lightmapcolor = texture(lightMap, ps_lightcoords);
		finalColor = refractcolor + lightmapcolor * lightstrength;
		
		oColor = finalColor;
}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 normalmatrix_v;

uniform float texscale;

in vec4 in_position;
in vec2 in_texcoords;
in vec2 in_lightcoords;
in vec3 in_tangent;
in vec3 in_binormal;
in vec3 in_normal;

out vec4 ps_screencoords;
out vec3 ps_eyecoords;
out vec2 ps_texcoords;
out vec2 ps_lightcoords;

void main()
{
	vec4 position = in_position*modelview;
	vec4 eye_position = position*projection;

	ps_screencoords = eye_position;
	ps_eyecoords = position.xyz;

	ps_texcoords.x = in_texcoords.x*texscale;
	ps_texcoords.y = in_texcoords.y*texscale;
	
	ps_lightcoords = in_lightcoords;
	gl_Position = eye_position;
}
#version 130

uniform sampler2D normalMap;
uniform sampler2D lightMap;
uniform sampler2D refractMap;
uniform sampler2D reflectMap;
uniform sampler2DRect rectangleRefractMap;
uniform sampler2D diffuseMap;
uniform sampler2D lightvecsMap;

uniform mat4 normalmatrix;

uniform vec3 fogcolor;
uniform vec2 fogparams;

uniform float fresnel;
uniform float time;
uniform float strength;
uniform float lightstrength;
uniform float specularstrength;
uniform float phongexponent;

uniform vec2 scroll;
uniform vec2 rectscale;

in vec4 ps_screencoords;
in vec3 ps_eyecoords;
in vec2 ps_texcoords;
in vec2 ps_lightcoords;

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
	vec4 finalColor;

	vec2 texcoord = ps_texcoords + scroll;

	vec2 texc0 = vec2(texcoord.x+time*0.20, texcoord.y+time*0.15);
	vec2 texc1 = vec2(texcoord.x-time*0.13, texcoord.y+time*0.11);

	vec4 norm1 = texture(normalMap, texc0);
	vec4 norm2 = texture(normalMap, texc1);

	vec2 texc2 = vec2(texcoord.x+time*0.17, texcoord.y+time*0.15);
	vec2 texc3 = vec2(texcoord.x-time*0.14, texcoord.y-time*0.16);

	vec4 norm3 = texture(normalMap, texc2);
	vec4 norm4 = texture(normalMap, texc3);	

	vec3 norm_combine = normalize((norm1*0.25 + norm2*0.25 + norm3*0.25 + norm4*0.25).xyz * 2.0 - 1.0);

	vec2 coordUV1 = (ps_screencoords.xy / (2*ps_screencoords.w) ) + 0.5 + norm_combine.xy*0.1*strength;
		vec4 refractcolor = texture(refractMap, coordUV1);
		vec2 coordUV2 = (vec2(ps_screencoords.x, -ps_screencoords.y) / (2*ps_screencoords.w) ) + 0.5 + norm_combine.xy*0.1*strength;
		vec4 reflectcolor = texture(reflectMap, coordUV2);

		vec3 vnormal_texture = normalize((normalmatrix*vec4(norm_combine, 0)).xyz);
		vec3 vnormal = normalize((normalmatrix*vec4(0, 0, 1, 0)).xyz);
		
		float fresnelterm = clamp(dot(-normalize(ps_eyecoords), vnormal_texture)*1.3*fresnel, 0.0, 0.97 );
		vec4 combinedColor = mix(reflectcolor, refractcolor, fresnelterm);

		vec4 lightmapcolor = texture(lightMap, ps_lightcoords);
		finalColor = combinedColor + lightmapcolor * lightstrength;
		
		oColor = finalColor;
}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 normalmatrix_v;

uniform float texscale;

in vec4 in_position;
in vec2 in_texcoords;
in vec2 in_lightcoords;
in vec3 in_tangent;
in vec3 in_binormal;
in vec3 in_normal;

out vec4 ps_screencoords;
out vec3 ps_eyecoords;
out vec2 ps_texcoords;
out vec2 ps_lightcoords;

void main()
{
	vec4 position = in_position*modelview;
	vec4 eye_position = position*projection;

	ps_screencoords = eye_position;
	ps_eyecoords = position.xyz;

	ps_texcoords.x = in_texcoords.x*texscale;
	ps_texcoords.y = in_texcoords.y*texscale;
	
	ps_lightcoords = in_lightcoords;
	gl_Position = eye_position;
}
#version 130

uniform sampler2D normalMap;
uniform sampler2D lightMap;
uniform sampler2D refractMap;
uniform sampler2D reflectMap;
uniform sampler2DRect rectangleRefractMap;
uniform sampler2D diffuseMap;
uniform sampler2D lightvecsMap;

uniform mat4 normalmatrix;

uniform vec3 fogcolor;
uniform vec2 fogparams;

uniform float fresnel;
uniform float time;
uniform float strength;
uniform float lightstrength;
uniform float specularstrength;
uniform float phongexponent;

uniform vec2 scroll;
uniform vec2 rectscale;

in vec4 ps_screencoords;
in vec3 ps_eyecoords;
in vec2 ps_texcoords;
in vec2 ps_lightcoords;

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
	vec4 finalColor;

	vec2 texcoord = ps_texcoords + scroll;

	vec2 texc0 = vec2(texcoord.x+time*0.20, texcoord.y+time*0.15);
	vec2 texc1 = vec2(texcoord.x-time*0.13, texcoord.y+time*0.11);

	vec4 norm1 = texture(normalMap, texc0);
	vec4 norm2 = texture(normalMap, texc1);

	vec2 texc2 = vec2(texcoord.x+time*0.17, texcoord.y+time*0.15);
	vec2 texc3 = vec2(texcoord.x-time*0.14, texcoord.y-time*0.16);

	vec4 norm3 = texture(normalMap, texc2);
	vec4 norm4 = texture(normalMap, texc3);	

	vec3 norm_combine = normalize((norm1*0.25 + norm2*0.25 + norm3*0.25 + norm4*0.25).xyz * 2.0 - 1.0);

	vec2 coordUV1 = (ps_screencoords.xy / (2*ps_screencoords.w) ) + 0.5 + norm_combine.xy*0.1*strength;
		coordUV1 *= rectscale;
			vec4 refractcolor = texture(rectangleRefractMap, coordUV1);
		vec2 coordUV2 = (vec2(ps_screencoords.x, -ps_screencoords.y) / (2*ps_screencoords.w) ) + 0.5 + norm_combine.xy*0.1*strength;
		vec4 reflectcolor = texture(reflectMap, coordUV2);

		vec3 vnormal_texture = normalize((normalmatrix*vec4(norm_combine, 0)).xyz);
		vec3 vnormal = normalize((normalmatrix*vec4(0, 0, 1, 0)).xyz);
		
		float fresnelterm = clamp(dot(-normalize(ps_eyecoords), vnormal_texture)*1.3*fresnel, 0.0, 0.97 );
		vec4 combinedColor = mix(reflectcolor, refractcolor, fresnelterm);

		vec4 lightmapcolor = texture(lightMap, ps_lightcoords);
		finalColor = combinedColor + lightmapcolor * lightstrength;
		
		oColor = finalColor;
}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 normalmatrix_v;

uniform float texscale;

in vec4 in_position;
in vec2 in_texcoords;
in vec2 in_lightcoords;
in vec3 in_tangent;
in vec3 in_binormal;
in vec3 in_normal;

out vec4 ps_screencoords;
out vec3 ps_eyecoords;
out vec2 ps_texcoords;
out vec2 ps_lightcoords;

void main()
{
	vec4 position = in_position*modelview;
	vec4 eye_position = position*projection;

	ps_screencoords = eye_position;
	ps_eyecoords = position.xyz;

	ps_texcoords.x = in_texcoords.x*texscale;
	ps_texcoords.y = in_texcoords.y*texscale;
	
	ps_lightcoords = in_lightcoords;
	gl_Position = eye_position;
}
#version 130

uniform sampler2D normalMap;
uniform sampler2D lightMap;
uniform sampler2D refractMap;
uniform sampler2D reflectMap;
uniform sampler2DRect rectangleRefractMap;
uniform sampler2D diffuseMap;
uniform sampler2D lightvecsMap;

uniform mat4 normalmatrix;

uniform vec3 fogcolor;
uniform vec2 fogparams;

uniform float fresnel;
uniform float time;
uniform float strength;
uniform float lightstrength;
uniform float specularstrength;
uniform float phongexponent;

uniform vec2 scroll;
uniform vec2 rectscale;

in vec4 ps_screencoords;
in vec3 ps_eyecoords;
in vec2 ps_texcoords;
in vec2 ps_lightcoords;

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
	vec4 finalColor;

	vec2 texcoord = ps_texcoords + scroll;

	vec2 texc0 = vec2(texcoord.x+time*0.20, texcoord.y+time*0.15);
	vec2 texc1 = vec2(texcoord.x-time*0.13, texcoord.y+time*0.11);

	vec4 norm1 = texture(normalMap, texc0);
	vec4 norm2 = texture(normalMap, texc1);

	vec2 texc2 = vec2(texcoord.x+time*0.17, texcoord.y+time*0.15);
	vec2 texc3 = vec2(texcoord.x-time*0.14, texcoord.y-time*0.16);

	vec4 norm3 = texture(normalMap, texc2);
	vec4 norm4 = texture(normalMap, texc3);	

	vec3 norm_combine = normalize((norm1*0.25 + norm2*0.25 + norm3*0.25 + norm4*0.25).xyz * 2.0 - 1.0);

	vec2 coordUV1 = (ps_screencoords.xy / (2*ps_screencoords.w) ) + 0.5 + norm_combine.xy*0.1*strength;
		vec4 refractcolor = texture(refractMap, coordUV1);
		vec4 lightmapcolor = texture(lightMap, ps_lightcoords);
		finalColor = refractcolor + lightmapcolor * lightstrength;
		
		float fogcoord = length(ps_eyecoords);
		
		float fogfactor = (fogparams.x - fogcoord)*fogparams.y;
		fogfactor = 1.0-SplineFraction(clamp(fogfactor, 0.0, 1.0), 1.0);
		
		finalColor.xyz = mix(finalColor.xyz, fogcolor, fogfactor);
	oColor = finalColor;
}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 normalmatrix_v;

uniform float texscale;

in vec4 in_position;
in vec2 in_texcoords;
in vec2 in_lightcoords;
in vec3 in_tangent;
in vec3 in_binormal;
in vec3 in_normal;

out vec4 ps_screencoords;
out vec3 ps_eyecoords;
out vec2 ps_texcoords;
out vec2 ps_lightcoords;

void main()
{
	vec4 position = in_position*modelview;
	vec4 eye_position = position*projection;

	ps_screencoords = eye_position;
	ps_eyecoords = position.xyz;

	ps_texcoords.x = in_texcoords.x*texscale;
	ps_texcoords.y = in_texcoords.y*texscale;
	
	ps_lightcoords = in_lightcoords;
	gl_Position = eye_position;
}
#version 130

uniform sampler2D normalMap;
uniform sampler2D lightMap;
uniform sampler2D refractMap;
uniform sampler2D reflectMap;
uniform sampler2DRect rectangleRefractMap;
uniform sampler2D diffuseMap;
uniform sampler2D lightvecsMap;

uniform mat4 normalmatrix;

uniform vec3 fogcolor;
uniform vec2 fogparams;

uniform float fresnel;
uniform float time;
uniform float strength;
uniform float lightstrength;
uniform float specularstrength;
uniform float phongexponent;

uniform vec2 scroll;
uniform vec2 rectscale;

in vec4 ps_screencoords;
in vec3 ps_eyecoords;
in vec2 ps_texcoords;
in vec2 ps_lightcoords;

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
	vec4 finalColor;

	vec2 texcoord = ps_texcoords + scroll;

	vec2 texc0 = vec2(texcoord.x+time*0.20, texcoord.y+time*0.15);
	vec2 texc1 = vec2(texcoord.x-time*0.13, texcoord.y+time*0.11);

	vec4 norm1 = texture(normalMap, texc0);
	vec4 norm2 = texture(normalMap, texc1);

	vec2 texc2 = vec2(texcoord.x+time*0.17, texcoord.y+time*0.15);
	vec2 texc3 = vec2(texcoord.x-time*0.14, texcoord.y-time*0.16);

	vec4 norm3 = texture(normalMap, texc2);
	vec4 norm4 = texture(normalMap, texc3);	

	vec3 norm_combine = normalize((norm1*0.25 + norm2*0.25 + norm3*0.25 + norm4*0.25).xyz * 2.0 - 1.0);

	vec2 coordUV1 = (ps_screencoords.xy / (2*ps_screencoords.w) ) + 0.5 + norm_combine.xy*0.1*strength;
		coordUV1 *= rectscale;
			vec4 refractcolor = texture(rectangleRefractMap, coordUV1);
		vec4 lightmapcolor = texture(lightMap, ps_lightcoords);
		finalColor = refractcolor + lightmapcolor * lightstrength;
		
		float fogcoord = length(ps_eyecoords);
		
		float fogfactor = (fogparams.x - fogcoord)*fogparams.y;
		fogfactor = 1.0-SplineFraction(clamp(fogfactor, 0.0, 1.0), 1.0);
		
		finalColor.xyz = mix(finalColor.xyz, fogcolor, fogfactor);
	oColor = finalColor;
}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 normalmatrix_v;

uniform float texscale;

in vec4 in_position;
in vec2 in_texcoords;
in vec2 in_lightcoords;
in vec3 in_tangent;
in vec3 in_binormal;
in vec3 in_normal;

out vec4 ps_screencoords;
out vec3 ps_eyecoords;
out vec2 ps_texcoords;
out vec2 ps_lightcoords;

void main()
{
	vec4 position = in_position*modelview;
	vec4 eye_position = position*projection;

	ps_screencoords = eye_position;
	ps_eyecoords = position.xyz;

	ps_texcoords.x = in_texcoords.x*texscale;
	ps_texcoords.y = in_texcoords.y*texscale;
	
	ps_lightcoords = in_lightcoords;
	gl_Position = eye_position;
}
#version 130

uniform sampler2D normalMap;
uniform sampler2D lightMap;
uniform sampler2D refractMap;
uniform sampler2D reflectMap;
uniform sampler2DRect rectangleRefractMap;
uniform sampler2D diffuseMap;
uniform sampler2D lightvecsMap;

uniform mat4 normalmatrix;

uniform vec3 fogcolor;
uniform vec2 fogparams;

uniform float fresnel;
uniform float time;
uniform float strength;
uniform float lightstrength;
uniform float specularstrength;
uniform float phongexponent;

uniform vec2 scroll;
uniform vec2 rectscale;

in vec4 ps_screencoords;
in vec3 ps_eyecoords;
in vec2 ps_texcoords;
in vec2 ps_lightcoords;

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
	vec4 finalColor;

	vec2 texcoord = ps_texcoords + scroll;

	vec2 texc0 = vec2(texcoord.x+time*0.20, texcoord.y+time*0.15);
	vec2 texc1 = vec2(texcoord.x-time*0.13, texcoord.y+time*0.11);

	vec4 norm1 = texture(normalMap, texc0);
	vec4 norm2 = texture(normalMap, texc1);

	vec2 texc2 = vec2(texcoord.x+time*0.17, texcoord.y+time*0.15);
	vec2 texc3 = vec2(texcoord.x-time*0.14, texcoord.y-time*0.16);

	vec4 norm3 = texture(normalMap, texc2);
	vec4 norm4 = texture(normalMap, texc3);	

	vec3 norm_combine = normalize((norm1*0.25 + norm2*0.25 + norm3*0.25 + norm4*0.25).xyz * 2.0 - 1.0);

	vec2 coordUV1 = (ps_screencoords.xy / (2*ps_screencoords.w) ) + 0.5 + norm_combine.xy*0.1*strength;
		vec4 refractcolor = texture(refractMap, coordUV1);
		vec2 coordUV2 = (vec2(ps_screencoords.x, -ps_screencoords.y) / (2*ps_screencoords.w) ) + 0.5 + norm_combine.xy*0.1*strength;
		vec4 reflectcolor = texture(reflectMap, coordUV2);

		vec3 vnormal_texture = normalize((normalmatrix*vec4(norm_combine, 0)).xyz);
		vec3 vnormal = normalize((normalmatrix*vec4(0, 0, 1, 0)).xyz);
		
		float fresnelterm = clamp(dot(-normalize(ps_eyecoords), vnormal_texture)*1.3*fresnel, 0.0, 0.97 );
		vec4 combinedColor = mix(reflectcolor, refractcolor, fresnelterm);

		vec4 lightmapcolor = texture(lightMap, ps_lightcoords);
		finalColor = combinedColor + lightmapcolor * lightstrength;
		
		float fogcoord = length(ps_eyecoords);
		
		float fogfactor = (fogparams.x - fogcoord)*fogparams.y;
		fogfactor = 1.0-SplineFraction(clamp(fogfactor, 0.0, 1.0), 1.0);
		
		finalColor.xyz = mix(finalColor.xyz, fogcolor, fogfactor);
	oColor = finalColor;
}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 normalmatrix_v;

uniform float texscale;

in vec4 in_position;
in vec2 in_texcoords;
in vec2 in_lightcoords;
in vec3 in_tangent;
in vec3 in_binormal;
in vec3 in_normal;

out vec4 ps_screencoords;
out vec3 ps_eyecoords;
out vec2 ps_texcoords;
out vec2 ps_lightcoords;

void main()
{
	vec4 position = in_position*modelview;
	vec4 eye_position = position*projection;

	ps_screencoords = eye_position;
	ps_eyecoords = position.xyz;

	ps_texcoords.x = in_texcoords.x*texscale;
	ps_texcoords.y = in_texcoords.y*texscale;
	
	ps_lightcoords = in_lightcoords;
	gl_Position = eye_position;
}
#version 130

uniform sampler2D normalMap;
uniform sampler2D lightMap;
uniform sampler2D refractMap;
uniform sampler2D reflectMap;
uniform sampler2DRect rectangleRefractMap;
uniform sampler2D diffuseMap;
uniform sampler2D lightvecsMap;

uniform mat4 normalmatrix;

uniform vec3 fogcolor;
uniform vec2 fogparams;

uniform float fresnel;
uniform float time;
uniform float strength;
uniform float lightstrength;
uniform float specularstrength;
uniform float phongexponent;

uniform vec2 scroll;
uniform vec2 rectscale;

in vec4 ps_screencoords;
in vec3 ps_eyecoords;
in vec2 ps_texcoords;
in vec2 ps_lightcoords;

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
	vec4 finalColor;

	vec2 texcoord = ps_texcoords + scroll;

	vec2 texc0 = vec2(texcoord.x+time*0.20, texcoord.y+time*0.15);
	vec2 texc1 = vec2(texcoord.x-time*0.13, texcoord.y+time*0.11);

	vec4 norm1 = texture(normalMap, texc0);
	vec4 norm2 = texture(normalMap, texc1);

	vec2 texc2 = vec2(texcoord.x+time*0.17, texcoord.y+time*0.15);
	vec2 texc3 = vec2(texcoord.x-time*0.14, texcoord.y-time*0.16);

	vec4 norm3 = texture(normalMap, texc2);
	vec4 norm4 = texture(normalMap, texc3);	

	vec3 norm_combine = normalize((norm1*0.25 + norm2*0.25 + norm3*0.25 + norm4*0.25).xyz * 2.0 - 1.0);

	vec2 coordUV1 = (ps_screencoords.xy / (2*ps_screencoords.w) ) + 0.5 + norm_combine.xy*0.1*strength;
		coordUV1 *= rectscale;
			vec4 refractcolor = texture(rectangleRefractMap, coordUV1);
		vec2 coordUV2 = (vec2(ps_screencoords.x, -ps_screencoords.y) / (2*ps_screencoords.w) ) + 0.5 + norm_combine.xy*0.1*strength;
		vec4 reflectcolor = texture(reflectMap, coordUV2);

		vec3 vnormal_texture = normalize((normalmatrix*vec4(norm_combine, 0)).xyz);
		vec3 vnormal = normalize((normalmatrix*vec4(0, 0, 1, 0)).xyz);
		
		float fresnelterm = clamp(dot(-normalize(ps_eyecoords), vnormal_texture)*1.3*fresnel, 0.0, 0.97 );
		vec4 combinedColor = mix(reflectcolor, refractcolor, fresnelterm);

		vec4 lightmapcolor = texture(lightMap, ps_lightcoords);
		finalColor = combinedColor + lightmapcolor * lightstrength;
		
		float fogcoord = length(ps_eyecoords);
		
		float fogfactor = (fogparams.x - fogcoord)*fogparams.y;
		fogfactor = 1.0-SplineFraction(clamp(fogfactor, 0.0, 1.0), 1.0);
		
		finalColor.xyz = mix(finalColor.xyz, fogcolor, fogfactor);
	oColor = finalColor;
}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 normalmatrix_v;

uniform float texscale;

in vec4 in_position;
in vec2 in_texcoords;
in vec2 in_lightcoords;
in vec3 in_tangent;
in vec3 in_binormal;
in vec3 in_normal;

out vec4 ps_screencoords;
out vec3 ps_eyecoords;
out vec2 ps_texcoords;
out vec2 ps_lightcoords;

out vec3 ps_tangent;
	out vec3 ps_binormal;
	out vec3 ps_normal;
void main()
{
	vec4 position = in_position*modelview;
	vec4 eye_position = position*projection;

	ps_screencoords = eye_position;
	ps_eyecoords = position.xyz;

	ps_tangent = (normalmatrix_v*vec4(in_tangent, 0.0)).xyz;
		ps_binormal = (normalmatrix_v*vec4(in_binormal, 0.0)).xyz;
		ps_normal = (normalmatrix_v*vec4(in_normal, 0.0)).xyz;
	ps_texcoords.x = in_texcoords.x*texscale;
	ps_texcoords.y = in_texcoords.y*texscale;
	
	ps_lightcoords = in_lightcoords;
	gl_Position = eye_position;
}
#version 130

uniform sampler2D normalMap;
uniform sampler2D lightMap;
uniform sampler2D refractMap;
uniform sampler2D reflectMap;
uniform sampler2DRect rectangleRefractMap;
uniform sampler2D diffuseMap;
uniform sampler2D lightvecsMap;

uniform mat4 normalmatrix;

uniform vec3 fogcolor;
uniform vec2 fogparams;

uniform float fresnel;
uniform float time;
uniform float strength;
uniform float lightstrength;
uniform float specularstrength;
uniform float phongexponent;

uniform vec2 scroll;
uniform vec2 rectscale;

in vec4 ps_screencoords;
in vec3 ps_eyecoords;
in vec2 ps_texcoords;
in vec2 ps_lightcoords;

in vec3 ps_tangent;
	in vec3 ps_binormal;
	in vec3 ps_normal;
out vec4 oColor;

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}
float CalcShininess( vec3 v_origin, vec3 v_normal, vec3 l_origin )
{
	vec3 halfVec = normalize(l_origin - v_origin);
	return max(dot(halfVec, v_normal), 0.0);
}

float CalcSpecular( vec3 v_origin, vec3 v_normal, vec3 lightDir, float specularStrength )
{
	// Eye vector (towards the camera)
	// All coordinates are in eye space
	vec3 eyeVec = normalize( -v_origin );
	
	// Direction in which the triangle reflects the light
	vec3 reflectVec = reflect( lightDir, v_normal );
	
	// Cosine of the angle between the Eye vector and the Reflect vector,
	// clamped to 0
	//  - Looking into the reflection -> 1
	//  - Looking elsewhere -> < 1
	float cosAlpha = clamp( dot( eyeVec, reflectVec ), 0,1 );	
	
	// Currently specular color is light color times two
	return pow( cosAlpha, phongexponent ) * specularStrength;
}

vec4 GetLightmappedSpecular( vec3 v_origin, vec3 v_normal, float specularStrength )
{
	// Get light vector from lightmap
	vec3 lightDir = (2.0 * texture2D(lightvecsMap, ps_lightcoords).xyz) - 1.0;
	lightDir = normalize(lightDir);

	// Get diffuse light component
	vec4 lightDiffuse = texture2D(diffuseMap, ps_lightcoords);
	
	// Add specular if any
	mat3 tbnMatrix = mat3(ps_tangent, ps_binormal, ps_normal);
	vec3 eyeSpaceDir = normalize(tbnMatrix * vec3(lightDir[0], -lightDir[1], lightDir[2]));
	
	float shineFactor = CalcShininess(normalize(v_origin), v_normal, eyeSpaceDir);
	float specularValue = CalcSpecular(v_origin, v_normal, -eyeSpaceDir, specularStrength);
	
	vec4 finalColor = specularValue * lightDiffuse * shineFactor;
	return finalColor;
}
vec4 GetUnderwaterRefracton( vec3 v_origin, vec3 v_normal, float specularStrength )
{
	// Get light vector from lightmap
	vec3 lightDir = (2.0 * texture2D(lightvecsMap, ps_lightcoords).xyz) - 1.0;
	lightDir = normalize(lightDir);

	// Get diffuse light component
	vec4 lightDiffuse = texture2D(diffuseMap, ps_lightcoords);

	// Add specular if any
	mat3 tbnMatrix = mat3(ps_tangent, ps_binormal, ps_normal);
	vec3 eyeSpaceDir = normalize(tbnMatrix * vec3(lightDir[0], -lightDir[1], lightDir[2]));
	
	float shineFactor = CalcShininess(normalize(v_origin), v_normal, eyeSpaceDir);
	
	// Eye vector (towards the camera)
	// All coordinates are in eye space
	vec3 eyeVec = normalize( v_origin );	
	
	float cosAlpha = clamp( dot( eyeSpaceDir, v_normal ), 0,1 );	
	float specularValue = pow( cosAlpha, phongexponent ) * specularStrength;
	specularValue *= clamp( dot( eyeSpaceDir, eyeVec ), 0,1 );
	
	vec4 finalColor = specularValue * lightDiffuse * shineFactor;
	return finalColor;
}
void main()
{
	vec4 finalColor;

	vec2 texcoord = ps_texcoords + scroll;

	vec2 texc0 = vec2(texcoord.x+time*0.20, texcoord.y+time*0.15);
	vec2 texc1 = vec2(texcoord.x-time*0.13, texcoord.y+time*0.11);

	vec4 norm1 = texture(normalMap, texc0);
	vec4 norm2 = texture(normalMap, texc1);

	vec2 texc2 = vec2(texcoord.x+time*0.17, texcoord.y+time*0.15);
	vec2 texc3 = vec2(texcoord.x-time*0.14, texcoord.y-time*0.16);

	vec4 norm3 = texture(normalMap, texc2);
	vec4 norm4 = texture(normalMap, texc3);	

	vec3 norm_combine = normalize((norm1*0.25 + norm2*0.25 + norm3*0.25 + norm4*0.25).xyz * 2.0 - 1.0);

	vec2 coordUV1 = (ps_screencoords.xy / (2*ps_screencoords.w) ) + 0.5 + norm_combine.xy*0.1*strength;
		vec4 refractcolor = texture(refractMap, coordUV1);
		vec4 lightmapcolor = texture(lightMap, ps_lightcoords);
		finalColor = refractcolor + lightmapcolor * lightstrength;
		
		vec3 vnormal_texture = normalize((normalmatrix*vec4(norm_combine, 0)).xyz);
			finalColor += GetUnderwaterRefracton( ps_eyecoords, vnormal_texture, specularstrength );
		oColor = finalColor;
}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 normalmatrix_v;

uniform float texscale;

in vec4 in_position;
in vec2 in_texcoords;
in vec2 in_lightcoords;
in vec3 in_tangent;
in vec3 in_binormal;
in vec3 in_normal;

out vec4 ps_screencoords;
out vec3 ps_eyecoords;
out vec2 ps_texcoords;
out vec2 ps_lightcoords;

out vec3 ps_tangent;
	out vec3 ps_binormal;
	out vec3 ps_normal;
void main()
{
	vec4 position = in_position*modelview;
	vec4 eye_position = position*projection;

	ps_screencoords = eye_position;
	ps_eyecoords = position.xyz;

	ps_tangent = (normalmatrix_v*vec4(in_tangent, 0.0)).xyz;
		ps_binormal = (normalmatrix_v*vec4(in_binormal, 0.0)).xyz;
		ps_normal = (normalmatrix_v*vec4(in_normal, 0.0)).xyz;
	ps_texcoords.x = in_texcoords.x*texscale;
	ps_texcoords.y = in_texcoords.y*texscale;
	
	ps_lightcoords = in_lightcoords;
	gl_Position = eye_position;
}
#version 130

uniform sampler2D normalMap;
uniform sampler2D lightMap;
uniform sampler2D refractMap;
uniform sampler2D reflectMap;
uniform sampler2DRect rectangleRefractMap;
uniform sampler2D diffuseMap;
uniform sampler2D lightvecsMap;

uniform mat4 normalmatrix;

uniform vec3 fogcolor;
uniform vec2 fogparams;

uniform float fresnel;
uniform float time;
uniform float strength;
uniform float lightstrength;
uniform float specularstrength;
uniform float phongexponent;

uniform vec2 scroll;
uniform vec2 rectscale;

in vec4 ps_screencoords;
in vec3 ps_eyecoords;
in vec2 ps_texcoords;
in vec2 ps_lightcoords;

in vec3 ps_tangent;
	in vec3 ps_binormal;
	in vec3 ps_normal;
out vec4 oColor;

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}
float CalcShininess( vec3 v_origin, vec3 v_normal, vec3 l_origin )
{
	vec3 halfVec = normalize(l_origin - v_origin);
	return max(dot(halfVec, v_normal), 0.0);
}

float CalcSpecular( vec3 v_origin, vec3 v_normal, vec3 lightDir, float specularStrength )
{
	// Eye vector (towards the camera)
	// All coordinates are in eye space
	vec3 eyeVec = normalize( -v_origin );
	
	// Direction in which the triangle reflects the light
	vec3 reflectVec = reflect( lightDir, v_normal );
	
	// Cosine of the angle between the Eye vector and the Reflect vector,
	// clamped to 0
	//  - Looking into the reflection -> 1
	//  - Looking elsewhere -> < 1
	float cosAlpha = clamp( dot( eyeVec, reflectVec ), 0,1 );	
	
	// Currently specular color is light color times two
	return pow( cosAlpha, phongexponent ) * specularStrength;
}

vec4 GetLightmappedSpecular( vec3 v_origin, vec3 v_normal, float specularStrength )
{
	// Get light vector from lightmap
	vec3 lightDir = (2.0 * texture2D(lightvecsMap, ps_lightcoords).xyz) - 1.0;
	lightDir = normalize(lightDir);

	// Get diffuse light component
	vec4 lightDiffuse = texture2D(diffuseMap, ps_lightcoords);
	
	// Add specular if any
	mat3 tbnMatrix = mat3(ps_tangent, ps_binormal, ps_normal);
	vec3 eyeSpaceDir = normalize(tbnMatrix * vec3(lightDir[0], -lightDir[1], lightDir[2]));
	
	float shineFactor = CalcShininess(normalize(v_origin), v_normal, eyeSpaceDir);
	float specularValue = CalcSpecular(v_origin, v_normal, -eyeSpaceDir, specularStrength);
	
	vec4 finalColor = specularValue * lightDiffuse * shineFactor;
	return finalColor;
}
vec4 GetUnderwaterRefracton( vec3 v_origin, vec3 v_normal, float specularStrength )
{
	// Get light vector from lightmap
	vec3 lightDir = (2.0 * texture2D(lightvecsMap, ps_lightcoords).xyz) - 1.0;
	lightDir = normalize(lightDir);

	// Get diffuse light component
	vec4 lightDiffuse = texture2D(diffuseMap, ps_lightcoords);

	// Add specular if any
	mat3 tbnMatrix = mat3(ps_tangent, ps_binormal, ps_normal);
	vec3 eyeSpaceDir = normalize(tbnMatrix * vec3(lightDir[0], -lightDir[1], lightDir[2]));
	
	float shineFactor = CalcShininess(normalize(v_origin), v_normal, eyeSpaceDir);
	
	// Eye vector (towards the camera)
	// All coordinates are in eye space
	vec3 eyeVec = normalize( v_origin );	
	
	float cosAlpha = clamp( dot( eyeSpaceDir, v_normal ), 0,1 );	
	float specularValue = pow( cosAlpha, phongexponent ) * specularStrength;
	specularValue *= clamp( dot( eyeSpaceDir, eyeVec ), 0,1 );
	
	vec4 finalColor = specularValue * lightDiffuse * shineFactor;
	return finalColor;
}
void main()
{
	vec4 finalColor;

	vec2 texcoord = ps_texcoords + scroll;

	vec2 texc0 = vec2(texcoord.x+time*0.20, texcoord.y+time*0.15);
	vec2 texc1 = vec2(texcoord.x-time*0.13, texcoord.y+time*0.11);

	vec4 norm1 = texture(normalMap, texc0);
	vec4 norm2 = texture(normalMap, texc1);

	vec2 texc2 = vec2(texcoord.x+time*0.17, texcoord.y+time*0.15);
	vec2 texc3 = vec2(texcoord.x-time*0.14, texcoord.y-time*0.16);

	vec4 norm3 = texture(normalMap, texc2);
	vec4 norm4 = texture(normalMap, texc3);	

	vec3 norm_combine = normalize((norm1*0.25 + norm2*0.25 + norm3*0.25 + norm4*0.25).xyz * 2.0 - 1.0);

	vec2 coordUV1 = (ps_screencoords.xy / (2*ps_screencoords.w) ) + 0.5 + norm_combine.xy*0.1*strength;
		coordUV1 *= rectscale;
			vec4 refractcolor = texture(rectangleRefractMap, coordUV1);
		vec4 lightmapcolor = texture(lightMap, ps_lightcoords);
		finalColor = refractcolor + lightmapcolor * lightstrength;
		
		vec3 vnormal_texture = normalize((normalmatrix*vec4(norm_combine, 0)).xyz);
			finalColor += GetUnderwaterRefracton( ps_eyecoords, vnormal_texture, specularstrength );
		oColor = finalColor;
}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 normalmatrix_v;

uniform float texscale;

in vec4 in_position;
in vec2 in_texcoords;
in vec2 in_lightcoords;
in vec3 in_tangent;
in vec3 in_binormal;
in vec3 in_normal;

out vec4 ps_screencoords;
out vec3 ps_eyecoords;
out vec2 ps_texcoords;
out vec2 ps_lightcoords;

out vec3 ps_tangent;
	out vec3 ps_binormal;
	out vec3 ps_normal;
void main()
{
	vec4 position = in_position*modelview;
	vec4 eye_position = position*projection;

	ps_screencoords = eye_position;
	ps_eyecoords = position.xyz;

	ps_tangent = (normalmatrix_v*vec4(in_tangent, 0.0)).xyz;
		ps_binormal = (normalmatrix_v*vec4(in_binormal, 0.0)).xyz;
		ps_normal = (normalmatrix_v*vec4(in_normal, 0.0)).xyz;
	ps_texcoords.x = in_texcoords.x*texscale;
	ps_texcoords.y = in_texcoords.y*texscale;
	
	ps_lightcoords = in_lightcoords;
	gl_Position = eye_position;
}
#version 130

uniform sampler2D normalMap;
uniform sampler2D lightMap;
uniform sampler2D refractMap;
uniform sampler2D reflectMap;
uniform sampler2DRect rectangleRefractMap;
uniform sampler2D diffuseMap;
uniform sampler2D lightvecsMap;

uniform mat4 normalmatrix;

uniform vec3 fogcolor;
uniform vec2 fogparams;

uniform float fresnel;
uniform float time;
uniform float strength;
uniform float lightstrength;
uniform float specularstrength;
uniform float phongexponent;

uniform vec2 scroll;
uniform vec2 rectscale;

in vec4 ps_screencoords;
in vec3 ps_eyecoords;
in vec2 ps_texcoords;
in vec2 ps_lightcoords;

in vec3 ps_tangent;
	in vec3 ps_binormal;
	in vec3 ps_normal;
out vec4 oColor;

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}
float CalcShininess( vec3 v_origin, vec3 v_normal, vec3 l_origin )
{
	vec3 halfVec = normalize(l_origin - v_origin);
	return max(dot(halfVec, v_normal), 0.0);
}

float CalcSpecular( vec3 v_origin, vec3 v_normal, vec3 lightDir, float specularStrength )
{
	// Eye vector (towards the camera)
	// All coordinates are in eye space
	vec3 eyeVec = normalize( -v_origin );
	
	// Direction in which the triangle reflects the light
	vec3 reflectVec = reflect( lightDir, v_normal );
	
	// Cosine of the angle between the Eye vector and the Reflect vector,
	// clamped to 0
	//  - Looking into the reflection -> 1
	//  - Looking elsewhere -> < 1
	float cosAlpha = clamp( dot( eyeVec, reflectVec ), 0,1 );	
	
	// Currently specular color is light color times two
	return pow( cosAlpha, phongexponent ) * specularStrength;
}

vec4 GetLightmappedSpecular( vec3 v_origin, vec3 v_normal, float specularStrength )
{
	// Get light vector from lightmap
	vec3 lightDir = (2.0 * texture2D(lightvecsMap, ps_lightcoords).xyz) - 1.0;
	lightDir = normalize(lightDir);

	// Get diffuse light component
	vec4 lightDiffuse = texture2D(diffuseMap, ps_lightcoords);
	
	// Add specular if any
	mat3 tbnMatrix = mat3(ps_tangent, ps_binormal, ps_normal);
	vec3 eyeSpaceDir = normalize(tbnMatrix * vec3(lightDir[0], -lightDir[1], lightDir[2]));
	
	float shineFactor = CalcShininess(normalize(v_origin), v_normal, eyeSpaceDir);
	float specularValue = CalcSpecular(v_origin, v_normal, -eyeSpaceDir, specularStrength);
	
	vec4 finalColor = specularValue * lightDiffuse * shineFactor;
	return finalColor;
}
vec4 GetUnderwaterRefracton( vec3 v_origin, vec3 v_normal, float specularStrength )
{
	// Get light vector from lightmap
	vec3 lightDir = (2.0 * texture2D(lightvecsMap, ps_lightcoords).xyz) - 1.0;
	lightDir = normalize(lightDir);

	// Get diffuse light component
	vec4 lightDiffuse = texture2D(diffuseMap, ps_lightcoords);

	// Add specular if any
	mat3 tbnMatrix = mat3(ps_tangent, ps_binormal, ps_normal);
	vec3 eyeSpaceDir = normalize(tbnMatrix * vec3(lightDir[0], -lightDir[1], lightDir[2]));
	
	float shineFactor = CalcShininess(normalize(v_origin), v_normal, eyeSpaceDir);
	
	// Eye vector (towards the camera)
	// All coordinates are in eye space
	vec3 eyeVec = normalize( v_origin );	
	
	float cosAlpha = clamp( dot( eyeSpaceDir, v_normal ), 0,1 );	
	float specularValue = pow( cosAlpha, phongexponent ) * specularStrength;
	specularValue *= clamp( dot( eyeSpaceDir, eyeVec ), 0,1 );
	
	vec4 finalColor = specularValue * lightDiffuse * shineFactor;
	return finalColor;
}
void main()
{
	vec4 finalColor;

	vec2 texcoord = ps_texcoords + scroll;

	vec2 texc0 = vec2(texcoord.x+time*0.20, texcoord.y+time*0.15);
	vec2 texc1 = vec2(texcoord.x-time*0.13, texcoord.y+time*0.11);

	vec4 norm1 = texture(normalMap, texc0);
	vec4 norm2 = texture(normalMap, texc1);

	vec2 texc2 = vec2(texcoord.x+time*0.17, texcoord.y+time*0.15);
	vec2 texc3 = vec2(texcoord.x-time*0.14, texcoord.y-time*0.16);

	vec4 norm3 = texture(normalMap, texc2);
	vec4 norm4 = texture(normalMap, texc3);	

	vec3 norm_combine = normalize((norm1*0.25 + norm2*0.25 + norm3*0.25 + norm4*0.25).xyz * 2.0 - 1.0);

	vec2 coordUV1 = (ps_screencoords.xy / (2*ps_screencoords.w) ) + 0.5 + norm_combine.xy*0.1*strength;
		vec4 refractcolor = texture(refractMap, coordUV1);
		vec2 coordUV2 = (vec2(ps_screencoords.x, -ps_screencoords.y) / (2*ps_screencoords.w) ) + 0.5 + norm_combine.xy*0.1*strength;
		vec4 reflectcolor = texture(reflectMap, coordUV2);

		vec3 vnormal_texture = normalize((normalmatrix*vec4(norm_combine, 0)).xyz);
		vec3 vnormal = normalize((normalmatrix*vec4(0, 0, 1, 0)).xyz);
		
		float fresnelterm = clamp(dot(-normalize(ps_eyecoords), vnormal_texture)*1.3*fresnel, 0.0, 0.97 );
		vec4 combinedColor = mix(reflectcolor, refractcolor, fresnelterm);

		vec4 lightmapcolor = texture(lightMap, ps_lightcoords);
		finalColor = combinedColor + lightmapcolor * lightstrength;
		
		finalColor += GetLightmappedSpecular( ps_eyecoords, vnormal_texture, specularstrength );
		oColor = finalColor;
}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 normalmatrix_v;

uniform float texscale;

in vec4 in_position;
in vec2 in_texcoords;
in vec2 in_lightcoords;
in vec3 in_tangent;
in vec3 in_binormal;
in vec3 in_normal;

out vec4 ps_screencoords;
out vec3 ps_eyecoords;
out vec2 ps_texcoords;
out vec2 ps_lightcoords;

out vec3 ps_tangent;
	out vec3 ps_binormal;
	out vec3 ps_normal;
void main()
{
	vec4 position = in_position*modelview;
	vec4 eye_position = position*projection;

	ps_screencoords = eye_position;
	ps_eyecoords = position.xyz;

	ps_tangent = (normalmatrix_v*vec4(in_tangent, 0.0)).xyz;
		ps_binormal = (normalmatrix_v*vec4(in_binormal, 0.0)).xyz;
		ps_normal = (normalmatrix_v*vec4(in_normal, 0.0)).xyz;
	ps_texcoords.x = in_texcoords.x*texscale;
	ps_texcoords.y = in_texcoords.y*texscale;
	
	ps_lightcoords = in_lightcoords;
	gl_Position = eye_position;
}
#version 130

uniform sampler2D normalMap;
uniform sampler2D lightMap;
uniform sampler2D refractMap;
uniform sampler2D reflectMap;
uniform sampler2DRect rectangleRefractMap;
uniform sampler2D diffuseMap;
uniform sampler2D lightvecsMap;

uniform mat4 normalmatrix;

uniform vec3 fogcolor;
uniform vec2 fogparams;

uniform float fresnel;
uniform float time;
uniform float strength;
uniform float lightstrength;
uniform float specularstrength;
uniform float phongexponent;

uniform vec2 scroll;
uniform vec2 rectscale;

in vec4 ps_screencoords;
in vec3 ps_eyecoords;
in vec2 ps_texcoords;
in vec2 ps_lightcoords;

in vec3 ps_tangent;
	in vec3 ps_binormal;
	in vec3 ps_normal;
out vec4 oColor;

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}
float CalcShininess( vec3 v_origin, vec3 v_normal, vec3 l_origin )
{
	vec3 halfVec = normalize(l_origin - v_origin);
	return max(dot(halfVec, v_normal), 0.0);
}

float CalcSpecular( vec3 v_origin, vec3 v_normal, vec3 lightDir, float specularStrength )
{
	// Eye vector (towards the camera)
	// All coordinates are in eye space
	vec3 eyeVec = normalize( -v_origin );
	
	// Direction in which the triangle reflects the light
	vec3 reflectVec = reflect( lightDir, v_normal );
	
	// Cosine of the angle between the Eye vector and the Reflect vector,
	// clamped to 0
	//  - Looking into the reflection -> 1
	//  - Looking elsewhere -> < 1
	float cosAlpha = clamp( dot( eyeVec, reflectVec ), 0,1 );	
	
	// Currently specular color is light color times two
	return pow( cosAlpha, phongexponent ) * specularStrength;
}

vec4 GetLightmappedSpecular( vec3 v_origin, vec3 v_normal, float specularStrength )
{
	// Get light vector from lightmap
	vec3 lightDir = (2.0 * texture2D(lightvecsMap, ps_lightcoords).xyz) - 1.0;
	lightDir = normalize(lightDir);

	// Get diffuse light component
	vec4 lightDiffuse = texture2D(diffuseMap, ps_lightcoords);
	
	// Add specular if any
	mat3 tbnMatrix = mat3(ps_tangent, ps_binormal, ps_normal);
	vec3 eyeSpaceDir = normalize(tbnMatrix * vec3(lightDir[0], -lightDir[1], lightDir[2]));
	
	float shineFactor = CalcShininess(normalize(v_origin), v_normal, eyeSpaceDir);
	float specularValue = CalcSpecular(v_origin, v_normal, -eyeSpaceDir, specularStrength);
	
	vec4 finalColor = specularValue * lightDiffuse * shineFactor;
	return finalColor;
}
vec4 GetUnderwaterRefracton( vec3 v_origin, vec3 v_normal, float specularStrength )
{
	// Get light vector from lightmap
	vec3 lightDir = (2.0 * texture2D(lightvecsMap, ps_lightcoords).xyz) - 1.0;
	lightDir = normalize(lightDir);

	// Get diffuse light component
	vec4 lightDiffuse = texture2D(diffuseMap, ps_lightcoords);

	// Add specular if any
	mat3 tbnMatrix = mat3(ps_tangent, ps_binormal, ps_normal);
	vec3 eyeSpaceDir = normalize(tbnMatrix * vec3(lightDir[0], -lightDir[1], lightDir[2]));
	
	float shineFactor = CalcShininess(normalize(v_origin), v_normal, eyeSpaceDir);
	
	// Eye vector (towards the camera)
	// All coordinates are in eye space
	vec3 eyeVec = normalize( v_origin );	
	
	float cosAlpha = clamp( dot( eyeSpaceDir, v_normal ), 0,1 );	
	float specularValue = pow( cosAlpha, phongexponent ) * specularStrength;
	specularValue *= clamp( dot( eyeSpaceDir, eyeVec ), 0,1 );
	
	vec4 finalColor = specularValue * lightDiffuse * shineFactor;
	return finalColor;
}
void main()
{
	vec4 finalColor;

	vec2 texcoord = ps_texcoords + scroll;

	vec2 texc0 = vec2(texcoord.x+time*0.20, texcoord.y+time*0.15);
	vec2 texc1 = vec2(texcoord.x-time*0.13, texcoord.y+time*0.11);

	vec4 norm1 = texture(normalMap, texc0);
	vec4 norm2 = texture(normalMap, texc1);

	vec2 texc2 = vec2(texcoord.x+time*0.17, texcoord.y+time*0.15);
	vec2 texc3 = vec2(texcoord.x-time*0.14, texcoord.y-time*0.16);

	vec4 norm3 = texture(normalMap, texc2);
	vec4 norm4 = texture(normalMap, texc3);	

	vec3 norm_combine = normalize((norm1*0.25 + norm2*0.25 + norm3*0.25 + norm4*0.25).xyz * 2.0 - 1.0);

	vec2 coordUV1 = (ps_screencoords.xy / (2*ps_screencoords.w) ) + 0.5 + norm_combine.xy*0.1*strength;
		coordUV1 *= rectscale;
			vec4 refractcolor = texture(rectangleRefractMap, coordUV1);
		vec2 coordUV2 = (vec2(ps_screencoords.x, -ps_screencoords.y) / (2*ps_screencoords.w) ) + 0.5 + norm_combine.xy*0.1*strength;
		vec4 reflectcolor = texture(reflectMap, coordUV2);

		vec3 vnormal_texture = normalize((normalmatrix*vec4(norm_combine, 0)).xyz);
		vec3 vnormal = normalize((normalmatrix*vec4(0, 0, 1, 0)).xyz);
		
		float fresnelterm = clamp(dot(-normalize(ps_eyecoords), vnormal_texture)*1.3*fresnel, 0.0, 0.97 );
		vec4 combinedColor = mix(reflectcolor, refractcolor, fresnelterm);

		vec4 lightmapcolor = texture(lightMap, ps_lightcoords);
		finalColor = combinedColor + lightmapcolor * lightstrength;
		
		finalColor += GetLightmappedSpecular( ps_eyecoords, vnormal_texture, specularstrength );
		oColor = finalColor;
}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 normalmatrix_v;

uniform float texscale;

in vec4 in_position;
in vec2 in_texcoords;
in vec2 in_lightcoords;
in vec3 in_tangent;
in vec3 in_binormal;
in vec3 in_normal;

out vec4 ps_screencoords;
out vec3 ps_eyecoords;
out vec2 ps_texcoords;
out vec2 ps_lightcoords;

out vec3 ps_tangent;
	out vec3 ps_binormal;
	out vec3 ps_normal;
void main()
{
	vec4 position = in_position*modelview;
	vec4 eye_position = position*projection;

	ps_screencoords = eye_position;
	ps_eyecoords = position.xyz;

	ps_tangent = (normalmatrix_v*vec4(in_tangent, 0.0)).xyz;
		ps_binormal = (normalmatrix_v*vec4(in_binormal, 0.0)).xyz;
		ps_normal = (normalmatrix_v*vec4(in_normal, 0.0)).xyz;
	ps_texcoords.x = in_texcoords.x*texscale;
	ps_texcoords.y = in_texcoords.y*texscale;
	
	ps_lightcoords = in_lightcoords;
	gl_Position = eye_position;
}
#version 130

uniform sampler2D normalMap;
uniform sampler2D lightMap;
uniform sampler2D refractMap;
uniform sampler2D reflectMap;
uniform sampler2DRect rectangleRefractMap;
uniform sampler2D diffuseMap;
uniform sampler2D lightvecsMap;

uniform mat4 normalmatrix;

uniform vec3 fogcolor;
uniform vec2 fogparams;

uniform float fresnel;
uniform float time;
uniform float strength;
uniform float lightstrength;
uniform float specularstrength;
uniform float phongexponent;

uniform vec2 scroll;
uniform vec2 rectscale;

in vec4 ps_screencoords;
in vec3 ps_eyecoords;
in vec2 ps_texcoords;
in vec2 ps_lightcoords;

in vec3 ps_tangent;
	in vec3 ps_binormal;
	in vec3 ps_normal;
out vec4 oColor;

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}
float CalcShininess( vec3 v_origin, vec3 v_normal, vec3 l_origin )
{
	vec3 halfVec = normalize(l_origin - v_origin);
	return max(dot(halfVec, v_normal), 0.0);
}

float CalcSpecular( vec3 v_origin, vec3 v_normal, vec3 lightDir, float specularStrength )
{
	// Eye vector (towards the camera)
	// All coordinates are in eye space
	vec3 eyeVec = normalize( -v_origin );
	
	// Direction in which the triangle reflects the light
	vec3 reflectVec = reflect( lightDir, v_normal );
	
	// Cosine of the angle between the Eye vector and the Reflect vector,
	// clamped to 0
	//  - Looking into the reflection -> 1
	//  - Looking elsewhere -> < 1
	float cosAlpha = clamp( dot( eyeVec, reflectVec ), 0,1 );	
	
	// Currently specular color is light color times two
	return pow( cosAlpha, phongexponent ) * specularStrength;
}

vec4 GetLightmappedSpecular( vec3 v_origin, vec3 v_normal, float specularStrength )
{
	// Get light vector from lightmap
	vec3 lightDir = (2.0 * texture2D(lightvecsMap, ps_lightcoords).xyz) - 1.0;
	lightDir = normalize(lightDir);

	// Get diffuse light component
	vec4 lightDiffuse = texture2D(diffuseMap, ps_lightcoords);
	
	// Add specular if any
	mat3 tbnMatrix = mat3(ps_tangent, ps_binormal, ps_normal);
	vec3 eyeSpaceDir = normalize(tbnMatrix * vec3(lightDir[0], -lightDir[1], lightDir[2]));
	
	float shineFactor = CalcShininess(normalize(v_origin), v_normal, eyeSpaceDir);
	float specularValue = CalcSpecular(v_origin, v_normal, -eyeSpaceDir, specularStrength);
	
	vec4 finalColor = specularValue * lightDiffuse * shineFactor;
	return finalColor;
}
vec4 GetUnderwaterRefracton( vec3 v_origin, vec3 v_normal, float specularStrength )
{
	// Get light vector from lightmap
	vec3 lightDir = (2.0 * texture2D(lightvecsMap, ps_lightcoords).xyz) - 1.0;
	lightDir = normalize(lightDir);

	// Get diffuse light component
	vec4 lightDiffuse = texture2D(diffuseMap, ps_lightcoords);

	// Add specular if any
	mat3 tbnMatrix = mat3(ps_tangent, ps_binormal, ps_normal);
	vec3 eyeSpaceDir = normalize(tbnMatrix * vec3(lightDir[0], -lightDir[1], lightDir[2]));
	
	float shineFactor = CalcShininess(normalize(v_origin), v_normal, eyeSpaceDir);
	
	// Eye vector (towards the camera)
	// All coordinates are in eye space
	vec3 eyeVec = normalize( v_origin );	
	
	float cosAlpha = clamp( dot( eyeSpaceDir, v_normal ), 0,1 );	
	float specularValue = pow( cosAlpha, phongexponent ) * specularStrength;
	specularValue *= clamp( dot( eyeSpaceDir, eyeVec ), 0,1 );
	
	vec4 finalColor = specularValue * lightDiffuse * shineFactor;
	return finalColor;
}
void main()
{
	vec4 finalColor;

	vec2 texcoord = ps_texcoords + scroll;

	vec2 texc0 = vec2(texcoord.x+time*0.20, texcoord.y+time*0.15);
	vec2 texc1 = vec2(texcoord.x-time*0.13, texcoord.y+time*0.11);

	vec4 norm1 = texture(normalMap, texc0);
	vec4 norm2 = texture(normalMap, texc1);

	vec2 texc2 = vec2(texcoord.x+time*0.17, texcoord.y+time*0.15);
	vec2 texc3 = vec2(texcoord.x-time*0.14, texcoord.y-time*0.16);

	vec4 norm3 = texture(normalMap, texc2);
	vec4 norm4 = texture(normalMap, texc3);	

	vec3 norm_combine = normalize((norm1*0.25 + norm2*0.25 + norm3*0.25 + norm4*0.25).xyz * 2.0 - 1.0);

	vec2 coordUV1 = (ps_screencoords.xy / (2*ps_screencoords.w) ) + 0.5 + norm_combine.xy*0.1*strength;
		vec4 refractcolor = texture(refractMap, coordUV1);
		vec4 lightmapcolor = texture(lightMap, ps_lightcoords);
		finalColor = refractcolor + lightmapcolor * lightstrength;
		
		vec3 vnormal_texture = normalize((normalmatrix*vec4(norm_combine, 0)).xyz);
			finalColor += GetUnderwaterRefracton( ps_eyecoords, vnormal_texture, specularstrength );
		float fogcoord = length(ps_eyecoords);
		
		float fogfactor = (fogparams.x - fogcoord)*fogparams.y;
		fogfactor = 1.0-SplineFraction(clamp(fogfactor, 0.0, 1.0), 1.0);
		
		finalColor.xyz = mix(finalColor.xyz, fogcolor, fogfactor);
	oColor = finalColor;
}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 normalmatrix_v;

uniform float texscale;

in vec4 in_position;
in vec2 in_texcoords;
in vec2 in_lightcoords;
in vec3 in_tangent;
in vec3 in_binormal;
in vec3 in_normal;

out vec4 ps_screencoords;
out vec3 ps_eyecoords;
out vec2 ps_texcoords;
out vec2 ps_lightcoords;

out vec3 ps_tangent;
	out vec3 ps_binormal;
	out vec3 ps_normal;
void main()
{
	vec4 position = in_position*modelview;
	vec4 eye_position = position*projection;

	ps_screencoords = eye_position;
	ps_eyecoords = position.xyz;

	ps_tangent = (normalmatrix_v*vec4(in_tangent, 0.0)).xyz;
		ps_binormal = (normalmatrix_v*vec4(in_binormal, 0.0)).xyz;
		ps_normal = (normalmatrix_v*vec4(in_normal, 0.0)).xyz;
	ps_texcoords.x = in_texcoords.x*texscale;
	ps_texcoords.y = in_texcoords.y*texscale;
	
	ps_lightcoords = in_lightcoords;
	gl_Position = eye_position;
}
#version 130

uniform sampler2D normalMap;
uniform sampler2D lightMap;
uniform sampler2D refractMap;
uniform sampler2D reflectMap;
uniform sampler2DRect rectangleRefractMap;
uniform sampler2D diffuseMap;
uniform sampler2D lightvecsMap;

uniform mat4 normalmatrix;

uniform vec3 fogcolor;
uniform vec2 fogparams;

uniform float fresnel;
uniform float time;
uniform float strength;
uniform float lightstrength;
uniform float specularstrength;
uniform float phongexponent;

uniform vec2 scroll;
uniform vec2 rectscale;

in vec4 ps_screencoords;
in vec3 ps_eyecoords;
in vec2 ps_texcoords;
in vec2 ps_lightcoords;

in vec3 ps_tangent;
	in vec3 ps_binormal;
	in vec3 ps_normal;
out vec4 oColor;

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}
float CalcShininess( vec3 v_origin, vec3 v_normal, vec3 l_origin )
{
	vec3 halfVec = normalize(l_origin - v_origin);
	return max(dot(halfVec, v_normal), 0.0);
}

float CalcSpecular( vec3 v_origin, vec3 v_normal, vec3 lightDir, float specularStrength )
{
	// Eye vector (towards the camera)
	// All coordinates are in eye space
	vec3 eyeVec = normalize( -v_origin );
	
	// Direction in which the triangle reflects the light
	vec3 reflectVec = reflect( lightDir, v_normal );
	
	// Cosine of the angle between the Eye vector and the Reflect vector,
	// clamped to 0
	//  - Looking into the reflection -> 1
	//  - Looking elsewhere -> < 1
	float cosAlpha = clamp( dot( eyeVec, reflectVec ), 0,1 );	
	
	// Currently specular color is light color times two
	return pow( cosAlpha, phongexponent ) * specularStrength;
}

vec4 GetLightmappedSpecular( vec3 v_origin, vec3 v_normal, float specularStrength )
{
	// Get light vector from lightmap
	vec3 lightDir = (2.0 * texture2D(lightvecsMap, ps_lightcoords).xyz) - 1.0;
	lightDir = normalize(lightDir);

	// Get diffuse light component
	vec4 lightDiffuse = texture2D(diffuseMap, ps_lightcoords);
	
	// Add specular if any
	mat3 tbnMatrix = mat3(ps_tangent, ps_binormal, ps_normal);
	vec3 eyeSpaceDir = normalize(tbnMatrix * vec3(lightDir[0], -lightDir[1], lightDir[2]));
	
	float shineFactor = CalcShininess(normalize(v_origin), v_normal, eyeSpaceDir);
	float specularValue = CalcSpecular(v_origin, v_normal, -eyeSpaceDir, specularStrength);
	
	vec4 finalColor = specularValue * lightDiffuse * shineFactor;
	return finalColor;
}
vec4 GetUnderwaterRefracton( vec3 v_origin, vec3 v_normal, float specularStrength )
{
	// Get light vector from lightmap
	vec3 lightDir = (2.0 * texture2D(lightvecsMap, ps_lightcoords).xyz) - 1.0;
	lightDir = normalize(lightDir);

	// Get diffuse light component
	vec4 lightDiffuse = texture2D(diffuseMap, ps_lightcoords);

	// Add specular if any
	mat3 tbnMatrix = mat3(ps_tangent, ps_binormal, ps_normal);
	vec3 eyeSpaceDir = normalize(tbnMatrix * vec3(lightDir[0], -lightDir[1], lightDir[2]));
	
	float shineFactor = CalcShininess(normalize(v_origin), v_normal, eyeSpaceDir);
	
	// Eye vector (towards the camera)
	// All coordinates are in eye space
	vec3 eyeVec = normalize( v_origin );	
	
	float cosAlpha = clamp( dot( eyeSpaceDir, v_normal ), 0,1 );	
	float specularValue = pow( cosAlpha, phongexponent ) * specularStrength;
	specularValue *= clamp( dot( eyeSpaceDir, eyeVec ), 0,1 );
	
	vec4 finalColor = specularValue * lightDiffuse * shineFactor;
	return finalColor;
}
void main()
{
	vec4 finalColor;

	vec2 texcoord = ps_texcoords + scroll;

	vec2 texc0 = vec2(texcoord.x+time*0.20, texcoord.y+time*0.15);
	vec2 texc1 = vec2(texcoord.x-time*0.13, texcoord.y+time*0.11);

	vec4 norm1 = texture(normalMap, texc0);
	vec4 norm2 = texture(normalMap, texc1);

	vec2 texc2 = vec2(texcoord.x+time*0.17, texcoord.y+time*0.15);
	vec2 texc3 = vec2(texcoord.x-time*0.14, texcoord.y-time*0.16);

	vec4 norm3 = texture(normalMap, texc2);
	vec4 norm4 = texture(normalMap, texc3);	

	vec3 norm_combine = normalize((norm1*0.25 + norm2*0.25 + norm3*0.25 + norm4*0.25).xyz * 2.0 - 1.0);

	vec2 coordUV1 = (ps_screencoords.xy / (2*ps_screencoords.w) ) + 0.5 + norm_combine.xy*0.1*strength;
		coordUV1 *= rectscale;
			vec4 refractcolor = texture(rectangleRefractMap, coordUV1);
		vec4 lightmapcolor = texture(lightMap, ps_lightcoords);
		finalColor = refractcolor + lightmapcolor * lightstrength;
		
		vec3 vnormal_texture = normalize((normalmatrix*vec4(norm_combine, 0)).xyz);
			finalColor += GetUnderwaterRefracton( ps_eyecoords, vnormal_texture, specularstrength );
		float fogcoord = length(ps_eyecoords);
		
		float fogfactor = (fogparams.x - fogcoord)*fogparams.y;
		fogfactor = 1.0-SplineFraction(clamp(fogfactor, 0.0, 1.0), 1.0);
		
		finalColor.xyz = mix(finalColor.xyz, fogcolor, fogfactor);
	oColor = finalColor;
}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 normalmatrix_v;

uniform float texscale;

in vec4 in_position;
in vec2 in_texcoords;
in vec2 in_lightcoords;
in vec3 in_tangent;
in vec3 in_binormal;
in vec3 in_normal;

out vec4 ps_screencoords;
out vec3 ps_eyecoords;
out vec2 ps_texcoords;
out vec2 ps_lightcoords;

out vec3 ps_tangent;
	out vec3 ps_binormal;
	out vec3 ps_normal;
void main()
{
	vec4 position = in_position*modelview;
	vec4 eye_position = position*projection;

	ps_screencoords = eye_position;
	ps_eyecoords = position.xyz;

	ps_tangent = (normalmatrix_v*vec4(in_tangent, 0.0)).xyz;
		ps_binormal = (normalmatrix_v*vec4(in_binormal, 0.0)).xyz;
		ps_normal = (normalmatrix_v*vec4(in_normal, 0.0)).xyz;
	ps_texcoords.x = in_texcoords.x*texscale;
	ps_texcoords.y = in_texcoords.y*texscale;
	
	ps_lightcoords = in_lightcoords;
	gl_Position = eye_position;
}
#version 130

uniform sampler2D normalMap;
uniform sampler2D lightMap;
uniform sampler2D refractMap;
uniform sampler2D reflectMap;
uniform sampler2DRect rectangleRefractMap;
uniform sampler2D diffuseMap;
uniform sampler2D lightvecsMap;

uniform mat4 normalmatrix;

uniform vec3 fogcolor;
uniform vec2 fogparams;

uniform float fresnel;
uniform float time;
uniform float strength;
uniform float lightstrength;
uniform float specularstrength;
uniform float phongexponent;

uniform vec2 scroll;
uniform vec2 rectscale;

in vec4 ps_screencoords;
in vec3 ps_eyecoords;
in vec2 ps_texcoords;
in vec2 ps_lightcoords;

in vec3 ps_tangent;
	in vec3 ps_binormal;
	in vec3 ps_normal;
out vec4 oColor;

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}
float CalcShininess( vec3 v_origin, vec3 v_normal, vec3 l_origin )
{
	vec3 halfVec = normalize(l_origin - v_origin);
	return max(dot(halfVec, v_normal), 0.0);
}

float CalcSpecular( vec3 v_origin, vec3 v_normal, vec3 lightDir, float specularStrength )
{
	// Eye vector (towards the camera)
	// All coordinates are in eye space
	vec3 eyeVec = normalize( -v_origin );
	
	// Direction in which the triangle reflects the light
	vec3 reflectVec = reflect( lightDir, v_normal );
	
	// Cosine of the angle between the Eye vector and the Reflect vector,
	// clamped to 0
	//  - Looking into the reflection -> 1
	//  - Looking elsewhere -> < 1
	float cosAlpha = clamp( dot( eyeVec, reflectVec ), 0,1 );	
	
	// Currently specular color is light color times two
	return pow( cosAlpha, phongexponent ) * specularStrength;
}

vec4 GetLightmappedSpecular( vec3 v_origin, vec3 v_normal, float specularStrength )
{
	// Get light vector from lightmap
	vec3 lightDir = (2.0 * texture2D(lightvecsMap, ps_lightcoords).xyz) - 1.0;
	lightDir = normalize(lightDir);

	// Get diffuse light component
	vec4 lightDiffuse = texture2D(diffuseMap, ps_lightcoords);
	
	// Add specular if any
	mat3 tbnMatrix = mat3(ps_tangent, ps_binormal, ps_normal);
	vec3 eyeSpaceDir = normalize(tbnMatrix * vec3(lightDir[0], -lightDir[1], lightDir[2]));
	
	float shineFactor = CalcShininess(normalize(v_origin), v_normal, eyeSpaceDir);
	float specularValue = CalcSpecular(v_origin, v_normal, -eyeSpaceDir, specularStrength);
	
	vec4 finalColor = specularValue * lightDiffuse * shineFactor;
	return finalColor;
}
vec4 GetUnderwaterRefracton( vec3 v_origin, vec3 v_normal, float specularStrength )
{
	// Get light vector from lightmap
	vec3 lightDir = (2.0 * texture2D(lightvecsMap, ps_lightcoords).xyz) - 1.0;
	lightDir = normalize(lightDir);

	// Get diffuse light component
	vec4 lightDiffuse = texture2D(diffuseMap, ps_lightcoords);

	// Add specular if any
	mat3 tbnMatrix = mat3(ps_tangent, ps_binormal, ps_normal);
	vec3 eyeSpaceDir = normalize(tbnMatrix * vec3(lightDir[0], -lightDir[1], lightDir[2]));
	
	float shineFactor = CalcShininess(normalize(v_origin), v_normal, eyeSpaceDir);
	
	// Eye vector (towards the camera)
	// All coordinates are in eye space
	vec3 eyeVec = normalize( v_origin );	
	
	float cosAlpha = clamp( dot( eyeSpaceDir, v_normal ), 0,1 );	
	float specularValue = pow( cosAlpha, phongexponent ) * specularStrength;
	specularValue *= clamp( dot( eyeSpaceDir, eyeVec ), 0,1 );
	
	vec4 finalColor = specularValue * lightDiffuse * shineFactor;
	return finalColor;
}
void main()
{
	vec4 finalColor;

	vec2 texcoord = ps_texcoords + scroll;

	vec2 texc0 = vec2(texcoord.x+time*0.20, texcoord.y+time*0.15);
	vec2 texc1 = vec2(texcoord.x-time*0.13, texcoord.y+time*0.11);

	vec4 norm1 = texture(normalMap, texc0);
	vec4 norm2 = texture(normalMap, texc1);

	vec2 texc2 = vec2(texcoord.x+time*0.17, texcoord.y+time*0.15);
	vec2 texc3 = vec2(texcoord.x-time*0.14, texcoord.y-time*0.16);

	vec4 norm3 = texture(normalMap, texc2);
	vec4 norm4 = texture(normalMap, texc3);	

	vec3 norm_combine = normalize((norm1*0.25 + norm2*0.25 + norm3*0.25 + norm4*0.25).xyz * 2.0 - 1.0);

	vec2 coordUV1 = (ps_screencoords.xy / (2*ps_screencoords.w) ) + 0.5 + norm_combine.xy*0.1*strength;
		vec4 refractcolor = texture(refractMap, coordUV1);
		vec2 coordUV2 = (vec2(ps_screencoords.x, -ps_screencoords.y) / (2*ps_screencoords.w) ) + 0.5 + norm_combine.xy*0.1*strength;
		vec4 reflectcolor = texture(reflectMap, coordUV2);

		vec3 vnormal_texture = normalize((normalmatrix*vec4(norm_combine, 0)).xyz);
		vec3 vnormal = normalize((normalmatrix*vec4(0, 0, 1, 0)).xyz);
		
		float fresnelterm = clamp(dot(-normalize(ps_eyecoords), vnormal_texture)*1.3*fresnel, 0.0, 0.97 );
		vec4 combinedColor = mix(reflectcolor, refractcolor, fresnelterm);

		vec4 lightmapcolor = texture(lightMap, ps_lightcoords);
		finalColor = combinedColor + lightmapcolor * lightstrength;
		
		finalColor += GetLightmappedSpecular( ps_eyecoords, vnormal_texture, specularstrength );
		float fogcoord = length(ps_eyecoords);
		
		float fogfactor = (fogparams.x - fogcoord)*fogparams.y;
		fogfactor = 1.0-SplineFraction(clamp(fogfactor, 0.0, 1.0), 1.0);
		
		finalColor.xyz = mix(finalColor.xyz, fogcolor, fogfactor);
	oColor = finalColor;
}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

uniform mat4 normalmatrix_v;

uniform float texscale;

in vec4 in_position;
in vec2 in_texcoords;
in vec2 in_lightcoords;
in vec3 in_tangent;
in vec3 in_binormal;
in vec3 in_normal;

out vec4 ps_screencoords;
out vec3 ps_eyecoords;
out vec2 ps_texcoords;
out vec2 ps_lightcoords;

out vec3 ps_tangent;
	out vec3 ps_binormal;
	out vec3 ps_normal;
void main()
{
	vec4 position = in_position*modelview;
	vec4 eye_position = position*projection;

	ps_screencoords = eye_position;
	ps_eyecoords = position.xyz;

	ps_tangent = (normalmatrix_v*vec4(in_tangent, 0.0)).xyz;
		ps_binormal = (normalmatrix_v*vec4(in_binormal, 0.0)).xyz;
		ps_normal = (normalmatrix_v*vec4(in_normal, 0.0)).xyz;
	ps_texcoords.x = in_texcoords.x*texscale;
	ps_texcoords.y = in_texcoords.y*texscale;
	
	ps_lightcoords = in_lightcoords;
	gl_Position = eye_position;
}
#version 130

uniform sampler2D normalMap;
uniform sampler2D lightMap;
uniform sampler2D refractMap;
uniform sampler2D reflectMap;
uniform sampler2DRect rectangleRefractMap;
uniform sampler2D diffuseMap;
uniform sampler2D lightvecsMap;

uniform mat4 normalmatrix;

uniform vec3 fogcolor;
uniform vec2 fogparams;

uniform float fresnel;
uniform float time;
uniform float strength;
uniform float lightstrength;
uniform float specularstrength;
uniform float phongexponent;

uniform vec2 scroll;
uniform vec2 rectscale;

in vec4 ps_screencoords;
in vec3 ps_eyecoords;
in vec2 ps_texcoords;
in vec2 ps_lightcoords;

in vec3 ps_tangent;
	in vec3 ps_binormal;
	in vec3 ps_normal;
out vec4 oColor;

float SplineFraction( float value, float scale )
{
	float valueSquared;

	value = scale * value;
	valueSquared = value * value;

	// Nice little ease-in, ease-out spline-like curve
	return 3 * valueSquared - 2 * valueSquared * value;
}
float CalcShininess( vec3 v_origin, vec3 v_normal, vec3 l_origin )
{
	vec3 halfVec = normalize(l_origin - v_origin);
	return max(dot(halfVec, v_normal), 0.0);
}

float CalcSpecular( vec3 v_origin, vec3 v_normal, vec3 lightDir, float specularStrength )
{
	// Eye vector (towards the camera)
	// All coordinates are in eye space
	vec3 eyeVec = normalize( -v_origin );
	
	// Direction in which the triangle reflects the light
	vec3 reflectVec = reflect( lightDir, v_normal );
	
	// Cosine of the angle between the Eye vector and the Reflect vector,
	// clamped to 0
	//  - Looking into the reflection -> 1
	//  - Looking elsewhere -> < 1
	float cosAlpha = clamp( dot( eyeVec, reflectVec ), 0,1 );	
	
	// Currently specular color is light color times two
	return pow( cosAlpha, phongexponent ) * specularStrength;
}

vec4 GetLightmappedSpecular( vec3 v_origin, vec3 v_normal, float specularStrength )
{
	// Get light vector from lightmap
	vec3 lightDir = (2.0 * texture2D(lightvecsMap, ps_lightcoords).xyz) - 1.0;
	lightDir = normalize(lightDir);

	// Get diffuse light component
	vec4 lightDiffuse = texture2D(diffuseMap, ps_lightcoords);
	
	// Add specular if any
	mat3 tbnMatrix = mat3(ps_tangent, ps_binormal, ps_normal);
	vec3 eyeSpaceDir = normalize(tbnMatrix * vec3(lightDir[0], -lightDir[1], lightDir[2]));
	
	float shineFactor = CalcShininess(normalize(v_origin), v_normal, eyeSpaceDir);
	float specularValue = CalcSpecular(v_origin, v_normal, -eyeSpaceDir, specularStrength);
	
	vec4 finalColor = specularValue * lightDiffuse * shineFactor;
	return finalColor;
}
vec4 GetUnderwaterRefracton( vec3 v_origin, vec3 v_normal, float specularStrength )
{
	// Get light vector from lightmap
	vec3 lightDir = (2.0 * texture2D(lightvecsMap, ps_lightcoords).xyz) - 1.0;
	lightDir = normalize(lightDir);

	// Get diffuse light component
	vec4 lightDiffuse = texture2D(diffuseMap, ps_lightcoords);

	// Add specular if any
	mat3 tbnMatrix = mat3(ps_tangent, ps_binormal, ps_normal);
	vec3 eyeSpaceDir = normalize(tbnMatrix * vec3(lightDir[0], -lightDir[1], lightDir[2]));
	
	float shineFactor = CalcShininess(normalize(v_origin), v_normal, eyeSpaceDir);
	
	// Eye vector (towards the camera)
	// All coordinates are in eye space
	vec3 eyeVec = normalize( v_origin );	
	
	float cosAlpha = clamp( dot( eyeSpaceDir, v_normal ), 0,1 );	
	float specularValue = pow( cosAlpha, phongexponent ) * specularStrength;
	specularValue *= clamp( dot( eyeSpaceDir, eyeVec ), 0,1 );
	
	vec4 finalColor = specularValue * lightDiffuse * shineFactor;
	return finalColor;
}
void main()
{
	vec4 finalColor;

	vec2 texcoord = ps_texcoords + scroll;

	vec2 texc0 = vec2(texcoord.x+time*0.20, texcoord.y+time*0.15);
	vec2 texc1 = vec2(texcoord.x-time*0.13, texcoord.y+time*0.11);

	vec4 norm1 = texture(normalMap, texc0);
	vec4 norm2 = texture(normalMap, texc1);

	vec2 texc2 = vec2(texcoord.x+time*0.17, texcoord.y+time*0.15);
	vec2 texc3 = vec2(texcoord.x-time*0.14, texcoord.y-time*0.16);

	vec4 norm3 = texture(normalMap, texc2);
	vec4 norm4 = texture(normalMap, texc3);	

	vec3 norm_combine = normalize((norm1*0.25 + norm2*0.25 + norm3*0.25 + norm4*0.25).xyz * 2.0 - 1.0);

	vec2 coordUV1 = (ps_screencoords.xy / (2*ps_screencoords.w) ) + 0.5 + norm_combine.xy*0.1*strength;
		coordUV1 *= rectscale;
			vec4 refractcolor = texture(rectangleRefractMap, coordUV1);
		vec2 coordUV2 = (vec2(ps_screencoords.x, -ps_screencoords.y) / (2*ps_screencoords.w) ) + 0.5 + norm_combine.xy*0.1*strength;
		vec4 reflectcolor = texture(reflectMap, coordUV2);

		vec3 vnormal_texture = normalize((normalmatrix*vec4(norm_combine, 0)).xyz);
		vec3 vnormal = normalize((normalmatrix*vec4(0, 0, 1, 0)).xyz);
		
		float fresnelterm = clamp(dot(-normalize(ps_eyecoords), vnormal_texture)*1.3*fresnel, 0.0, 0.97 );
		vec4 combinedColor = mix(reflectcolor, refractcolor, fresnelterm);

		vec4 lightmapcolor = texture(lightMap, ps_lightcoords);
		finalColor = combinedColor + lightmapcolor * lightstrength;
		
		finalColor += GetLightmappedSpecular( ps_eyecoords, vnormal_texture, specularstrength );
		float fogcoord = length(ps_eyecoords);
		
		float fogfactor = (fogparams.x - fogcoord)*fogparams.y;
		fogfactor = 1.0-SplineFraction(clamp(fogfactor, 0.0, 1.0), 1.0);
		
		finalColor.xyz = mix(finalColor.xyz, fogcolor, fogfactor);
	oColor = finalColor;
}
specular                           @        fog                                `        side                               �        rectrefract                        �                                                                                                        