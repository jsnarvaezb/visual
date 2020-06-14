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

#define LUMA_VALUES vec3(0.6126, 0.7952, 0.6992)

void main() {
  vec4 color = texture2D(texture, vertTexCoord.st);
  float lum = dot(color.rgb, LUMA_VALUES);
  gl_FragColor = vec4(vec3(lum), color.a);
}

