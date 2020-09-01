
precision mediump float;

uniform sampler2D u_main;

varying vec2 v_uvCoordinates;

void main() {
	gl_FragColor = texture(u_main, v_uvCoordinates);
}