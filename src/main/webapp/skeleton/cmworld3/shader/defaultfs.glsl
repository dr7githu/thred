#define PHONG

varying vec3 vWorldPos;

uniform vec3 diffuse;
uniform vec3 emissive;
uniform vec3 specular;
uniform float shininess;
uniform float opacity;

#define PI 3.14159265359
#define PI2 6.28318530718
#define PI_HALF 1.5707963267949
#define RECIPROCAL_PI 0.31830988618
#define RECIPROCAL_PI2 0.15915494
#define LOG2 1.442695
#define EPSILON 1e-6

#define saturate(a) clamp( a, 0.0, 1.0 )
#define whiteCompliment(a) ( 1.0 - saturate( a ) )

float pow2( const in float x ) { return x*x; }
float pow3( const in float x ) { return x*x*x; }
float pow4( const in float x ) { float x2 = x*x; return x2*x2; }
float average( const in vec3 color ) { return dot( color, vec3( 0.3333 ) ); }
// expects values in the range of [0,1]x[0,1], returns values in the [0,1] range.
// do not collapse into a single function per: http://byteblacksmith.com/improvements-to-the-canonical-one-liner-glsl-rand-for-opengl-es-2-0/
highp float rand( const in vec2 uv ) {
	const highp float a = 12.9898, b = 78.233, c = 43758.5453;
	highp float dt = dot( uv.xy, vec2( a,b ) ), sn = mod( dt, PI );
	return fract(sin(sn) * c);
}

struct IncidentLight {
	vec3 color;
	vec3 direction;
	bool visible;
};

struct ReflectedLight {
	vec3 directDiffuse;
	vec3 directSpecular;
	vec3 indirectDiffuse;
	vec3 indirectSpecular;
};

struct GeometricContext {
	vec3 position;
	vec3 normal;
	vec3 viewDir;
};

vec3 transformDirection( in vec3 dir, in mat4 matrix ) {

	return normalize( ( matrix * vec4( dir, 0.0 ) ).xyz );

}

// http://en.wikibooks.org/wiki/GLSL_Programming/Applying_Matrix_Transformations
vec3 inverseTransformDirection( in vec3 dir, in mat4 matrix ) {

	return normalize( ( vec4( dir, 0.0 ) * matrix ).xyz );

}

vec3 projectOnPlane(in vec3 point, in vec3 pointOnPlane, in vec3 planeNormal ) {

	float distance = dot( planeNormal, point - pointOnPlane );

	return - distance * planeNormal + point;

}

float sideOfPlane( in vec3 point, in vec3 pointOnPlane, in vec3 planeNormal ) {

	return sign( dot( point - pointOnPlane, planeNormal ) );

}

vec3 linePlaneIntersect( in vec3 pointOnLine, in vec3 lineDirection, in vec3 pointOnPlane, in vec3 planeNormal ) {

	return lineDirection * ( dot( planeNormal, pointOnPlane - pointOnLine ) / dot( planeNormal, lineDirection ) ) + pointOnLine;

}

mat3 transpose( const in mat3 v ) {

	mat3 tmp;
	tmp[0] = vec3(v[0].x, v[1].x, v[2].x);
	tmp[1] = vec3(v[0].y, v[1].y, v[2].y);
	tmp[2] = vec3(v[0].z, v[1].z, v[2].z);

	return tmp;

}

vec3 packNormalToRGB( const in vec3 normal ) {
  return normalize( normal ) * 0.5 + 0.5;
}

vec3 unpackRGBToNormal( const in vec3 rgb ) {
  return 1.0 - 2.0 * rgb.xyz;
}

const float PackUpscale = 256. / 255.; // fraction -> 0..1 (including 1)
const float UnpackDownscale = 255. / 256.; // 0..1 -> fraction (excluding 1)

const vec3 PackFactors = vec3( 256. * 256. * 256., 256. * 256.,  256. );
const vec4 UnpackFactors = UnpackDownscale / vec4( PackFactors, 1. );

const float ShiftRight8 = 1. / 256.;

vec4 packDepthToRGBA( const in float v ) {

	vec4 r = vec4( fract( v * PackFactors ), v );
	r.yzw -= r.xyz * ShiftRight8; // tidy overflow
	return r * PackUpscale;

}

float unpackRGBAToDepth( const in vec4 v ) {

	return dot( v, UnpackFactors );

}

// NOTE: viewZ/eyeZ is < 0 when in front of the camera per OpenGL conventions

float viewZToOrthographicDepth( const in float viewZ, const in float near, const in float far ) {
  return ( viewZ + near ) / ( near - far );
}
float orthographicDepthToViewZ( const in float linearClipZ, const in float near, const in float far ) {
  return linearClipZ * ( near - far ) - near;
}

float viewZToPerspectiveDepth( const in float viewZ, const in float near, const in float far ) {
  return (( near + viewZ ) * far ) / (( far - near ) * viewZ );
}
float perspectiveDepthToViewZ( const in float invClipZ, const in float near, const in float far ) {
  return ( near * far ) / ( ( far - near ) * invClipZ - far );
}
#ifdef USE_COLOR

	varying vec3 vColor;

#endif
#if defined( USE_MAP ) 

	varying vec2 vUv;

#endif

