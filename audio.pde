import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;

AudioInput audioIn;
float sampleRate = 44100;
int bufferSize = 2048;
float[] volumes;

FFT fft;
int fftAverages;
float[] frequencies;

BeatDetect beat;


void setupAudio() {
 minim = new Minim(this);
minim.debugOn();

audioIn = minim.getLineIn(Minim.MONO, bufferSize, sampleRate);
volumes = new float[bufferSize];

fft = new FFT(bufferSize, sampleRate);
fft.logAverages(60, 3);
fftAverages = fft.avgSize();
frequencies = new float[fftAverages];

beat = new BeatDetect(bufferSize, sampleRate);
beat.setSensitivity(200);

}

void getAudioData() {
 for(int i = 0; i < bufferSize; i++) {
   volumes[i] = audioIn.mix.get(i);
 }
 
 fft.forward(audioIn.mix);
 for(int j = 0; j < fftAverages; j++) {
   frequencies[j] = fft.getAvg(j);
 }
 
 beat.detect(audioIn.mix);
 
}

void stop() {
 audioIn.close();
minim.stop();

super.stop();


}
