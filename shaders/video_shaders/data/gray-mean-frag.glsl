/**
*   Desarrollado por Diego Rodriguez y Juan Sebastian Narvaez
*   Computacion Visual 2020 - I
*
*   Fragment Shader que se encarga de pasar el color de los pixeles
*   a una escala de grises a traves del promedio de los valores rgb
*/

precision mediump float;

uniform sampler2D texture;
varying vec4 vertTexCoord;

void main() {
  vec4 color = texture2D(texture, vertTexCoord.st);
  float gray = (color.r + color.g + color.b) / 3.0;
  gl_FragColor = vec4(vec3(gray), color.a);
}