#ifdef USE_MAP

	uniform sampler2D map;

#endif
#ifdef USE_OVERLAYMAP
   uniform sampler2D overlaymap;
#endif

#ifdef USE_DYNAMICTOPMAP
   uniform sampler2D dynamictopmap;
#endif

#ifdef USE_FOG

	uniform vec3 fogColor;

	#ifdef FOG_EXP2

		uniform float fogDensity;

	#else

		uniform float fogNear;
		uniform float fogFar;
	#endif

#endif
float punctualLightIntensityToIrradianceFactor( const in float lightDistance, const in float cutoffDistance, const in float decayExponent ) {

		if( decayExponent > 0.0 ) {

#if defined ( PHYSICALLY_CORRECT_LIGHTS )

			// based upon Frostbite 3 Moving to Physically-based Rendering
			// page 32, equation 26: E[window1]
			// http://www.frostbite.com/wp-content/uploads/2014/11/course_notes_moving_frostbite_to_pbr_v2.pdf
			// this is intended to be used on spot and point lights who are represented as luminous intensity
			// but who must be converted to luminous irradiance for surface lighting calculation
			float distanceFalloff = 1.0 / max( pow( lightDistance, decayExponent ), 0.01 );
			float maxDistanceCutoffFactor = pow2( saturate( 1.0 - pow4( lightDistance / cutoffDistance ) ) );
			return distanceFalloff * maxDistanceCutoffFactor;

#else

			return pow( saturate( -lightDistance / cutoffDistance + 1.0 ), decayExponent );

#endif

		}

		return 1.0;
}

vec3 BRDF_Diffuse_Lambert( const in vec3 diffuseColor ) {

	return RECIPROCAL_PI * diffuseColor;

} // validated


vec3 F_Schlick( const in vec3 specularColor, const in float dotLH ) {

	// Original approximation by Christophe Schlick '94
	//;float fresnel = pow( 1.0 - dotLH, 5.0 );

	// Optimized variant (presented by Epic at SIGGRAPH '13)
	float fresnel = exp2( ( -5.55473 * dotLH - 6.98316 ) * dotLH );

	return ( 1.0 - specularColor ) * fresnel + specularColor;

} // validated


// Microfacet Models for Refraction through Rough Surfaces - equation (34)
// http://graphicrants.blogspot.com/2013/08/specular-brdf-reference.html
// alpha is "roughness squared" in Disney’s reparameterization
float G_GGX_Smith( const in float alpha, const in float dotNL, const in float dotNV ) {

	// geometry term = G(l)⋅G(v) / 4(n⋅l)(n⋅v)

	float a2 = pow2( alpha );

	float gl = dotNL + sqrt( a2 + ( 1.0 - a2 ) * pow2( dotNL ) );
	float gv = dotNV + sqrt( a2 + ( 1.0 - a2 ) * pow2( dotNV ) );

	return 1.0 / ( gl * gv );

} // validated

// from page 12, listing 2 of http://www.frostbite.com/wp-content/uploads/2014/11/course_notes_moving_frostbite_to_pbr_v2.pdf
float G_GGX_SmithCorrelated( const in float alpha, const in float dotNL, const in float dotNV ) {

	float a2 = pow2( alpha );

	// dotNL and dotNV are explicitly swapped. This is not a mistake.
	float gv = dotNL * sqrt( a2 + ( 1.0 - a2 ) * pow2( dotNV ) );
	float gl = dotNV * sqrt( a2 + ( 1.0 - a2 ) * pow2( dotNL ) );

	return 0.5 / max( gv + gl, EPSILON );
}



// Microfacet Models for Refraction through Rough Surfaces - equation (33)
// http://graphicrants.blogspot.com/2013/08/specular-brdf-reference.html
// alpha is "roughness squared" in Disney’s reparameterization
float D_GGX( const in float alpha, const in float dotNH ) {

	float a2 = pow2( alpha );

	float denom = pow2( dotNH ) * ( a2 - 1.0 ) + 1.0; // avoid alpha = 0 with dotNH = 1

	return RECIPROCAL_PI * a2 / pow2( denom );

}


// GGX Distribution, Schlick Fresnel, GGX-Smith Visibility
vec3 BRDF_Specular_GGX( const in IncidentLight incidentLight, const in GeometricContext geometry, const in vec3 specularColor, const in float roughness ) {

	float alpha = pow2( roughness ); // UE4's roughness

	vec3 halfDir = normalize( incidentLight.direction + geometry.viewDir );

	float dotNL = saturate( dot( geometry.normal, incidentLight.direction ) );
	float dotNV = saturate( dot( geometry.normal, geometry.viewDir ) );
	float dotNH = saturate( dot( geometry.normal, halfDir ) );
	float dotLH = saturate( dot( incidentLight.direction, halfDir ) );

	vec3 F = F_Schlick( specularColor, dotLH );

	float G = G_GGX_SmithCorrelated( alpha, dotNL, dotNV );

	float D = D_GGX( alpha, dotNH );

	return F * ( G * D );

} // validated

//
// Rect Area Light BRDF Approximations
//

