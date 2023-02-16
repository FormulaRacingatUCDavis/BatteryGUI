 /*

*/

import java.util.Arrays;
import processing.serial.*;

int num_subpacks = 5;
int num_cell_temps = 24;
int num_board_temps = 7;
int num_voltages = 24;

Subpack[] subpacks = new Subpack[num_subpacks];

void setup() {
  //fullScreen();
  size(1500,1000);
  frameRate(1);
  background(0);
    for(int i = 0; i < subpacks.length; i++){
    subpacks[i] = new Subpack();
    subpacks[i].subpackNumber = i+1;
    subpacks[i].drawSubpack(!(i>2) ? 0 : width/2, ((i%3) * (height/3-100)), width/2, height/3-100);
    
  }
}


void draw() {
  background(0);
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
