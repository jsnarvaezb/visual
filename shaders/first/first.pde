/**
*   Desarrollado por Diego Rodriguez y Juan Sebastian Narvaez
*   Computacion Visual 2020 - I
*
*   Programa que muestra versiones de la misma imagen:
*   - Imagen con colores originales
*   - Imagen con colores en escala de grises por Luma 601 (Shader)
*   - Imagen con colores en escala de grises por promedio de valores RGB (Shader)
*/

PImage img;
PShader grayLuma, grayMean;

void setup() {
  size(1125, 532, P2D);
  img = loadImage("gohan.jpg");
  img.resize(375, 532);
  grayLuma = loadShader("luma-frag.glsl");
  grayMean = loadShader("gray-mean-frag.glsl");
}

void draw() {
  resetShader();
  createShape(img, 375, 532, 0, 0); //<>//
  shader(grayLuma);
  createShape(img, 375, 532, 376, 0);
  shader(grayMean);
  createShape(img, 375, 532, 751, 0);
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