// Area light computation code adapted from:
// http://blog.selfshadow.com/sandbox/ltc.html
//
// Based on paper:
// Real-Time Polygonal-Light Shading with Linearly Transformed Cosines
// By: Eric Heitz, Jonathan Dupuy, Stephen Hill and David Neubelt
// https://eheitzresearch.wordpress.com/415-2/

vec2 ltcTextureCoords( const in GeometricContext geometry, const in float roughness ) {

	const float LUT_SIZE  = 64.0;
	const float LUT_SCALE = (LUT_SIZE - 1.0)/LUT_SIZE;
	const float LUT_BIAS  = 0.5/LUT_SIZE;

	vec3 N = geometry.normal;
	vec3 V = geometry.viewDir;
	vec3 P = geometry.position;

	// view angle on surface determines which LTC BRDF values we use
	float theta = acos( dot( N, V ) );

	// Parameterization of texture:
	// sqrt(roughness) -> [0,1]
	// theta -> [0, PI/2]
	vec2 uv = vec2(
		sqrt( saturate( roughness ) ),
		saturate( theta / ( 0.5 * PI ) ) );

	// Ensure we don't have nonlinearities at the look-up table's edges
	// see: http://http.developer.nvidia.com/GPUGems2/gpugems2_chapter24.html
	//      "Shader Analysis" section
	uv = uv * LUT_SCALE + LUT_BIAS;

	return uv;

}

void clipQuadToHorizon( inout vec3 L[5], out int n ) {

	// detect clipping config
	int config = 0;
	if ( L[0].z > 0.0 ) config += 1;
	if ( L[1].z > 0.0 ) config += 2;
	if ( L[2].z > 0.0 ) config += 4;
	if ( L[3].z > 0.0 ) config += 8;

	// clip
	n = 0;

	if ( config == 0 ) {

		// clip all

	} else if ( config == 1 ) {

		// V1 clip V2 V3 V4
		n = 3;
		L[1] = -L[1].z * L[0] + L[0].z * L[1];
		L[2] = -L[3].z * L[0] + L[0].z * L[3];

	} else if ( config == 2 ) {

		// V2 clip V1 V3 V4
		n = 3;
		L[0] = -L[0].z * L[1] + L[1].z * L[0];
		L[2] = -L[2].z * L[1] + L[1].z * L[2];

	} else if ( config == 3 ) {

		// V1 V2 clip V3 V4
		n = 4;
		L[2] = -L[2].z * L[1] + L[1].z * L[2];
		L[3] = -L[3].z * L[0] + L[0].z * L[3];

	} else if ( config == 4 ) {

		// V3 clip V1 V2 V4
		n = 3;
		L[0] = -L[3].z * L[2] + L[2].z * L[3];
		L[1] = -L[1].z * L[2] + L[2].z * L[1];

	} else if ( config == 5 ) {

		// V1 V3 clip V2 V4) impossible
		n = 0;

	} else if ( config == 6 ) {

		// V2 V3 clip V1 V4
		n = 4;
		L[0] = -L[0].z * L[1] + L[1].z * L[0];
		L[3] = -L[3].z * L[2] + L[2].z * L[3];

	} else if ( config == 7 ) {

		// V1 V2 V3 clip V4
		n = 5;
		L[4] = -L[3].z * L[0] + L[0].z * L[3];
		L[3] = -L[3].z * L[2] + L[2].z * L[3];

	} else if ( config == 8 ) {

		// V4 clip V1 V2 V3
		n = 3;
		L[0] = -L[0].z * L[3] + L[3].z * L[0];
		L[1] = -L[2].z * L[3] + L[3].z * L[2];
		L[2] =  L[3];

	} else if ( config == 9 ) {

		// V1 V4 clip V2 V3
		n = 4;
		L[1] = -L[1].z * L[0] + L[0].z * L[1];
		L[2] = -L[2].z * L[3] + L[3].z * L[2];

	} else if ( config == 10 ) {

		// V2 V4 clip V1 V3) impossible
		n = 0;

	} else if ( config == 11 ) {

		// V1 V2 V4 clip V3
		n = 5;
		L[4] = L[3];
		L[3] = -L[2].z * L[3] + L[3].z * L[2];
		L[2] = -L[2].z * L[1] + L[1].z * L[2];

	} else if ( config == 12 ) {

		// V3 V4 clip V1 V2
		n = 4;
		L[1] = -L[1].z * L[2] + L[2].z * L[1];
		L[0] = -L[0].z * L[3] + L[3].z * L[0];

	} else if ( config == 13 ) {

		// V1 V3 V4 clip V2
		n = 5;
		L[4] = L[3];
		L[3] = L[2];
		L[2] = -L[1].z * L[2] + L[2].z * L[1];
		L[1] = -L[1].z * L[0] + L[0].z * L[1];

	} else if ( config == 14 ) {

		// V2 V3 V4 clip V1
		n = 5;
		L[4] = -L[0].z * L[3] + L[3].z * L[0];
		L[0] = -L[0].z * L[1] + L[1].z * L[0];

	} else if ( config == 15 ) {

		// V1 V2 V3 V4
		n = 4;

	}

	if ( n == 3 )
		L[3] = L[0];
	if ( n == 4 )
		L[4] = L[0];

}

