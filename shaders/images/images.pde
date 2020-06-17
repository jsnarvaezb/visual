/**
*   Desarrollado por Diego Rodriguez y Juan Sebastian Narvaez
*   Computacion Visual 2020 - I
*     
*   Programa que aplica varias mascaras de convolucion a una imagen
*   
*/

PImage img;
PShader convolution, grayLuma, grayMean, shader;
Button blur_button, identity_button, sharpen_button, edge_detection_button, gaussian_blur_button, grayscale_button, luma_button;


float[] sharpenMask = {0.0, -1.0,  0.0,
                      -1.0,  5.0, -1.0,
                       0.0, -1.0,  0.0};

float[] edgeMask = { -1.0, -1.0, -1.0,
                     -1.0,  8.0, -1.0,
                     -1.0, -1.0, -1.0};

float[] gaussianBlurMask = { 0.0625, 0.125, 0.0625,
                              0.125,  0.25,  0.125,
                             0.0625, 0.125, 0.0625};

 float[] boxBlurMask = { 0.11, 0.11, 0.11,
                         0.11, 0.11, 0.11,
                         0.11, 0.11, 0.11};  

 float[] identityMask ={ 0.0,  0.0,  0.0,
                         0.0,  1.0,  0.0,
                         0.0,  0.0,  0.0};
                         
float[] mask = identityMask;

String filter= "grayscale";

boolean is_filter = false;
   
void setup() {
  size(1070, 390, P2D);
  img = loadImage("big_eyes.png");
  textSize(12);
  convolution = loadShader("conv-frag.glsl");
  convolution.set("renderSize", float(img.width), float(img.height));
  grayLuma = loadShader("luma-frag.glsl");
  grayMean = loadShader("gray-mean-frag.glsl");
  
  identity_button = new Button("Identity", 10, 330, 100, 35);
  blur_button = new Button("Blur", 120, 330, 110, 35);
  sharpen_button = new Button("Sharpen", 240, 330, 100, 35);
  edge_detection_button = new Button("Edge detection", 350, 330, 150, 35);
  gaussian_blur_button = new Button("Gaussian blur", 510, 330, 150, 35);
  grayscale_button = new Button("Grayscale", 670, 330, 100, 35);
  luma_button = new Button("Luma", 780,330, 100, 35);
}

void draw() {
  background(255); 
  resetShader();
  
  blur_button.Draw();
  identity_button.Draw();
  sharpen_button.Draw();
  edge_detection_button.Draw();
  gaussian_blur_button.Draw();
  grayscale_button.Draw();
  luma_button.Draw();
  
  createShape(img, img.width, img.height, 0, 0);
  
  if(is_filter && filter != "ascii"){
    shader(shader);
  }else{
    setMask(convolution, mask);
  }
  createShape(img, img.width, img.height, img.width+5, 0);
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

void mousePressed()
{
  if (blur_button.MouseIsOver()) {
    mask = boxBlurMask;
    shader = convolution;
    is_filter= false;
  }
  if (identity_button.MouseIsOver()) {
    mask = identityMask;
    shader = convolution;
    is_filter= false;
  }
  if (sharpen_button.MouseIsOver()) {
    mask = sharpenMask;
    shader = convolution;
    is_filter= false;
  }
  if (edge_detection_button.MouseIsOver()) {
    mask = edgeMask;
    shader = convolution;
    is_filter= false;
  }
  if (gaussian_blur_button.MouseIsOver()) {
    mask = gaussianBlurMask;
    shader = convolution;
    is_filter= false;
  }
  if (grayscale_button.MouseIsOver()) {
    shader = grayMean;
    is_filter= true; 
    filter= "grayscale";
  }
  if (luma_button.MouseIsOver()) {
    shader = grayLuma;
    is_filter= true; 
    filter= "luma";
  }
}


class Button {
  String label; // button label
  float x;      // top left corner x position
  float y;      // top left corner y position
  float w;      // width of button
  float h;      // height of button
  
  // constructor
  Button(String labelB, float xpos, float ypos, float widthB, float heightB) {
    label = labelB;
    x = xpos;
    y = ypos;
    w = widthB;
    h = heightB;
  }
  
  void Draw() {
    fill(218);
    stroke(141);
    rect(x, y, w, h, 10);
    textAlign(CENTER, CENTER);
    fill(0);
    text(label, x + (w / 2), y + (h / 2));
  }
  
  boolean MouseIsOver() {
    if (mouseX > x && mouseX < (x + w) && mouseY > y && mouseY < (y + h)) {
      return true;
    }
    return false;
  }
}
