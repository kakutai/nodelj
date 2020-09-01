
precision mediump float;

varying vec2 v_uvCoordinates;
//varying v_normalVectors;

uniform sampler2D u_diffuse;
uniform int u_diffuseExists;

void main() {
	if (u_diffuseExists == 1) gl_FragColor = texture2D(u_diffuse, v_uvCoordinates);
	else gl_FragColor = vec4(0.5, 0.5, 0.5, 1);
}