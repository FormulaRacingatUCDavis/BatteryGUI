int ESCAPE_CHAR = 0x05;
int FRAME_START = 0x01;
int FRAME_END = 0x0A;

boolean escaped = false;        //true if last character was escape
int[] buffer = new int[400];  //store incoming bytes
int i = 0; 

void byte_in(int b_in){
  if(b_in < 0 || b_in > 255){
    return;
  }
  int b = b_in;
  
  if(escaped){
    if(b == FRAME_START){           //reset buffer
      i = 0;
    } else if(b == FRAME_END){      //buffer is finished, parse data
      parse_buffer();
    } else if(b == ESCAPE_CHAR){    //byte is escape character
      buffer[i] = b;
      i++;
    }
    escaped = false;
    return;
  }
  
  if(b == ESCAPE_CHAR){    //check for escape
    escaped = true;
  } else {
    buffer[i] = b;
    i++;
  }
}

int expected_len = num_subpacks * (num_cell_temps + num_board_temps + 2*num_voltages);
//        num of sub      1byte/celltemp   1byte/boardtemp   2 bytes/cell voltage
    
void parse_buffer(){
  if(i != expected_len){  //check if buffer has correct amout of bytes
    return;
  }
  
  println("Data received!");
    
  int k = 0;
  for(int j = 0; j < num_subpacks; j++){    
    
    for(int n = 0; n < num_voltages; n++){
      subpacks[j].cellVoltages[n] = float((256*buffer[k])+buffer[k+1])/10000; //16 bit 10ths of millivolt --> float volts
      k+=2;
    }
    
    for(int n = 0; n < num_board_temps; n++){
      subpacks[j].boardTemps[n] = buffer[k];
      k++;
    }
    
    for(int n = 0; n < num_cell_temps; n++){
      subpacks[j].cellTemps[n] = buffer[k];
      k++;
    }
    
    batpack.pack_voltage = float((256*buffer[k]+buffer[k+1])/100);
    k+=2;
    
    batpack.min_cell_voltage = float((256*buffer[k])+buffer[k+1])/10000;
    k+=2;
    
    batpack.max_cell_voltage = float((256*buffer[k])+buffer[k+1])/10000;
    k+=2;
    
    batpack.max_temp = buffer[k];
    k++; 
    
    batpack.SOC = buffer[k]; 
    k++;
    
    batpack.status = (256*buffer[k])+buffer[k+1];
    k+=2;    
  }
}


   
   
      
  
    