// Equation (11) of "Real-Time Polygonal-Light Shading with Linearly Transformed Cosines"
float integrateLtcBrdfOverRectEdge( vec3 v1, vec3 v2 ) {

	float cosTheta = dot( v1, v2 );
	float theta = acos( cosTheta );
	float res = cross( v1, v2 ).z * ( ( theta > 0.001 ) ? theta / sin( theta ) : 1.0 );

	return res;

}

void initRectPoints( const in vec3 pos, const in vec3 halfWidth, const in vec3 halfHeight, out vec3 rectPoints[4] ) {

	rectPoints[0] = pos - halfWidth - halfHeight;
	rectPoints[1] = pos + halfWidth - halfHeight;
	rectPoints[2] = pos + halfWidth + halfHeight;
	rectPoints[3] = pos - halfWidth + halfHeight;

}

vec3 integrateLtcBrdfOverRect( const in GeometricContext geometry, const in mat3 brdfMat, const in vec3 rectPoints[4] ) {

	vec3 N = geometry.normal;
	vec3 V = geometry.viewDir;
	vec3 P = geometry.position;

	// construct orthonormal basis around N
	vec3 T1, T2;
	T1 = normalize(V - N * dot( V, N ));
	// TODO (abelnation): I had to negate this cross product to get proper light.  Curious why sample code worked without negation
	T2 = - cross( N, T1 );

	// rotate area light in (T1, T2, N) basis
	mat3 brdfWrtSurface = brdfMat * transpose( mat3( T1, T2, N ) );

	// transformed rect relative to surface point
	vec3 clippedRect[5];
	clippedRect[0] = brdfWrtSurface * ( rectPoints[0] - P );
	clippedRect[1] = brdfWrtSurface * ( rectPoints[1] - P );
	clippedRect[2] = brdfWrtSurface * ( rectPoints[2] - P );
	clippedRect[3] = brdfWrtSurface * ( rectPoints[3] - P );

	// clip light rect to horizon, resulting in at most 5 points
	// we do this because we are integrating the BRDF over the hemisphere centered on the surface points normal
	int n;
	clipQuadToHorizon(clippedRect, n);

	// light is completely below horizon
	if ( n == 0 )
		return vec3( 0, 0, 0 );

	// project clipped rect onto sphere
	clippedRect[0] = normalize( clippedRect[0] );
	clippedRect[1] = normalize( clippedRect[1] );
	clippedRect[2] = normalize( clippedRect[2] );
	clippedRect[3] = normalize( clippedRect[3] );
	clippedRect[4] = normalize( clippedRect[4] );

	// integrate
	// simplified integration only needs to be evaluated for each edge in the polygon
	float sum = 0.0;
	sum += integrateLtcBrdfOverRectEdge( clippedRect[0], clippedRect[1] );
	sum += integrateLtcBrdfOverRectEdge( clippedRect[1], clippedRect[2] );
	sum += integrateLtcBrdfOverRectEdge( clippedRect[2], clippedRect[3] );
	if (n >= 4)
		sum += integrateLtcBrdfOverRectEdge( clippedRect[3], clippedRect[4] );
	if (n == 5)
		sum += integrateLtcBrdfOverRectEdge( clippedRect[4], clippedRect[0] );

	// TODO (abelnation): two-sided area light
	// sum = twoSided ? abs(sum) : max(0.0, sum);
	sum = max( 0.0, sum );
	// sum = abs( sum );

	vec3 Lo_i = vec3( sum, sum, sum );

	return Lo_i;

}

vec3 Rect_Area_Light_Specular_Reflectance(
		const in GeometricContext geometry,
		const in vec3 lightPos, const in vec3 lightHalfWidth, const in vec3 lightHalfHeight,
		const in float roughness,
		const in sampler2D ltcMat, const in sampler2D ltcMag ) {

	vec3 rectPoints[4];
	initRectPoints( lightPos, lightHalfWidth, lightHalfHeight, rectPoints );

	vec2 uv = ltcTextureCoords( geometry, roughness );

	vec4 brdfLtcApproxParams, t;

	brdfLtcApproxParams = texture2D( ltcMat, uv );
	t = texture2D( ltcMat, uv );

	float brdfLtcScalar = texture2D( ltcMag, uv ).a;

	// inv(M) matrix referenced by equation (6) in paper
	mat3 brdfLtcApproxMat = mat3(
		vec3(   1,   0, t.y ),
		vec3(   0, t.z,   0 ),
		vec3( t.w,   0, t.x )
	);

	vec3 specularReflectance = integrateLtcBrdfOverRect( geometry, brdfLtcApproxMat, rectPoints );
	specularReflectance *= brdfLtcScalar;

	return specularReflectance;

}

vec3 Rect_Area_Light_Diffuse_Reflectance(
		const in GeometricContext geometry,
		const in vec3 lightPos, const in vec3 lightHalfWidth, const in vec3 lightHalfHeight ) {

	vec3 rectPoints[4];
	initRectPoints( lightPos, lightHalfWidth, lightHalfHeight, rectPoints );

	mat3 diffuseBrdfMat = mat3(1);
	vec3 diffuseReflectance = integrateLtcBrdfOverRect( geometry, diffuseBrdfMat, rectPoints );

	return diffuseReflectance;

}
// End RectArea BRDF

