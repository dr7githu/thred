﻿varying vec3 vWorldPosition;
varying vec3 vSunDirection;
varying float vSunfade;
varying vec3 vBetaR;
varying vec3 vBetaM;
varying float vSunE;

uniform float luminance;
uniform float mieDirectionalG;
uniform mat4  transmat;
uniform mat4 rotmat;

const vec3 cameraPos = vec3(0., 0., 0.);

// constants for atmospheric scattering
const float pi = 3.141592653589793238462643383279502884197169;

const float n = 1.0003; // refractive index of air
const float N = 2.545E25; // number of molecules per unit volume for air at
							// 288.15K and 1013mb (sea level -45 celsius)

// optical length at zenith for molecules
const float rayleighZenithLength = 8.4E3;
const float mieZenithLength = 1.25E3;
const vec3 up = vec3(0.0, 1.0, 0.0);

const float sunAngularDiameterCos = 0.999956676946448443553574619906976478926848692873900859324;
// 66 arc seconds -> degrees, and the cosine of that

float rayleighPhase(float cosTheta)
{
	return (3.0 / (16.0*pi)) * (1.0 + pow(cosTheta, 2.0));
}

float hgPhase(float cosTheta, float g)
{
	return (1.0 / (4.0*pi)) * ((1.0 - pow(g, 2.0)) / pow(1.0 - 2.0*g*cosTheta + pow(g, 2.0), 1.5));
}

// Filmic ToneMapping http://filmicgames.com/archives/75
const float A = 0.15;
const float B = 0.50;
const float C = 0.10;
const float D = 0.20;
const float E = 0.02;
const float F = 0.30;

const float whiteScale = 1.0748724675633854; // 1.0 / Uncharted2Tonemap(1000.0)

vec3 Uncharted2Tonemap(vec3 x)
{
	return ((x*(A*x+C*B)+D*E)/(x*(A*x+B)+D*F))-E/F;
}


void main() 
{
	// optical length
	// cutoff angle at 90 to avoid singularity in next formula.
	float zenithAngle = acos(max(0.0, dot(up, normalize(vWorldPosition - cameraPos))));
    
	float sR = rayleighZenithLength / (cos(zenithAngle) + 0.15 * pow(93.885 - ((zenithAngle * 180.0) / pi), -1.253));
	float sM = mieZenithLength / (cos(zenithAngle) + 0.15 * pow(93.885 - ((zenithAngle * 180.0) / pi), -1.253));

	// combined extinction factor
	vec3 Fex = exp(-(vBetaR * sR + vBetaM * sM));

	// in scattering
	float cosTheta = dot(normalize(vWorldPosition - cameraPos), vSunDirection);

	float rPhase = rayleighPhase(cosTheta*0.5+0.5);
	vec3 betaRTheta = vBetaR * rPhase;

	float mPhase = hgPhase(cosTheta, mieDirectionalG);
	vec3 betaMTheta = vBetaM * mPhase;

	vec3 Lin = pow(vSunE * ((betaRTheta + betaMTheta) / (vBetaR + vBetaM)) * (1.0 - Fex),vec3(1.5));
	Lin *= mix(vec3(1.0),pow(vSunE * ((betaRTheta + betaMTheta) / (vBetaR + vBetaM)) * Fex,vec3(1.0/2.0)),clamp(pow(1.0-dot(up, vSunDirection),5.0),0.0,1.0));

	//nightsky
	vec3 direction = normalize(vWorldPosition - cameraPos);
	float theta = acos(direction.y); // elevation --> y-axis, [-pi/2, pi/2]
	float phi = atan(direction.z, direction.x); // azimuth --> x-axis [-pi/2, pi/2]
	vec2 uv = vec2(phi, theta) / vec2(2.0*pi, pi) + vec2(0.5, 0.0);
	vec3 L0 = vec3(0.1) * Fex;

	// composition + solar disc
	float sundisk = smoothstep(sunAngularDiameterCos,sunAngularDiameterCos+0.00002,cosTheta);
	L0 += (vSunE * 19000.0 * Fex)*sundisk;

	vec3 texColor = (Lin+L0) * 0.04 + vec3(0.0, 0.0003, 0.00075);

	vec3 curr = Uncharted2Tonemap((log2(2.0/pow(luminance,4.0)))*texColor);
	vec3 color = curr*whiteScale;

	vec3 retColor = pow(color,vec3(1.0/(1.2+(1.2*vSunfade))));

	gl_FragColor.rgb = retColor;

	gl_FragColor.a = 1.0;

}