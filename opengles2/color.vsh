attribute vec4 aPosition;

uniform mat4 uModelViewProjectionMatrix;
uniform float uPointSize;
uniform float uColorVariance;

void main()
{
    gl_Position = uModelViewProjectionMatrix * aPosition;
	gl_PointSize = uPointSize;
}
