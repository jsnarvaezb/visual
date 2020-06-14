import processing.video.*;

Movie original_video, copy_video;
PGraphics pg;
Button blur_button, identity_button, sharpen_button, edge_detection_button, gaussian_blur_button, grayscale_button, luma_button, ascii_button;

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

boolean is_ascii= false;
boolean is_filter = false;

char[] ascii;

PShader convolution, grayLuma, grayMean, shader;

void setup() {
  size(1030, 500, P3D);
  frameRate(30);
  textSize(12);
  background(255);
  original_video = new Movie(this,"homero.mov");
  copy_video = new Movie(this,"homero.mov");
  original_video.loop();
  copy_video.loop();
  pg = createGraphics(504,239, P3D);
  
  convolution = loadShader("conv-frag.glsl");
  grayLuma = loadShader("luma-frag.glsl");
  grayMean = loadShader("gray-mean-frag.glsl");
  
  
  identity_button = new Button("Identity", 10, 350, 100, 35);
  blur_button = new Button("Blur", 120, 350, 110, 35);
  sharpen_button = new Button("Sharpen", 240, 350, 100, 35);
  edge_detection_button = new Button("Edge detection", 350, 350, 150, 35);
  gaussian_blur_button = new Button("Gaussian blur", 510, 350, 150, 35);
  grayscale_button = new Button("Grayscale", 10, 450, 100, 35);
  luma_button = new Button("Luma", 120, 450, 100, 35);
  ascii_button = new Button("Ascii", 230, 450, 100, 35);
  fill(0);
  stroke(0);
  
}

void draw() {
  background(255);
  resetShader();
  
  convolution.set("mask", sharpenMask);
  
  pg.beginDraw();
  if(is_filter && filter != "ascii"){
    pg.shader(shader);
  }else{
    //convolution.set("mask", mask);
    setMask(convolution, mask);
  }
  
  if(copy_video.available()){
        copy_video.read();
    }
  pg.image(copy_video.get(), 0, 0);
  pg.endDraw();
  image(pg, copy_video.width+5, 0); 
  image(original_video, 0, 0); 
  blur_button.Draw();
  identity_button.Draw();
  sharpen_button.Draw();
  edge_detection_button.Draw();
  gaussian_blur_button.Draw();
  grayscale_button.Draw();
  luma_button.Draw();
  ascii_button.Draw();
  
}

void movieEvent(Movie m) {
  m.read();
}

void setMask(PShader shader, float[] mask) {
  pg.shader(shader);
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
  if (ascii_button.MouseIsOver()) {
    is_filter= true; 
    is_ascii = true;
    filter= "ascii";
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




//Tomado de https://blog.startingelectronics.com/a-simple-button-for-processing-language-code/

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
