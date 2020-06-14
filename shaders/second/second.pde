/**
*   Desarrollado por Diego Rodriguez y Juan Sebastian Narvaez
*   Computacion Visual 2020 - I
*     
*   Programa que aplica varias mascaras de convolucion a una imagen
*   y las muestra en el siguiente orden:
*   
*   Original -   Sharpen    - Edge
*   BoxBlur  - GaussianBlur - Identity
*/

PImage img;
PShader convolution;

float[] sharpenMask = {0.0, -1.0,  0.0,
                      -1.0,  5.0, -1.0,
                       0.0, -1.0,  0.0};

//float[] edgeMask = { -1.0, -1.0, -1.0,
//                     -1.0,  8.0, -1.0,
//                     -1.0, -1.0, -1.0};

float[] edgeMask = {  0.0, -1.0,  0.0,
                     -1.0,  4.0, -1.0,
                      0.0, -1.0,  0.0};

//float[] edgeMask = {  1.0,  0.0, -1.0,
//                      0.0,  0.0,  0.0,
//                     -1.0,  0.0,  1.0};

float[] gaussianBlurMask = { 0.0625, 0.125, 0.0625,
                              0.125,  0.25,  0.125,
                             0.0625, 0.125, 0.0625};

 float[] boxBlurMask = { -1.0, -1.0, -1.0,
                         -1.0,  9.0, -1.0,
                         -1.0, -1.0, -1.0};  

 float[] identityMask ={ 0.0,  0.0,  0.0,
                         0.0,  1.0,  0.0,
                         0.0,  0.0,  0.0};
   
void setup() {
  size(1125, 1064, P2D);
  img = loadImage("gohan.jpg");
  img.resize(375, 532);
  convolution = loadShader("conv-frag.glsl");
  convolution.set("renderSize", float(375), float(532));
}

void draw() {
  resetShader();
  createShape(img, 375, 532, 0, 0);
  
  setMask(convolution, sharpenMask);
  createShape(img, 375, 532, 376, 0);
  
  setMask(convolution, edgeMask);
  createShape(img, 375, 532, 751, 0);
  
  setMask(convolution, boxBlurMask);
  createShape(img, 375, 532, 0, 532);
  
  setMask(convolution, gaussianBlurMask);
  createShape(img, 375, 532, 376, 532);
  
  setMask(convolution, identityMask);
  createShape(img, 375, 532, 751, 532);
  
  //shader(grayMean);
  
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

void setMask(PShader shader, float[] mask) {
  shader(shader);
  shader.set("mask", mask);
}
