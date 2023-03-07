 /*

*/

import java.util.Arrays;
import processing.serial.*;

int num_subpacks = 1;
int num_cell_temps = 12;
int num_board_temps = 0;
int num_voltages = 12;

Serial myPort;
Subpack[] subpacks = new Subpack[num_subpacks];

void setup() {
  //fullScreen();
  //parse();
  size(1500,1000);
  frameRate(1);
  background(0);
    for(int i = 0; i < subpacks.length; i++){
    subpacks[i] = new Subpack();
    subpacks[i].subpackNumber = i+1;
    subpacks[i].drawSubpack(!(i>2) ? 0 : width/2, ((i%3) * (height/3-100)), width/2, height/3-100);
    
  }
  myPort =  new Serial(this, Serial.list()[0], 115200);
}


void draw() {
  background(0);
  //parse_buffer();
  for(int i = 0; i < subpacks.length; i++){
    //subpacks[i] = new Subpack();
    //subpacks[i].subpackNumber = i+1;
    subpacks[i].drawSubpack(!(i>2) ? 0 : width/2, ((i%3) * (height/3-100)), width/2, height/3-100); 
  }  
}


void serialEvent (Serial myPort) {
  int b = myPort.read();
  byte_in(b);
}
