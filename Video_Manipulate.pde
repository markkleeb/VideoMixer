
import processing.video.*;

ProjBox projBox;
Capture videoCamera;
PImage newImg;

int counter = 0;
int cols, rows;
int videoScale;
int h;
int s;
int b;
int videoWidth = 1000;
int videoHeight = 600;
int maxScatter = 100;
int newHeight = 0;

void setup() {

  size (videoWidth, videoHeight, P3D);
  frameRate(30);
  noCursor( );

  projBox = new ProjBox();
  setupAudio();
videoScale = int(map(projBox.knobs[3], 0, 1023, 1, 10));

  String[] cameraList = Capture.list();
  println(cameraList);
  String cameraName = cameraList[3];


  videoCamera = new Capture(this, width, height, cameraName, 30);
  newImg = createImage(videoCamera.width, videoCamera.height, ARGB);
   

}

void draw ( ) {

  projBox.getData();


 


  int speed = int(map(projBox.knobs[2], 0, 1023, 0, 150));
  newHeight = (newHeight+speed) % height;
  println("newHeight : " + newHeight + " / speed : " + speed);
translate(0, newHeight);
  
  
  scatter(videoCamera);
  
  image(videoCamera, 0, 0);
  image(videoCamera, 0, -height);
 
  
image(newImg, 0, 0);
image(newImg, 0, -height);
  //scatter code

getAudioData();
 float waveAmp =  map(projBox.knobs[1], 0, 1023, 0, 1000);
  volumeWave(waveAmp);

 



  //println(projBox.knobs[0]);


  //switches code

  if (projBox.switches[0]==1) {
    filter(THRESHOLD, 0.4);
  }
  if (projBox.switches[1] ==1) {
    filter(INVERT);
  }
  if (projBox.switches[2]==1) {
    filter(GRAY);
  }

  if (projBox.switches[3] ==1) {
colorMode(HSB, 255);
    
  }
  else {
    colorMode(RGB, 255);
  }
  
}

void captureEvent(Capture videoCamera) {
  videoCamera.read();
}


void volumeWave(float amp) {
  float x = 0;
  float y = 0;
  
  stroke(255);
  strokeWeight(amp/100);
  //beginShape(LINES);
  
  for(int i = -height; i < height; i+=20) {
    for(int j = 0; j < width; j++){
       line(j, i+abs(volumes[j]*amp), j+1, (i+abs(volumes[j+1]*amp)));
    }
  }  
}

void keyPressed(){
save("yourpicture" + counter + ".jpg");
counter++;
}

