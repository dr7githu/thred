#define PHONG

varying vec3 vViewPosition;
varying vec3 vWorldPos;
varying vec3 vNormal;

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

#if defined( USE_MAP ) 

	varying vec2 vUv;
	uniform vec4 offsetRepeat;

#endif

#ifdef USE_COLOR

	varying vec3 vColor;

#endif


#ifdef USE_LOGDEPTHBUF

	#ifdef USE_LOGDEPTHBUF_EXT

		varying float vFragDepth;

	#endif

	uniform float logDepthBufFC;

#endif
#if NUM_CLIPPING_PLANES > 0 && ! defined( PHYSICAL ) && ! defined( PHONG )
	varying vec3 vViewPosition;
#endif

void main() 
{
   #if defined( USE_MAP ) 

	   vUv = uv * offsetRepeat.zw + offsetRepeat.xy;

   #endif

   #ifdef USE_COLOR

	   vColor.xyz = color.xyz;

   #endif

   vec3 objectNormal = vec3( normal );
   #ifdef FLIP_SIDED

	   objectNormal = -objectNormal;

   #endif

   vec3 transformedNormal = normalMatrix * objectNormal;

   vNormal = normalize( transformedNormal );

   vec3 transformed = vec3( position );

	vec4 mvPosition = modelViewMatrix * vec4( transformed, 1.0 );

   gl_Position = projectionMatrix * mvPosition;

   #ifdef USE_LOGDEPTHBUF

	   gl_Position.z = log2(max( EPSILON, gl_Position.w + 1.0 )) * logDepthBufFC;

	   #ifdef USE_LOGDEPTHBUF_EXT

		   vFragDepth = 1.0 + gl_Position.w;

	   #else

		   gl_Position.z = (gl_Position.z - 1.0) * gl_Position.w;

	   #endif

   #endif

   vViewPosition = - mvPosition.xyz;


	vec4 worldPosition = modelMatrix * vec4( transformed, 1.0 );

   vec4 worldPos = modelMatrix * vec4( position.xyz, 1.0 );
   vWorldPos = worldPos.xyz;
}





