// ref: https://www.unrealengine.com/blog/physically-based-shading-on-mobile - environmentBRDF for GGX on mobile
vec3 BRDF_Specular_GGX_Environment( const in GeometricContext geometry, const in vec3 specularColor, const in float roughness ) {

	float dotNV = saturate( dot( geometry.normal, geometry.viewDir ) );

	const vec4 c0 = vec4( - 1, - 0.0275, - 0.572, 0.022 );

	const vec4 c1 = vec4( 1, 0.0425, 1.04, - 0.04 );

	vec4 r = roughness * c0 + c1;

	float a004 = min( r.x * r.x, exp2( - 9.28 * dotNV ) ) * r.x + r.y;

	vec2 AB = vec2( -1.04, 1.04 ) * a004 + r.zw;

	return specularColor * AB.x + AB.y;

} // validated


float G_BlinnPhong_Implicit( /* const in float dotNL, const in float dotNV */ ) {

	// geometry term is (n dot l)(n dot v) / 4(n dot l)(n dot v)
	return 0.25;

}

float D_BlinnPhong( const in float shininess, const in float dotNH ) {

	return RECIPROCAL_PI * ( shininess * 0.5 + 1.0 ) * pow( dotNH, shininess );

}

vec3 BRDF_Specular_BlinnPhong( const in IncidentLight incidentLight, const in GeometricContext geometry, const in vec3 specularColor, const in float shininess ) {

	vec3 halfDir = normalize( incidentLight.direction + geometry.viewDir );

	//float dotNL = saturate( dot( geometry.normal, incidentLight.direction ) );
	//float dotNV = saturate( dot( geometry.normal, geometry.viewDir ) );
	float dotNH = saturate( dot( geometry.normal, halfDir ) );
	float dotLH = saturate( dot( incidentLight.direction, halfDir ) );

	vec3 F = F_Schlick( specularColor, dotLH );

	float G = G_BlinnPhong_Implicit( /* dotNL, dotNV */ );

	float D = D_BlinnPhong( shininess, dotNH );

	return F * ( G * D );

} // validated

// source: http://simonstechblog.blogspot.ca/2011/12/microfacet-brdf.html
float GGXRoughnessToBlinnExponent( const in float ggxRoughness ) {
	return ( 2.0 / pow2( ggxRoughness + 0.0001 ) - 2.0 );
}

float BlinnExponentToGGXRoughness( const in float blinnExponent ) {
	return sqrt( 2.0 / ( blinnExponent + 2.0 ) );
}
uniform vec3 ambientLightColor;

vec3 getAmbientLightIrradiance( const in vec3 ambientLightColor ) {

	vec3 irradiance = ambientLightColor;

	#ifndef PHYSICALLY_CORRECT_LIGHTS

		irradiance *= PI;

	#endif

	return irradiance;

}

#if NUM_DIR_LIGHTS > 0

	struct DirectionalLight {
		vec3 direction;
		vec3 color;

		int shadow;
		float shadowBias;
		float shadowRadius;
		vec2 shadowMapSize;
	};

	uniform DirectionalLight directionalLights[ NUM_DIR_LIGHTS ];

	void getDirectionalDirectLightIrradiance( const in DirectionalLight directionalLight, const in GeometricContext geometry, out IncidentLight directLight ) {

		directLight.color = directionalLight.color;
		directLight.direction = directionalLight.direction;
		directLight.visible = true;
	}

#endif


#if NUM_POINT_LIGHTS > 0

	struct PointLight {
		vec3 position;
		vec3 color;
		float distance;
		float decay;

		int shadow;
		float shadowBias;
		float shadowRadius;
		vec2 shadowMapSize;
	};

	uniform PointLight pointLights[ NUM_POINT_LIGHTS ];

	// directLight is an out parameter as having it as a return value caused compiler errors on some devices
	void getPointDirectLightIrradiance( const in PointLight pointLight, const in GeometricContext geometry, out IncidentLight directLight ) {

		vec3 lVector = pointLight.position - geometry.position;
		directLight.direction = normalize( lVector );

		float lightDistance = length( lVector );

		directLight.color = pointLight.color;
		directLight.color *= punctualLightIntensityToIrradianceFactor( lightDistance, pointLight.distance, pointLight.decay );
		directLight.visible = ( directLight.color != vec3( 0.0 ) );

	}

#endif


#if NUM_SPOT_LIGHTS > 0

	struct SpotLight {
		vec3 position;
		vec3 direction;
		vec3 color;
		float distance;
		float decay;
		float coneCos;
		float penumbraCos;

		int shadow;
		float shadowBias;
		float shadowRadius;
		vec2 shadowMapSize;
	};

	uniform SpotLight spotLights[ NUM_SPOT_LIGHTS ];

	// directLight is an out parameter as having it as a return value caused compiler errors on some devices
	void getSpotDirectLightIrradiance( const in SpotLight spotLight, const in GeometricContext geometry, out IncidentLight directLight  ) {

		vec3 lVector = spotLight.position - geometry.position;
		directLight.direction = normalize( lVector );

		float lightDistance = length( lVector );
		float angleCos = dot( directLight.direction, spotLight.direction );

		if ( angleCos > spotLight.coneCos ) {

			float spotEffect = smoothstep( spotLight.coneCos, spotLight.penumbraCos, angleCos );

			directLight.color = spotLight.color;
			directLight.color *= spotEffect * punctualLightIntensityToIrradianceFactor( lightDistance, spotLight.distance, spotLight.decay );
			directLight.visible = true;

		} else {

			directLight.color = vec3( 0.0 );
			directLight.visible = false;

		}
	}

