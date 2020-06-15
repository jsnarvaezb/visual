/**
*   Desarrollado por Diego Rodriguez y Juan Sebastian Narvaez
*   Computacion Visual 2020 - I
*
*   Fragment Shader que se encarga de pasar el color de los pixeles
*   a una escala de grises a traves de Luma 601
*/

precision mediump float;

uniform sampler2D texture;
varying vec4 vertTexCoord;

#define LUMA_VALUES vec3(0.2989, 0.5870, 0.1140)

void main() {
  vec4 color = texture2D(texture, vertTexCoord.st);
  float lum = dot(color.rgb, LUMA_VALUES);
  gl_FragColor = vec4(vec3(lum), color.a);
}

