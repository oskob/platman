precision mediump float;
varying vec2 vTextureCoordinates;
uniform float uOpacity;
uniform sampler2D uTexture;

void main()
{
	gl_FragColor = texture2D(uTexture, vTextureCoordinates);
	gl_FragColor.a *= uOpacity;
}