#endif


#if NUM_RECT_AREA_LIGHTS > 0

	struct RectAreaLight {
		vec3 color;
		vec3 position;
		vec3 halfWidth;
		vec3 halfHeight;
	};

	// Pre-computed values of LinearTransformedCosine approximation of BRDF
	// BRDF approximation Texture is 64x64
	uniform sampler2D ltcMat; // RGBA Float
	uniform sampler2D ltcMag; // Alpha Float (only has w component)

	uniform RectAreaLight rectAreaLights[ NUM_RECT_AREA_LIGHTS ];

#endif


#if NUM_HEMI_LIGHTS > 0

	struct HemisphereLight {
		vec3 direction;
		vec3 skyColor;
		vec3 groundColor;
	};

	uniform HemisphereLight hemisphereLights[ NUM_HEMI_LIGHTS ];

	vec3 getHemisphereLightIrradiance( const in HemisphereLight hemiLight, const in GeometricContext geometry ) {

		float dotNL = dot( geometry.normal, hemiLight.direction );
		float hemiDiffuseWeight = 0.5 * dotNL + 0.5;

		vec3 irradiance = mix( hemiLight.groundColor, hemiLight.skyColor, hemiDiffuseWeight );

		#ifndef PHYSICALLY_CORRECT_LIGHTS

			irradiance *= PI;

		#endif

		return irradiance;

	}

#endif


varying vec3 vViewPosition;

varying vec3 vNormal;

struct BlinnPhongMaterial {

	vec3	diffuseColor;
	vec3	specularColor;
	float	specularShininess;
	float	specularStrength;

};

#if NUM_RECT_AREA_LIGHTS > 0
    void RE_Direct_RectArea_BlinnPhong( const in RectAreaLight rectAreaLight, const in GeometricContext geometry, const in BlinnPhongMaterial material, inout ReflectedLight reflectedLight ) {

        vec3 matDiffColor = material.diffuseColor;
        vec3 matSpecColor = material.specularColor;
        vec3 lightColor   = rectAreaLight.color;

        float roughness = BlinnExponentToGGXRoughness( material.specularShininess );

        // Evaluate Lighting Equation
        vec3 spec = Rect_Area_Light_Specular_Reflectance(
                geometry,
                rectAreaLight.position, rectAreaLight.halfWidth, rectAreaLight.halfHeight,
                roughness,
                ltcMat, ltcMag );
        vec3 diff = Rect_Area_Light_Diffuse_Reflectance(
                geometry,
                rectAreaLight.position, rectAreaLight.halfWidth, rectAreaLight.halfHeight );

        // TODO (abelnation): note why division by 2PI is necessary
        reflectedLight.directSpecular += lightColor * matSpecColor * spec / PI2;
        reflectedLight.directDiffuse  += lightColor * matDiffColor * diff / PI2;

    }
#endif

void RE_Direct_BlinnPhong( const in IncidentLight directLight, const in GeometricContext geometry, const in BlinnPhongMaterial material, inout ReflectedLight reflectedLight ) {


		float dotNL = saturate( dot( geometry.normal, directLight.direction ) );
		vec3 irradiance = dotNL * directLight.color;

	#ifndef PHYSICALLY_CORRECT_LIGHTS

		irradiance *= PI; // punctual light

	#endif

	reflectedLight.directDiffuse += irradiance * BRDF_Diffuse_Lambert( material.diffuseColor );
	reflectedLight.directSpecular += irradiance * BRDF_Specular_BlinnPhong( directLight, geometry, material.specularColor, material.specularShininess ) * material.specularStrength;

}

void RE_IndirectDiffuse_BlinnPhong( const in vec3 irradiance, const in GeometricContext geometry, const in BlinnPhongMaterial material, inout ReflectedLight reflectedLight ) {

	reflectedLight.indirectDiffuse += irradiance * BRDF_Diffuse_Lambert( material.diffuseColor );

}

#define RE_Direct				RE_Direct_BlinnPhong
#define RE_Direct_RectArea		RE_Direct_RectArea_BlinnPhong
#define RE_IndirectDiffuse		RE_IndirectDiffuse_BlinnPhong

#define Material_LightProbeLOD( material )	(0)
float getShadowMask() {

	float shadow = 1.0;


	return shadow;

}

#ifdef USE_LOGDEPTHBUF

	uniform float logDepthBufFC;

	#ifdef USE_LOGDEPTHBUF_EXT
		varying float vFragDepth;

	#endif
#endif
#if NUM_CLIPPING_PLANES > 0

	#if ! defined( PHYSICAL ) && ! defined( PHONG )
		varying vec3 vViewPosition;
	#endif

	uniform vec4 clippingPlanes[ NUM_CLIPPING_PLANES ];

#endif

uniform vec3 refcenter;

   uniform int       polaimageenable;
   uniform float     polamaxradius;
   uniform float     polaimagesize;
   uniform sampler2D arcticmap;
   uniform sampler2D antarcticmap;


