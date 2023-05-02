 /*

*/

import java.util.Arrays;
import processing.serial.*;

int num_subpacks = 10;
int num_cell_temps = 12;
int num_board_temps = 0;
int num_voltages = 12;

int columns = 2; 
int rows = 5;
int subpack_width;
int subpack_height;
int batpack_width = 200;

Serial myPort;
Subpack[] subpacks = new Subpack[num_subpacks];
Batpack batpack = new Batpack(); 

void setup() {
  //fullScreen();
  //parse();
  size(1400,1000);
  
  subpack_width = (width-batpack_width)/columns;
  subpack_height = height/rows;
  
  frameRate(1);
  background(0);
  
  for(int i = 0; i < subpacks.length; i++){
    subpacks[i] = new Subpack();
    subpacks[i].subpackNumber = i+1;
  }
  
  
  
  //myPort =  new Serial(this, Serial.list()[0], 115200);
}


void draw() {
  background(0);
  //parse_buffer();
  for(int i = 0; i < subpacks.length; i++){
    int x_pos = (i%columns)*subpack_width;
    int y_pos = (i/columns)*subpack_height;
    subpacks[i].drawSubpack(x_pos, y_pos, subpack_width, subpack_height); 
  }  
  
  batpack.draw_batpack(columns*subpack_width, 0);
}


void serialEvent (Serial myPort) {
  int b = myPort.read();
  byte_in(b);
}
