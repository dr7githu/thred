uniform int drawmain;
uniform sampler2D mainTex;
uniform sampler2D subTex;

varying vec2 vUv;
varying vec3 vPosition;

void main() 
{
    // Texture loading
    vec4 diffuse = texture2D( mainTex, vUv );
	vec4 color = diffuse;

	if(drawmain == 0)
	{
		diffuse = texture2D( subTex, vUv );
		color = vec4( mix( color.rgb, diffuse.rgb, diffuse.a ), 1.0 );
	}

	gl_FragColor = color;
}