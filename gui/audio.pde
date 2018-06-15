import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim; 
AudioPlayer fun; 
FFT fftLin;
FFT fftLog; 
BeatDetect beat;
BeatListener bd;


String file;
boolean load = false;
float kick;
float snare;

//INITIALISES LIBRARIES FOR AUDIO-PLAYBACK AND ANALYSIS//
//WILL ONLY BE CALLED AFTER A FILE IS LOADED, TO AVOID NULL-POINTER 
void audio_Properties() {

  minim = new Minim(this);
  fun = minim.loadFile(file, 1024);

  fftLin = new FFT(fun.bufferSize(), fun.sampleRate() );
  fftLin.linAverages(12);

  beat = new BeatDetect(fun.bufferSize(), fun.sampleRate());
  beat.setSensitivity(200);  
  bd = new BeatListener(beat, fun);
}

//FILE SELECTION FUNCTION//

void fileSelected(File selection) { 

  file = selection.getAbsolutePath();
  if (file !=null) {
    audio_Properties();
    load = true;
  }
}

//BEAT DETECTION/ONSET DETECTION//

void beatDetection() {

  kick = 0;
  snare = 0;
  if (load == true) {
    if (beat.isSnare())  snare = 1; 
    if (beat.isKick())   kick = 1;  
    fftLin.forward( fun.mix );
  }
}

//BEAT LISTENER (UTILISED FOR ONSET DETECTION) FROM THE MINIM LIBRARY//

class BeatListener implements AudioListener
{
  private BeatDetect beat;
  private AudioPlayer source;

  BeatListener(BeatDetect beat, AudioPlayer source)
  {
    this.source = source;
    this.source.addListener(this);
    this.beat = beat;
  }

  void samples(float[] samps)
  {
    beat.detect(source.mix);
  }

  void samples(float[] sampsL, float[] sampsR)
  {
    beat.detect(source.mix);
  }
}