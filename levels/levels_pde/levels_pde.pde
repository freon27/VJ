  
import processing.sound.*;

FFT fft;
AudioIn in;
int bands = 16 ;
int refresh = 4;
float[] spectrum = new float[bands];
PGraphics mountainBuffer;
float roll = 0 ;
  int skyIterationsGap = 5; 
  float lineSpacing = 1.2;
  float skyHeight = skyIterationsGap * lineSpacing;  

void setup() {
  size(displayWidth, displayHeight);
  background(0);
    
  mountainBuffer = createGraphics(width, 250);
 

  // Create an Input stream which is routed into the Amplitude analyzer
  fft = new FFT(this, bands);
  in = new AudioIn(this, 0);
  
  // start the Audio Input
  in.start();
  
  // patch the AudioIn
  fft.input(in);
}      

void draw() { 
  background(0);
  fft.analyze(spectrum);


   drawGround(); 
   drawMountains();
}


 void drawMountains() {
    
  fill(0);
  stroke(0);
  rect(0,0, width, 250 );
   
   float lastHeight = 0;
  mountainBuffer.beginDraw();
//mountainBuffer.translate(0, -height);
  mountainBuffer.stroke(255, 30, 60);
  for(int i = 0; i < bands; i++){
  // The result of the FFT is normalized
  // draw the line for frequency band i scaling it up by 5 to get more amplitude.
 // line( i, height, i, height - spectrum[i]*height*10 );
 
   float bandSizeX = width  / bands;
   
   float maxAmplitude = max(spectrum);
   
   float startX = i * bandSizeX;
   float startY = lastHeight;
   float endX = (i + 1) * bandSizeX;
   float endY = constrain(spectrum[i] * height * 100, 0, 250);
   
   
   
   println(width);
   println(bands);
   println(bandSizeX);
   mountainBuffer.line(startX, startY, endX, endY);
   lastHeight = endY;
  }
  
  mountainBuffer.endDraw();
  image(mountainBuffer, 0, 0);
  mountainBuffer.clear();
 }

 void drawGround() {

   refresh++;
   if(refresh % 4 == 0) {
     lineSpacing = lineSpacing + 0.01;
     if (lineSpacing > 1.8) {
       lineSpacing = 1.2;
     }
   }
   
  // horizontal lines
  for( float j= skyIterationsGap; j < height ; j *= lineSpacing) {
    stroke( 255*noise(j/1.0),255-255*noise(j/1.0), 255, 155);    
    int h = 250 + int(j);
    line(0,  h , width, h);
  } 
  
  // radial lines
  for (int x = 0 - width * 2; x <= width * 3; x += 90){
    
    //get the slope to the vanishing point
    float totalHeight = height - 100;
    float totalWidth = width / 2;
    float slope = totalHeight / totalWidth; 
    float correctedWidth = 150 * slope;
   
   
    line(x, height, width / 2, 100);
  }


 }  
