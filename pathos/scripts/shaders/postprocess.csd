CSD1   3db261ca629de2e505674c2f0cbd3a3c    ?'     @      '  �     �  z  E    P  �  �      �  �
    �  �  E    P  �  �      �           %    '&    #version 130

uniform mat4 projection;
uniform mat4 modelview;

in vec4 in_position;
in vec2 in_texcoord;

out vec2 ps_texcoord;

void main()
{
	ps_texcoord = in_texcoord;
	vec4 position = in_position*modelview;;
	gl_Position = position*projection;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2DRect texture0;
uniform vec4 color;
uniform float screenwidth;
uniform float screenheight;

uniform float gamma;
in vec2 ps_texcoord;
out vec4 oColor;

void main()
{
	vec4 color = texture(texture0, ps_texcoord);
		for(int i = 0; i < 4; i++)
			oColor[i] = pow(color[i], 1.0/gamma);
	}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

in vec4 in_position;
in vec2 in_texcoord;

out vec2 ps_texcoord;

void main()
{
	ps_texcoord = in_texcoord;
	vec4 position = in_position*modelview;;
	gl_Position = position*projection;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2DRect texture0;
uniform vec4 color;
uniform float screenwidth;
uniform float screenheight;

in vec2 ps_texcoord;
out vec4 oColor;

void main()
{
	float offset[5] = float[]( 0.0, 1.0, 2.0, 3.0, 4.0 );
		float weight[5] = float[]( 0.2270270270, 0.1945945946, 0.1216216216, 0.0540540541, 0.0162162162 );
	
		vec4 outcolor = texture(texture0, ps_texcoord)*weight[0];
		for(int i = 1; i < 5; i++)
		{
			outcolor += texture(texture0, ps_texcoord+vec2(offset[i], 0))*weight[i];
			outcolor += texture(texture0, ps_texcoord-vec2(offset[i], 0))*weight[i];
		}
		oColor = outcolor * color;
	}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

in vec4 in_position;
in vec2 in_texcoord;

out vec2 ps_texcoord;

void main()
{
	ps_texcoord = in_texcoord;
	vec4 position = in_position*modelview;;
	gl_Position = position*projection;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2DRect texture0;
uniform vec4 color;
uniform float screenwidth;
uniform float screenheight;

in vec2 ps_texcoord;
out vec4 oColor;

void main()
{
	float offset[5] = float[]( 0.0, 1.0, 2.0, 3.0, 4.0 );
		float weight[5] = float[]( 0.2270270270, 0.1945945946, 0.1216216216, 0.0540540541, 0.0162162162 );
	
		vec4 outcolor = texture(texture0, ps_texcoord)*weight[0];
		for(int i = 1; i < 5; i++)
		{
			outcolor += texture(texture0, ps_texcoord+vec2(0, offset[i]))*weight[i];
			outcolor += texture(texture0, ps_texcoord-vec2(0, offset[i]))*weight[i];
		}
		oColor = outcolor * color;
	}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

in vec4 in_position;
in vec2 in_texcoord;

out vec2 ps_texcoord;

void main()
{
	ps_texcoord = in_texcoord;
	vec4 position = in_position*modelview;;
	gl_Position = position*projection;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2DRect texture0;
uniform vec4 color;
uniform float screenwidth;
uniform float screenheight;

uniform float offset;
in vec2 ps_texcoord;
out vec4 oColor;

void main()
{
	vec2 texc = ps_texcoord;
		texc.x += (sin(texc.y * 0.03 + offset) * 10) * color.a;

		oColor = texture(texture0, texc) * color;
	}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

in vec4 in_position;
in vec2 in_texcoord;

out vec2 ps_texcoord;

void main()
{
	ps_texcoord = in_texcoord;
	vec4 position = in_position*modelview;;
	gl_Position = position*projection;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2DRect texture0;
uniform vec4 color;
uniform float screenwidth;
uniform float screenheight;

uniform sampler2DRect blurtexture;
in vec2 ps_texcoord;
out vec4 oColor;

void main()
{
	vec4 maintex = texture(texture0, ps_texcoord);
		vec4 blurtex = texture(blurtexture, ps_texcoord);
		oColor = maintex*(1.0-color.a)+blurtex*(color.a);
	}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

in vec4 in_position;
in vec2 in_texcoord;

out vec2 ps_texcoord;

void main()
{
	ps_texcoord = in_texcoord;
	vec4 position = in_position*modelview;;
	gl_Position = position*projection;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2DRect texture0;
uniform vec4 color;
uniform float screenwidth;
uniform float screenheight;

in vec2 ps_texcoord;
out vec4 oColor;

void main()
{
	oColor = color;
	}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

in vec4 in_position;
in vec2 in_texcoord;

out vec2 ps_texcoord;

void main()
{
	ps_texcoord = in_texcoord;
	vec4 position = in_position*modelview;;
	gl_Position = position*projection;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2DRect texture0;
uniform vec4 color;
uniform float screenwidth;
uniform float screenheight;

in vec2 ps_texcoord;
out vec4 oColor;

uniform float timer;

const float permTexUnit = 1.0/256.0;		// Perm texture texel-size
const float permTexUnitHalf = 0.5/256.0;	// Half perm texture texel-size

const float grainamount = 0.05; //grain amount
float grainsize = 1.6; //grain particle size (1.5 - 2.5)
float lumamount = 1.0; //
float coloramount = 0.6;

//a random texture generator, but you can also use a pre-computed perturbation texture
vec4 rnm(in vec2 tc) 
{
    float noise =  sin(dot(tc + vec2(timer,timer),vec2(12.9898,78.233))) * 43758.5453;

	float noiseR =  fract(noise)*2.0-1.0;
	float noiseG =  fract(noise*1.2154)*2.0-1.0; 
	float noiseB =  fract(noise*1.3453)*2.0-1.0;
	float noiseA =  fract(noise*1.3647)*2.0-1.0;
	
	return vec4(noiseR,noiseG,noiseB,noiseA);
}

float fade(in float t) {
	return t*t*t*(t*(t*6.0-15.0)+10.0);
}

float pnoise3D(in vec3 p)
{
	vec3 pi = permTexUnit*floor(p)+permTexUnitHalf; // Integer part, scaled so +1 moves permTexUnit texel
	// and offset 1/2 texel to sample texel centers
	vec3 pf = fract(p);     // Fractional part for interpolation

	// Noise contributions from (x=0, y=0), z=0 and z=1
	float perm00 = rnm(pi.xy).a ;
	vec3  grad000 = rnm(vec2(perm00, pi.z)).rgb * 4.0 - 1.0;
	float n000 = dot(grad000, pf);
	vec3  grad001 = rnm(vec2(perm00, pi.z + permTexUnit)).rgb * 4.0 - 1.0;
	float n001 = dot(grad001, pf - vec3(0.0, 0.0, 1.0));

	// Noise contributions from (x=0, y=1), z=0 and z=1
	float perm01 = rnm(pi.xy + vec2(0.0, permTexUnit)).a ;
	vec3  grad010 = rnm(vec2(perm01, pi.z)).rgb * 4.0 - 1.0;
	float n010 = dot(grad010, pf - vec3(0.0, 1.0, 0.0));
	vec3  grad011 = rnm(vec2(perm01, pi.z + permTexUnit)).rgb * 4.0 - 1.0;
	float n011 = dot(grad011, pf - vec3(0.0, 1.0, 1.0));

	// Noise contributions from (x=1, y=0), z=0 and z=1
	float perm10 = rnm(pi.xy + vec2(permTexUnit, 0.0)).a ;
	vec3  grad100 = rnm(vec2(perm10, pi.z)).rgb * 4.0 - 1.0;
	float n100 = dot(grad100, pf - vec3(1.0, 0.0, 0.0));
	vec3  grad101 = rnm(vec2(perm10, pi.z + permTexUnit)).rgb * 4.0 - 1.0;
	float n101 = dot(grad101, pf - vec3(1.0, 0.0, 1.0));

	// Noise contributions from (x=1, y=1), z=0 and z=1
	float perm11 = rnm(pi.xy + vec2(permTexUnit, permTexUnit)).a ;
	vec3  grad110 = rnm(vec2(perm11, pi.z)).rgb * 4.0 - 1.0;
	float n110 = dot(grad110, pf - vec3(1.0, 1.0, 0.0));
	vec3  grad111 = rnm(vec2(perm11, pi.z + permTexUnit)).rgb * 4.0 - 1.0;
	float n111 = dot(grad111, pf - vec3(1.0, 1.0, 1.0));

	// Blend contributions along x
	vec4 n_x = mix(vec4(n000, n001, n010, n011), vec4(n100, n101, n110, n111), fade(pf.x));

	// Blend contributions along y
	vec2 n_xy = mix(n_x.xy, n_x.zw, fade(pf.y));

	// Blend contributions along z
	float n_xyz = mix(n_xy.x, n_xy.y, fade(pf.z));

	// We're done, return the final noise value.
	return n_xyz;
}

//2d coordinate orientation thing
vec2 coordRot(in vec2 tc, in float angle)
{
	float aspect = screenwidth/screenheight;
	float rotX = ((tc.x*2.0-1.0)*aspect*cos(angle)) - ((tc.y*2.0-1.0)*sin(angle));
	float rotY = ((tc.y*2.0-1.0)*cos(angle)) + ((tc.x*2.0-1.0)*aspect*sin(angle));
	rotX = ((rotX/aspect)*0.5+0.5);
	rotY = rotY*0.5+0.5;
	return vec2(rotX,rotY);
}
void main()
{
	vec2 norm_texcoords = vec2(ps_texcoord.x/screenwidth, ps_texcoord.y/screenheight);
	
		vec3 rotOffset = vec3(1.425,3.892,5.835); //rotation offset values	
		vec2 rotCoordsR = coordRot(norm_texcoords, timer*0.25 + rotOffset.x);
		vec2 rotCoordsG = coordRot(norm_texcoords, timer*0.25 + rotOffset.y);
		vec2 rotCoordsB = coordRot(norm_texcoords, timer*0.25 + rotOffset.z);
		
		vec3 noise;
		noise.r = vec3(pnoise3D(vec3(rotCoordsR*vec2(screenwidth/grainsize,screenheight/grainsize),0.0))).r;
		noise.g = mix(noise.r,pnoise3D(vec3(rotCoordsG*vec2(screenwidth/grainsize,screenheight/grainsize),1.0)), coloramount);
		noise.b = mix(noise.r,pnoise3D(vec3(rotCoordsB*vec2(screenwidth/grainsize,screenheight/grainsize),2.0)), coloramount);
		
		vec3 col = texture(texture0, ps_texcoord).rgb;

		//noisiness response curve based on scene luminance
		vec3 lumcoeff = vec3(0.299,0.587,0.114);
		float luminance = mix(0.0,dot(col, lumcoeff),lumamount);
		luminance = clamp(luminance, 0.25, 0.75);
		float lum = smoothstep(0.2,0.0,luminance);
		lum += luminance;

		noise = mix(noise,vec3(0.0),pow(lum,4.0));
		col = col+noise*grainamount;
	   
		oColor =  vec4(col,1.0);	
	}
#version 130

uniform mat4 projection;
uniform mat4 modelview;

in vec4 in_position;
in vec2 in_texcoord;

out vec2 ps_texcoord;

void main()
{
	ps_texcoord = in_texcoord;
	vec4 position = in_position*modelview;;
	gl_Position = position*projection;
}
#version 130
#extension GL_ARB_texture_rectangle : enable

uniform sampler2DRect texture0;
uniform vec4 color;
uniform float screenwidth;
uniform float screenheight;

in vec2 ps_texcoord;
out vec4 oColor;

void main()
{
	oColor = texture(texture0, ps_texcoord);
	}
pp_type                            o'                  