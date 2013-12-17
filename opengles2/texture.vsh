attribute vec4 aPosition;
attribute vec2 aTextureCoordinates;
uniform mat4 uModelViewProjectionMatrix;
varying vec2 vTextureCoordinates;

void main()
{
    gl_Position = uModelViewProjectionMatrix * aPosition;
	vTextureCoordinates = aTextureCoordinates;
}