vec2 getImageCoordinate(vec3 pos)
{
   float halfImageSize = polaimagesize * 0.5;
   vec2 ret = vec2(halfImageSize, halfImageSize);
   if(pos.y == 90.0)
   {
      return ret;
   }
   if(pos.y == -90.0)
   {
      return ret;
   }
   float r = 0.0;
   if(pos.y < 0.0)
   {
      // 남쪽
      if(pos.y > (-90.0 + polamaxradius))
      {
         ret.x = -1.0;
         ret.y = -1.0;
         return ret;
      }
      r = (halfImageSize) * (90.0 + pos.y) / polamaxradius;
   }
   else
   {
      // 북쪽
      if(pos.y < (90.0 - polamaxradius))
      {
         ret.x = -1.0;
         ret.y = -1.0;
         return ret;
      }
      r = (halfImageSize) * (90.0 - pos.y) / polamaxradius;
   }
   float theta = 0.0;
   if (pos.x < 0.0)
   {
      // 서경
      theta = -pos.x;
   }
   else
   {
      // 동경
      theta = 360.0 - pos.x;
   }
   ret.x = (halfImageSize) + r * sin(theta * 0.017453292519943);
   ret.y = (halfImageSize) - r * cos(theta * 0.017453292519943);
   ret.x = ret.x / polaimagesize;
   ret.y = ret.y / polaimagesize;
   return ret;
}
vec3 getRealPosGeo()
{
   vec3 realPos = vWorldPos + refcenter;
   float r = sqrt(realPos.x * realPos.x + realPos.y * realPos.y + realPos.z * realPos.z);
   float lat = (acos(realPos.y / r)) * 57.2957795130823;
   float lon = (atan(realPos.x , realPos.z)) * 57.2957795130823;
   lat = 90.0 - lat;
   lon = 180.0 + lon;
   if (lon > 180.0) 
   {
      lon = -360.0 + lon;
   }
   return vec3(lon, lat, r);
}


