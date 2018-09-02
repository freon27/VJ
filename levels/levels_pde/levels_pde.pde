  
import processing.sound.*;

FFT fft;
AudioIn in;
int bands = 16 ;
int refresh = 4;
float time = 0;
float[] spectrum = new float[bands];
PGraphics mountainBuffer;
PGraphics moonBuffer;

float roll = 0 ;
  int skyIterationsGap = 5; 
  float lineSpacing = 1.2;
  float skyHeight = 250;  

void setup() {
    fullScreen();
 // size(displayWidth, displayHeight);
  background(0);
    
  mountainBuffer = createGraphics(width, 250);
   moonBuffer = createGraphics(width, 250);


  // Create an Input stream which is routed into the Amplitude analyzer
  fft = new FFT(this, bands);
  in = new AudioIn(this, 0);
  
  // start the Audio Input
  in.start();
  
  // patch the AudioIn
  fft.input(in);
  
    
  strokeWeight(2);
}      

void draw() { 
  background(0);
  fft.analyze(spectrum);

 
   drawGround(); 
   drawMoon();
   drawMountains();
   time += 0.2;
}


 void drawMountains() {
    

   
   float lastHeight = 0;
  mountainBuffer.beginDraw();
  mountainBuffer.fill(0);
//mountainBuffer.translate(0, -height);
  mountainBuffer.stroke(255, 30, 60);
  for(int i = 0; i < bands; i++){
  // The result of the FFT is normalized
  // draw the line for frequency band i scaling it up by 5 to get more amplitude.
 // line( i, height, i, height - spectrum[i]*height*10 );
 
   float bandSizeX = (width / 2)  / bands;
   
   float maxAmplitude = max(spectrum);
   
   float startX = i * bandSizeX;
   float startY = lastHeight;
   float endX = (i + 1) * bandSizeX;
   float endY = constrain(spectrum[i] * height * 100, 0, 250);
   
   
   
   println(width);
   println(bands);
   println(bandSizeX);
  
  
  
   mountainBuffer.line(startX, mountainBuffer.height - startY, endX, mountainBuffer.height - endY);
  

   
   
   
   //mountainBuffer.scale(- 1, 1);
   //mountainBuffer.line(startX, startY, endX, endY);
   //mountainBuffer.scale(-1, 1);
   lastHeight = endY;
  }
  
  mountainBuffer.endDraw();
  image(mountainBuffer, 0, 0);
    image(mountainBuffer, 0, 0);
  pushMatrix();
 scale(-1.0, 1.0);
 image(mountainBuffer,-mountainBuffer.width,0);
  popMatrix();
  mountainBuffer.clear();
 }


 void drawMoon() {
   
  moonBuffer.beginDraw();

   
    // moonBuffer.ellipse(100 + time , moonBuffer.height - time, 115, 115);
   //   moonBuffer.filter( BLUR, 6 );
   
   float moonX = 100 + time;
   float moonY =  moonBuffer.height - time;
   
    moonBuffer.stroke( 255 * (1/1.0),255-255 * (1/1.0), 255, 155);    
    moonBuffer.fill( 255 * (1/1.0),255-255 * (1/1.0), 255, 155);    

   moonBuffer.ellipse(100 + time , moonBuffer.height - time, 100, 100);
   
  //moonBuffer.fill(0);
  //moonBuffer.stroke(0);
  //for(int i = 1; i < 50; i += 4) {
  //  moonBuffer.rect(0, moonY + (i * 2) + 1, width, i / 5);
  //}
  
     moonBuffer.endDraw();
   image(moonBuffer, 0, 0);
   moonBuffer.clear();
   
 }

 void drawGround() {

     roll = roll + 0.001;
     if (roll >= 0.06) {
       roll = 0;
     }
   
  // horizontal lines
  for( float j= 1; j < height ; j *= (lineSpacing + roll)) {
    stroke( 255*noise(j/1.0),255-255*noise(j/1.0), 255, 155);    
    int h = 250 + int(j);
    line(0,  h , width, h);
  } 
  
  // radial lines
  for (int x = 0 - width * 2; x <= width * 3; x += 150){
    
    //get the slope to the vanishing point
    float totalHeight = height - 100;
    float totalWidth = width / 2;
    float slope = totalHeight / totalWidth; 
    float correctedWidth = 150 * slope;
   
   
    line(x, height, width / 2, 100);
  }

// block out sky
     fill(0);
  stroke(0);
  rect(0,0, width, 250 );
 }  
