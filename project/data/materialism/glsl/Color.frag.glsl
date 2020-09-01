
precision mediump float;

uniform vec2 u_resolution;
uniform vec3 u_rgba;

varying vec2 v_uvCoordinates;

void main() {
	gl_FragColor = vec4(u_rgba.rgb, 1);
}