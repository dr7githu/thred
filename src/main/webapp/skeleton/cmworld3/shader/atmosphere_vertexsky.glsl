//
// Atmospheric scattering vertex shader
//
// Author: Sean O'Neil
//
// Copyright (c) 2004 Sean O'Neil
//
uniform vec3 v3RefCenter;
uniform vec3 v3LightPosition;	// The direction vector to the light source
uniform float fCameraHeight;	// The camera's current height
uniform float fCameraHeight2;	// fCameraHeight^2
uniform float fOuterRadius;		// The outer (atmosphere) radius
uniform float fOuterRadius2;	// fOuterRadius^2
uniform float fInnerRadius;		// The inner (planetary) radius
uniform float fInnerRadius2;	// fInnerRadius^2
uniform float fScale;			// 1 / (fOuterRadius - fInnerRadius)
uniform float fScaleDepth;		// The scale depth (i.e. the altitude at which the atmosphere's average density is found)
uniform float fScaleOverScaleDepth;	// fScale / fScaleDepth

const float Kr = 0.0025;
const float Km = 0.0015;
const float ESun = 15.0;

const float fKr4PI = Kr * 4.0 * 3.1415926536;
const float fKm4PI = Km * 4.0 * 3.1415926536;
const float fKmESun = Km * ESun;
const float fKrESun = Kr * ESun;
const vec3 v3InvWavelength = vec3(
    5.60204474633241,  // Red = 1.0 / Math.pow(0.650, 4.0)
    9.473284437923038, // Green = 1.0 / Math.pow(0.570, 4.0)
    19.643802610477206); // Blue = 1.0 / Math.pow(0.475, 4.0)
const float rayleighScaleDepth = 0.25;

const int nSamples = 2;
const float fSamples = 2.0;
varying vec3 v3Direction;
varying vec3 c0;
varying vec3 c1;

float scale(float fCos)
{
	float x = 1.0 - fCos;
	return fScaleDepth * exp(-0.00287 + x*(0.459 + x*(3.83 + x*(-6.80 + x*5.25))));
}
void main(void)
{
   ///////////////////////////////////////////////////
   vec3 cpos = cameraPosition + v3RefCenter;
   vec4 worldPosition = modelMatrix * vec4( position, 1.0 );
	vec3 pos = worldPosition.xyz + v3RefCenter;

   //vec3 pos = position.xyz;// + v3RefCenter;

	// Get the ray from the camera to the vertex and its length (which is the far point of the ray passing through the atmosphere)
	vec3 v3Ray = pos - cpos;
   
	float fFar = length(v3Ray);
	v3Ray /= fFar;


   // 대기 바깥이면

   vec3 v3Start;
   float fStartAngle;
   float fStartDepth;
   float fStartOffset;
   if(fCameraHeight > fOuterRadius)
   {
	   // Calculate the closest intersection of the ray with the outer atmosphere (which is the near point of the ray passing through the atmosphere)
	   float B = 2.0 * dot(cpos, v3Ray);
	   float C = fCameraHeight2 - fOuterRadius2;
	   float fDet = max(0.0, B*B - 4.0 * C);
	   float fNear = 0.5 * (-B - sqrt(fDet));
	   // Calculate the ray's starting position, then calculate its scattering offset
	   v3Start = cpos + v3Ray * fNear;
	   fFar -= fNear;

	   fStartAngle = dot(v3Ray, v3Start) / fOuterRadius;
	   fStartDepth = exp(-1.0 / fScaleDepth);
	   fStartOffset = fStartDepth * scale(fStartAngle);
   }
   else
   {
         v3Start = cpos;
         float fHeight = length(v3Start);
         float fDepth = exp(fScaleOverScaleDepth * (fInnerRadius - fCameraHeight));
         fStartAngle = dot(v3Ray, v3Start) / fHeight;
         fStartOffset = fDepth*scale(fStartAngle);
	   //c0 = vec3(1.0, 0, 0) * fStartAngle;
   }

	// Initialize the scattering loop variables
	float fSampleLength = fFar / fSamples;
	float fScaledLength = fSampleLength * fScale;

	vec3 v3SampleRay = v3Ray * fSampleLength;
	vec3 v3SamplePoint = v3Start + v3SampleRay * 0.5;
	//gl_FrontColor = vec4(0.0, 0.0, 0.0, 0.0);
	// Now loop through the sample rays
	vec3 v3FrontColor = vec3(0.0, 0.0, 0.0);

	for(int i=0; i<nSamples; i++)
	{
		float fHeight = length(v3SamplePoint);
		float fDepth = exp(fScaleOverScaleDepth * (fInnerRadius - fHeight));
		float fLightAngle = dot(v3LightPosition, v3SamplePoint) / fHeight;
		float fCameraAngle = dot(v3Ray, v3SamplePoint) / fHeight;
		float fScatter = (fStartOffset + fDepth * (scale(fLightAngle) - scale(fCameraAngle)));
		vec3 v3Attenuate = exp(-fScatter * (v3InvWavelength * fKr4PI + fKm4PI));
		v3FrontColor += v3Attenuate * (fDepth * fScaledLength);
		v3SamplePoint += v3SampleRay;
	}
	// Finally, scale the Mie and Rayleigh colors and set up the varying variables for the pixel shader
	gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );
	c0 = v3FrontColor * (v3InvWavelength * fKrESun);
	c1 = v3FrontColor * fKmESun;

   v3Direction = cpos - pos;
}