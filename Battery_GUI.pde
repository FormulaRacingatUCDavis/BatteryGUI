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

boolean connected = true;
Serial myPort;
String[] ports = Serial.list();
Button[] buttons = new Button[10];

Subpack[] subpacks = new Subpack[num_subpacks];
Batpack batpack = new Batpack(); 

void setup() {
  //fullScreen();
  //parse();
  size(1400,800);
  
  subpack_width = (width-batpack_width)/columns;
  subpack_height = height/rows;
  
  frameRate(30);
  background(0);
  
  for(int i = 0; i < subpacks.length; i++){
    subpacks[i] = new Subpack();
    subpacks[i].subpackNumber = i;
  }
  
  update_ports();
    //

}


void draw() {
  if(!connected){
    draw_port_select();
    return;
  }
  
  background(0);
  //parse_buffer();
  for(int i = 0; i < subpacks.length; i++){
    int x_pos = (i%columns)*subpack_width;
    int y_pos = (i/columns)*subpack_height;
    subpacks[i].drawSubpack(x_pos, y_pos, subpack_width, subpack_height, batpack.min_cell_voltage); 
  }  
  
  batpack.draw_batpack(columns*subpack_width, 0);
}

void update_ports(){
  for(int i = 0; i < ports.length; i++){
    int x = 20*i;
    buttons[i] = new Button(x, 0, 100, 50, ports[i], 255, 200, 0, 30);
  }
}

void draw_port_select(){
  background(0);
  for(int i = 0; i < ports.length; i++){
    buttons[i].draw_button();
  }
  TextyBoxy t = new TextyBoxy("Cell Temp", "C", 10, 20);
  t.drawit(200, 200, 3, 15);
}
  
void mousePressed(){
  for(int i = 0; i < ports.length; i++){
    if(buttons[i].mouse_over()){
      myPort =  new Serial(this, ports[i], 115200);
      connected = true;
      return;
    }
  }
}

void serialEvent (Serial myPort) {
  int b = myPort.read();
  println(b);
  byte_in(b);
}
