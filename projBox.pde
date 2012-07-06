/*
**  Projbox Arduino Software Interface - josephgray@grauwald.com - 1/2011
*/

import processing.serial.*;
import cc.arduino.*;

Arduino arduino; // declare arduino object

void setupArduino(String _arduinoName) { //instantiate arduino object
  arduino = new Arduino(this, _arduinoName, 57600);
}

class ProjBox {

  String arduinoName;

  int totalRows = 4; // each row on the box

  int[] knobPins = { 1,2,3,4 }; // arduino analog pins
  int[] knobs = new int[totalRows]; // knob values
  int[] pknobs = new int[totalRows]; // previous frames knob values
  int[] knobsChange = new int[totalRows]; // change since last frame

  int[] switchPins = { 2,3,4,5 }; // arduino digital pins
  int[] switches = new int[totalRows]; // switch values
  int[] pswitches = new int[totalRows]; // previous switch values

  int[] ledPins = { 6,9,10,11 }; //  arduino PWM pins
  int[] leds = new int[totalRows]; // LED values

  String switchMatrix = "0000";

  // sets the max voltage for the LEDS
  int LED_MAX = 168; // approx. 3.3 volts


  ProjBox() { // generic constructor
    println(Arduino.list()); // prints the list of serial devices
    arduinoName =  Arduino.list()[0]; // selects the first item in that list
    setupArduino(arduinoName);
    setupProjbox();
  }

  ProjBox(String _arduinoName) { // specific constructor
    arduinoName = _arduinoName; 
    setupArduino(arduinoName);
    setupProjbox();
  }

  void setupProjbox() { 
    for(int row=0; row<totalRows; row++) {
      // tell arduino pins what to do
      arduino.pinMode(switchPins[row], Arduino.INPUT);
      arduino.digitalWrite(switchPins[row], Arduino.HIGH);
      arduino.pinMode(ledPins[row], Arduino.OUTPUT);
    }
  }

  void getData() { // get data off the arduino
    for(int row=0; row<totalRows; row++) {
      pknobs[row] = knobs[row];
      knobs[row] = arduino.analogRead(knobPins[row]); // read knobs
      knobsChange[row] = knobs[row]-pknobs[row];

      pswitches[row] = switches[row];
      switches[row] = arduino.digitalRead(switchPins[row]); // read switches

      ledDisplaySwitches(row); // set leds
    }
    //
    concatSwitchMatrix(); // concat switches
  }

  void concatSwitchMatrix() { // concatenate switch states
    switchMatrix = "";
    for(int row=0; row<totalRows; row++) switchMatrix += switches[row];
  }

  void ledDisplayKnobs(int _row) {
    leds[_row] = floor(map(knobs[_row], 0,1023,0,LED_MAX)); 
    arduino.analogWrite(ledPins[_row], leds[_row]);
  }

  void ledDisplaySwitches(int _row) {
    leds[_row] = switches[_row]*LED_MAX; 
    arduino.analogWrite(ledPins[_row], leds[_row]);
  }
}

