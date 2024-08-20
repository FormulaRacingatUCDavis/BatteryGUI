 /*
man i love formula
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

boolean connected = false;
boolean chargeProfileSet = false;
ChargeProfile chargeProfileSetting;
int loops_since_message = 0;
final int TIMEOUT_LOOPS = 50;
Serial myPort;
String[] ports = Serial.list();
Button[] portButtons = new Button[10];
Button[] chargeProfileButtons = {
  new Button(0, 0, 100, 50, "ESDC", 255, 200, 0, 30),
  new Button(0, 50, 100, 50, "Comp", 255, 200, 0, 30)
};

Subpack[] subpacks = new Subpack[num_subpacks];
Batpack batpack = new Batpack(); 

void setup() {
  //fullScreen();
  //parse();
  size(1100,800);
  
  subpack_width = (width-batpack_width)/columns;
  subpack_height = height/rows;
  
  frameRate(30);
  background(0);
  
  for(int i = 0; i < subpacks.length; i++){
    subpacks[i] = new Subpack();
    subpacks[i].subpackNumber = i;
  }
}


void draw() {
  if(!connected){
    draw_port_select();
    return;
  }
  
  if (!chargeProfileSet) {
    draw_outlet_select();
    return;
  }
  else {
    myPort.write(chargeProfileSetting.getId());
  }
  
  background(0);
  //parse_buffer();
  for(int i = 0; i < subpacks.length; i++){
    int x_pos = (i%columns)*subpack_width;
    int y_pos = (i/columns)*subpack_height;
    subpacks[i].drawSubpack(x_pos, y_pos, subpack_width, subpack_height, batpack.min_cell_voltage); 
  }  
  
  batpack.draw_batpack(columns*subpack_width, 0);
  
  // check for timeout
  loops_since_message++;
  if(loops_since_message > TIMEOUT_LOOPS){
    if(myPort != null){
      myPort.clear();
      myPort.stop();
    }
    loops_since_message = 0;
    connected = false;
  }
}

void draw_port_select(){
  background(0);
  ports = Serial.list();
  for(int i = 0; i < ports.length; i++){
    int y = 50*i;
    portButtons[i] = new Button(0, y, 100, 50, ports[i], 255, 200, 0, 30);
    portButtons[i].draw_button();
  }
}

void draw_outlet_select() {
  background(0);
  for (int i = 0; i < chargeProfileButtons.length; i++) {
    chargeProfileButtons[i].draw_button();
  }
}
  
void mousePressed(){
  if (!connected) {
    for(int i = 0; i < ports.length; i++){
      if(portButtons[i].mouse_over()){
        try {
          myPort = new Serial(this, ports[i], 115200);
          connected = true;
        } catch (Exception e){
          connected = false;
        }
      
        return;
      }
    }
  }
  
  if (!chargeProfileSet) {
    for (int i = 0; i < chargeProfileButtons.length; i++) {
      if (chargeProfileButtons[i].mouse_over()) {
        switch (i) {
          case 0:
            chargeProfileSetting = ChargeProfile.ESDC;
            break;
          case 1:
            chargeProfileSetting = ChargeProfile.COMP;
            break;
        }
        
        chargeProfileSet = true;
      }
    }
  }
}

void serialEvent (Serial myPort) {
  loops_since_message = 0;
  int b = myPort.read();
  println(b);
  byte_in(b);
}
