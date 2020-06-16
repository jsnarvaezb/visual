/**
*   Desarrollado por Diego Rodriguez y Juan Sebastian Narvaez
*   Computacion Visual 2020 - I
*     
*   Programa que convierte una imagen a su representacion ascii
*   calculando primero su nivel de luminosidad y luego seleccionando
*   un caracter de la textura characters para luego dibujarlo en su 
*   lugar correspondiente en el dibujo original
*/

precision mediump float;
uniform float params[4];
uniform sampler2D texture;
uniform sampler2D characters;
varying vec4 vertTexCoord;

#define GRAY_VALUES vec3(0.299, 0.587, 0.114)

void main() {
  int tilesX = int(params[0]);
  float tileW = int(params[1]);
  float tileH = int(params[1]);
  int tilesY = int(params[2]);
  int numChars = int(params[3]);
  
  float x = float(int(vertTexCoord.x * tilesX))/tilesX;
  float y = float(int(vertTexCoord.y * tilesY))/tilesY;  
  vec2 coord = vec2( x, y );
  
  vec4 pixel = texture2D(texture, coord);
  float gray = dot(pixel.rgb, GRAY_VALUES);
  /*
    Desde este punto las operaciones no devuelven el resultado
    esperado.
  */
  
  float char_x = mod(coord.x, tilesX) * tileW;
  float char_y = -mod(coord.y, tilesY) * tileH;
  float eq_x = float(tileW/int(tileW * numChars));
  
  vec2 charCoords = vec2( int(gray * eq_x) + int(char_x * eq_x), char_y );  
  gl_FragColor = texture2D(characters, charCoords);
}

