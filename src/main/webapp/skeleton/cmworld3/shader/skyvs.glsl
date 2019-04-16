uniform vec3 sunPosition;
uniform float rayleigh;
uniform float turbidity;
uniform float mieCoefficient;
uniform mat4 transmat;
uniform mat4 rotmat;
varying vec3 vWorldPosition;
varying vec3 vSunDirection;
varying float vSunfade;
varying vec3 vBetaR;
varying vec3 vBetaM;
varying float vSunE;

const vec3 up = vec3(0.0, 1.0, 0.0);

// constants for atmospheric scattering
const float e = 2.71828182845904523536028747135266249775724709369995957;
const float pi = 3.141592653589793238462643383279502884197169;

// mie stuff
// K coefficient for the primaries
const float v = 4.0;
const vec3 K = vec3(0.686, 0.678, 0.666);

// see http://blenderartists.org/forum/showthread.php?321110-Shaders-and-Skybox-madness
// A simplied version of the total Reayleigh scattering to works on browsers that use ANGLE
const vec3 simplifiedRayleigh = 0.0005 / vec3(94, 40, 18);

// wavelength of used primaries, according to preetham
const vec3 lambda = vec3(680E-9, 550E-9, 450E-9);

// earth shadow hack
const float cutoffAngle = pi/1.95;
const float steepness = 1.5;
const float EE = 1000.0;

float sunIntensity(float zenithAngleCos)
{
	zenithAngleCos = clamp(zenithAngleCos, -1.0, 1.0);
	return EE * max(0.0, 1.0 - pow(e, -((cutoffAngle - acos(zenithAngleCos))/steepness)));
}

vec3 totalMie(vec3 lambda, float T)
{
	float c = (0.2 * T ) * 10E-18;
	return 0.434 * c * pi * pow((2.0 * pi) / lambda, vec3(v - 2.0)) * K;
}


void main() 
{
   
	vec4 worldPosition = modelMatrix * transmat * rotmat * vec4( position, 1.0 );
	vWorldPosition = worldPosition.xyz;

	gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );

	vSunDirection = normalize(sunPosition);

	vSunE = sunIntensity(dot(vSunDirection, up));

	vSunfade = 1.0-clamp(1.0-exp((sunPosition.y/450000.0)),0.0,1.0);

	float rayleighCoefficient = rayleigh - (1.0 * (1.0-vSunfade));

	// extinction (absorbtion + out scattering)
	// rayleigh coefficients
	vBetaR = simplifiedRayleigh * rayleighCoefficient;

	// mie coefficients
	vBetaM = totalMie(lambda, turbidity) * mieCoefficient;
}