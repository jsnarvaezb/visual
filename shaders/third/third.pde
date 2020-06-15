/**
*   Desarrollado por Diego Rodriguez y Juan Sebastian Narvaez
*   Computacion Visual 2020 - I
*
*   Programa que muestra dos versiones de la misma imagen:
*   Original - Representacion ASCII
*   
*/

PImage img;
PShader ascii;

String[] chars = {".", ":", "*", "|", "V", "F", "N", "M"};
int colNumber = 32;
int imgWidth = int(375*1.5);
int imgHeight = int(532*1.5);
/**
*  Parametros pasados al shader:
*  - Numero de caracteres ASCII en el eje X de la imagen (columna)
*  - Numero de pixeles que ocupa cada caracter ASCII en el eje X
*  - Numero de pixeles que ocupa cada caracter ASCII en el eje Y
*  - Numero de caracteres ASCII disponibles (Niveles de grises)
*/
float[] params = {float(colNumber), floor(imgWidth/colNumber),
                  floor(imgHeight/(imgWidth/colNumber)), float(chars.length)};

void setup() {
  size(1596, 800, P2D);
  img = loadImage("gohan.jpg");
  img.resize(imgWidth, imgHeight);
  ascii = loadShader("ascii-frag.glsl");
  ascii.set("params", params);
  ascii.set("characters", createChars(chars));
  
}

void draw() {
  resetShader();
  image(img, 0, 0);
  shader(ascii); //<>//
  ascii.set("params", params);
  image(img, imgWidth + 1, 0);
  resetShader();
  image(createChars(chars), (imgWidth+1)*2, 0);
}
/*
*  Funcion que crea la textura con los caracteres ASCII
*  @param s: Arreglo de strings con caracteres ASCII ordenados por sus niveles
*            de grises.
*/
PGraphics createChars(String[] s) {
  float fontWidth = floor(imgWidth)/colNumber;
  float fontHeight = fontWidth;
  PGraphics pg = createGraphics(int(fontWidth * s.length), int(fontHeight), P2D);
  pg.beginDraw();
  pg.background(255);
  pg.textSize((fontWidth+fontHeight)/2);
  pg.textAlign(CENTER);
  pg.fill(0);  
  for(int i = 0; i < s.length; i++) {    
    pg.text(s[i], (fontWidth * i) + fontWidth / 2 , fontHeight - 2);
  }
  pg.endDraw();
  return pg;
}

PShape createShape(PImage img, int x, int y, int x_start, int y_start) {
  PShape ps = createShape();
  beginShape();
  texture(img);
  vertex(x_start + 0, y_start + 0, 0, 0);  
  vertex(x_start + 0, y_start + y, 0, y);
  vertex(x_start + x, y_start + y, x, y);
  vertex(x_start + x, y_start + 0, x, 0);  
  endShape();
  return ps;
}