void main() 
{
	// clipplane을 이용할때 사용되는 코드
   #if NUM_CLIPPING_PLANES > 0

	   for ( int i = 0; i < UNION_CLIPPING_PLANES; ++ i ) 
      {

		   vec4 plane = clippingPlanes[ i ];
		   if ( dot( vViewPosition, plane.xyz ) > plane.w ) discard;
	   }
		
	   #if UNION_CLIPPING_PLANES < NUM_CLIPPING_PLANES

		   bool clipped = true;
		   for ( int i = UNION_CLIPPING_PLANES; i < NUM_CLIPPING_PLANES; ++ i ) {
			   vec4 plane = clippingPlanes[ i ];
			   clipped = ( dot( vViewPosition, plane.xyz ) > plane.w ) && clipped;
		   }

		   if ( clipped ) discard;
	
	   #endif

   #endif

   vec4 diffuseColor = vec4( diffuse, opacity );

	ReflectedLight reflectedLight = ReflectedLight( vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ) );
	vec3 totalEmissiveRadiance = emissive;

   #if defined(USE_LOGDEPTHBUF) && defined(USE_LOGDEPTHBUF_EXT)

	   gl_FragDepthEXT = log2(vFragDepth) * logDepthBufFC * 0.5;

   #endif

   #ifdef USE_MAP
	   vec4 texelColor = texture2D( map, vUv );

	   texelColor = mapTexelToLinear( texelColor );
	   diffuseColor *= texelColor;

   #endif

   #ifdef USE_COLOR

	   diffuseColor.rgb *= vColor;

   #endif


   #ifdef USE_OVERLAYMAP

      vec4 overColor = texture2D( overlaymap, vUv );
      overColor = mapTexelToLinear(overColor);
      if(overColor.a == 1.0)
      {
         diffuseColor = overColor.rgba;
      }
      else if(overColor.a >= 0.0)
      {
         overColor.rgb = (1.0 - overColor.a) * diffuseColor.rgb + overColor.a * overColor.rgb;
         diffuseColor = vec4(overColor.rgb, diffuseColor.a);
      }

   #endif


   #ifdef USE_DYNAMICTOPMAP

      overColor = texture2D( dynamictopmap, vUv );
      overColor = mapTexelToLinear(overColor);
      if(overColor.a == 1.0)
      {
         diffuseColor = overColor.rgba;
      }
      else if(overColor.a >= 0.0)
      {
         overColor.rgb = (1.0 - overColor.a) * diffuseColor.rgb + overColor.a * overColor.rgb;
         diffuseColor = vec4(overColor.rgb, diffuseColor.a);
      }
	#endif


   if(polaimageenable == 1)
   {
      float lat = 0.0;
      float lon = 0.0;

      // lat와 lon을 구해야 한다.",
      vec3 latlon = getRealPosGeo();
      vec2 puv = getImageCoordinate(latlon);
      if(puv.x >= 0.0)
      {
         vec4 poleoverColor;
         if(latlon.y > 0.0)
         {
            poleoverColor = texture2D( arcticmap, puv );
         }
         else
         {
            poleoverColor = texture2D( antarcticmap, puv );
         }
         poleoverColor = mapTexelToLinear(poleoverColor);
         if(poleoverColor.a == 1.0)
         {
            diffuseColor = poleoverColor.rgba;
         }
         else if(poleoverColor.a == 0.0)
         {
         }
         else
         {
            vec3 c;
            c = (1.0 - poleoverColor.a) * diffuseColor.rgb + poleoverColor.a * poleoverColor.rgb;
            diffuseColor = vec4(c.rgb, diffuseColor.a);
         }
      }
   }


   float specularStrength;


	specularStrength = 1.0;

   #ifdef DOUBLE_SIDED
	   float flipNormal = ( float( gl_FrontFacing ) * 2.0 - 1.0 );
   #else
	   float flipNormal = 1.0;
   #endif

   vec3 normal = normalize( vNormal ) * flipNormal;

   BlinnPhongMaterial material;
   material.diffuseColor = diffuseColor.rgb;
   material.specularColor = specular;
   material.specularShininess = shininess;
   material.specularStrength = specularStrength;
   //
   // This is a template that can be used to light a material, it uses pluggable RenderEquations (RE)
   //   for specific lighting scenarios.
   //
   // Instructions for use:
   //  - Ensure that both RE_Direct, RE_IndirectDiffuse and RE_IndirectSpecular are defined
   //  - If you have defined an RE_IndirectSpecular, you need to also provide a Material_LightProbeLOD. <---- ???
   //  - Create a material parameter that is to be passed as the third parameter to your lighting functions.
   //
   // TODO:
   //  - Add area light support.
   //  - Add sphere light support.
   //  - Add diffuse light probe (irradiance cubemap) support.
   //

   GeometricContext geometry;

   geometry.position = - vViewPosition;
   geometry.normal = normal;
   geometry.viewDir = normalize( vViewPosition );

   IncidentLight directLight;

   #if ( NUM_POINT_LIGHTS > 0 ) && defined( RE_Direct )

	   PointLight pointLight;

	   for ( int i = 0; i < NUM_POINT_LIGHTS; i ++ ) {

		   pointLight = pointLights[ i ];

		   getPointDirectLightIrradiance( pointLight, geometry, directLight );

		   RE_Direct( directLight, geometry, material, reflectedLight );

	   }

   #endif

   #if ( NUM_SPOT_LIGHTS > 0 ) && defined( RE_Direct )

	   SpotLight spotLight;

	   for ( int i = 0; i < NUM_SPOT_LIGHTS; i ++ ) {

		   spotLight = spotLights[ i ];

		   getSpotDirectLightIrradiance( spotLight, geometry, directLight );

		   RE_Direct( directLight, geometry, material, reflectedLight );

	   }

   #endif

   #if ( NUM_DIR_LIGHTS > 0 ) && defined( RE_Direct )

	   DirectionalLight directionalLight;

	   for ( int i = 0; i < NUM_DIR_LIGHTS; i ++ ) {

		   directionalLight = directionalLights[ i ];

		   getDirectionalDirectLightIrradiance( directionalLight, geometry, directLight );

		   RE_Direct( directLight, geometry, material, reflectedLight );

	   }

   #endif

   #if ( NUM_RECT_AREA_LIGHTS > 0 ) && defined( RE_Direct_RectArea )

	   RectAreaLight rectAreaLight;

	   for ( int i = 0; i < NUM_RECT_AREA_LIGHTS; i ++ ) {

		   rectAreaLight = rectAreaLights[ i ];
		   RE_Direct_RectArea( rectAreaLight, geometry, material, reflectedLight );

	   }

   #endif

   #if defined( RE_IndirectDiffuse )

	   vec3 irradiance = getAmbientLightIrradiance( ambientLightColor );

	   #if ( NUM_HEMI_LIGHTS > 0 )

		   for ( int i = 0; i < NUM_HEMI_LIGHTS; i ++ ) {

			   irradiance += getHemisphereLightIrradiance( hemisphereLights[ i ], geometry );

		   }

	   #endif


	   RE_IndirectDiffuse( irradiance, geometry, material, reflectedLight );

   #endif


   vec3 outgoingLight = reflectedLight.directDiffuse + reflectedLight.indirectDiffuse + reflectedLight.directSpecular + reflectedLight.indirectSpecular + totalEmissiveRadiance;


   gl_FragColor = vec4( outgoingLight, diffuseColor.a );

   #ifdef PREMULTIPLIED_ALPHA

	   // Get get normal blending with premultipled, use with CustomBlending, OneFactor, OneMinusSrcAlphaFactor, AddEquation.
	   gl_FragColor.rgb *= gl_FragColor.a;

   #endif


     gl_FragColor = linearToOutputTexel( gl_FragColor );

   #ifdef USE_FOG

	   #ifdef USE_LOGDEPTHBUF_EXT

		   float depth = gl_FragDepthEXT / gl_FragCoord.w;

	   #else

		   float depth = gl_FragCoord.z / gl_FragCoord.w;

	   #endif

	   #ifdef FOG_EXP2

		   float fogFactor = whiteCompliment( exp2( - fogDensity * fogDensity * depth * depth * LOG2 ) );

	   #else

		   float fogFactor = smoothstep( fogNear, fogFar, depth );

	   #endif

	   gl_FragColor.rgb = mix( gl_FragColor.rgb, fogColor, fogFactor );

   #endif
}

