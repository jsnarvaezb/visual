import processing.video.*;

Movie original_video, copy_video;
PGraphics pg;
Button blur_button, identity_button, sharpen_button, edge_detection_button, gaussian_blur_button, grayscale_button, luma_button, ascii_button;

float[][] edge_detection = {  {-1, -1,-1},
                             {-1, 8, -1},
                             {-1,-1, -1}};   
float[][] identity = { {0, 0,0},
                     {0, 1, 0},
                     {0,0, 0}};  
                     
float[][] sharpen =  { {0, -1,0},
                     {-1,5, -1},
                     {0,-1, 0}};        
                     
float[][] blur =   {{0.11, 0.11,0.11},
                    {0.11,0.11, 0.11},
                    {0.11,0.11, 0.11}};
                    
float v= 0.0625;                    
float[][] gaussian_blur = {{v, 2*v,v},
                          {2*v,4*v, 2*v},
                          {v, 2*v, v}};   
                          
float[][] matrix = identity;                     
                     
String filter= "grayscale";

boolean is_ascii= false;
boolean is_filter = false;

char[] ascii;

void setup() {
  size(1030, 500);
  frameRate(30);
  original_video = new Movie(this,"homero.mov");
  copy_video = new Movie(this,"homero.mov");
  original_video.loop();
  copy_video.loop();
  pg = createGraphics(504,239);
  
  //Botones
  identity_button = new Button("Identity", 10, 350, 100, 35);
  blur_button = new Button("Blur", 120, 350, 110, 35);
  sharpen_button = new Button("Sharpen", 240, 350, 100, 35);
  edge_detection_button = new Button("Edge detection", 350, 350, 150, 35);
  gaussian_blur_button = new Button("Gaussian blur", 510, 350, 150, 35);
  grayscale_button = new Button("Grayscale", 10, 450, 100, 35);
  luma_button = new Button("Luma", 120, 450, 100, 35);
  ascii_button = new Button("Ascii", 230, 450, 100, 35);  
}

void draw() {
  background(255);
  textSize(12);
  text("Frame rate:", 480 , 280);
  text(frameRate, 550,280);
  text("Mask of convolution", 70 , 330);
  text("Filters", 30 , 430);
  
  //Draw buttons
  blur_button.Draw();
  identity_button.Draw();
  sharpen_button.Draw();
  edge_detection_button.Draw();
  gaussian_blur_button.Draw();
  grayscale_button.Draw();
  luma_button.Draw();
  ascii_button.Draw();
  
  pg.beginDraw();
  pg.image(copy_video,0,0);
  pg.loadPixels();
  if(is_filter && filter != "ascii"){
    filters();
  }else{
    convolution();
  }
  pg.updatePixels();
  pg.endDraw();
  
  if (is_filter && filter == "ascii"){
    fn_ascii();
  }else{ 
    image(pg,520,10);
  }
  image(original_video,6, 10);

}

void movieEvent(Movie m) {
  m.read();
}

void convolution() { 
  // Adaptado de https://processing.org/examples/blur.html
  for (int y = 1; y < pg.height-1; y++) {   // Skip top and bottom edges
    for (int x = 1; x < pg.width-1; x++) {  // Skip left and right edges
      float rtotal=0 ;
      float gtotal=0; 
      float btotal=0;
      // Kernel sum for this pixel
      for (int ky = -1; ky <= 1; ky++) {
        for (int kx = -1; kx <= 1; kx++) {
          // Calculate the adjacent pixel for this kernel point
          int pos = (y + ky)*original_video.width + (x + kx);
          // Multiply adjacent pixels based on the kernel values
          rtotal += red(original_video.pixels[pos]) * matrix[ky+1][kx+1];
          gtotal += green(original_video.pixels[pos]) * matrix[ky+1][kx+1];
          btotal += blue(original_video.pixels[pos]) * matrix[ky+1][kx+1];
        }
      }
      color c = color(rtotal,gtotal,btotal);
      int i = x + y*original_video.width;
      pg.pixels[i] = c;
    }
  }
}

void filters(){
  for (int i = 0; i < pg.pixels.length; i++) {
    float red = red(pg.pixels[i]);    
    float green = green(pg.pixels[i]);
    float blue = blue(pg.pixels[i]);
    if(filter=="grayscale"){
      pg.pixels[i] = color(int((red+green+blue)/3));
    }
    if(filter=="luma"){
      pg.pixels[i] = color((0.2989 * red) + (0.5870 *green) + (0.1140 * blue));
    }
  }
}


void fn_ascii(){
  textSize(10); 
  ascii = new char[256];
  String letters = "@&%#*vi<>+=^;,:'. ";
  for (int i = 0; i < 256; i++) {
    int index = int(map(i, 0, 256, 0, letters.length()));
    ascii[i] = letters.charAt(index);
  }
  for (int y = 5; y <original_video.height-5; y += 7) {
    for (int x = 5; x < original_video.width-5; x += 7) {
      int index = (x + y * pg.width);
      float r = red(pg.pixels[index + 0]);
      float g = green(pg.pixels[index + 1]);
      float b = blue(pg.pixels[index + 2]);
      float brig = (r+g+b)/3;
      text(ascii[int(brig)], x+520, y+10);
    }
  }
}

void mousePressed()
{
  if (blur_button.MouseIsOver()) {
    matrix = blur;
    is_filter= false;
  }
  if (identity_button.MouseIsOver()) {
    matrix = identity;
    is_filter= false;
  }
  if (sharpen_button.MouseIsOver()) {
    matrix = sharpen;
    is_filter= false;
  }
  if (edge_detection_button.MouseIsOver()) {
    matrix = edge_detection;
    is_filter= false;
  }
  if (gaussian_blur_button.MouseIsOver()) {
    matrix = gaussian_blur;
    is_filter= false;
  }
  if (ascii_button.MouseIsOver()) {
    is_filter= true; 
    is_ascii = true;
    filter= "ascii";
  }
  if (grayscale_button.MouseIsOver()) {
    is_filter= true; 
    filter= "grayscale";
  }
  if (luma_button.MouseIsOver()) {
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
