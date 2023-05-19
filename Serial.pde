int ESCAPE_CHAR = 0xAA;
int PACK_FRAME_START= 0xBB;
int FRAME_END = 0x0A;

boolean escaped = false;        //true if last character was escape
boolean reading_batpack = false;
int[] buffer = new int[600];  //store incoming bytes
int i = 0; 
int subpack_num = 0;

final int expected_len_subpack = (num_cell_temps + num_board_temps + 2*num_voltages);
//                                1byte/celltemp   1byte/boardtemp   2 bytes/cell voltage

final int expected_len_batpack = 10;

void byte_in(int b_in){
  if(b_in < 0 || b_in > 255){
    return;
  }
  int b = b_in;
  
  if(escaped){
    if(b == PACK_FRAME_START){   //reset buffer
      i = 0;
      reading_batpack = true;
    } else if (b < num_subpacks){
      i = 0; 
      subpack_num = b;
      reading_batpack = false;
    } else if(b == FRAME_END){      //buffer is finished, parse data
      if(reading_batpack){
        parse_buffer_batpack();
      } else {
        parse_buffer_subpack();
      }
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
    
void parse_buffer_subpack(){
  if(i != expected_len_subpack){  //check if buffer has correct amout of byte
    println(str(i) + " " + str(expected_len_subpack));
    println("Yikes");
    return;
  }
  
  println("Subpack data received!");
    
  int k = 0;
  for(int n = 0; n < num_voltages; n++){
    subpacks[subpack_num].cellVoltages[n] = float((256*buffer[k])+buffer[k+1])/10000; //16 bit 10ths of millivolt --> float volts
    k+=2;
  }
  
  for(int n = 0; n < num_board_temps; n++){
    subpacks[subpack_num].boardTemps[n] = buffer[k];
    k++;
  }
  
  for(int n = 0; n < num_cell_temps; n++){
    subpacks[subpack_num].cellTemps[n] = buffer[k];
    k++;
  }
}
    
    
void parse_buffer_batpack(){
  if(i != expected_len_batpack){  //check if buffer has correct amout of byte
    println(str(i) + " " + str(expected_len_batpack));
    println("Yikes");
    return;
  }
  println("Batpack data received!");
  
  int k = 0;
  
  batpack.pack_voltage = float(256*buffer[k]+buffer[k+1])/100.0;
  k+=2;
  
  batpack.min_cell_voltage = float(256*buffer[k]+buffer[k+1])/10000.0;
  k+=2;
  
  batpack.max_cell_voltage = float(256*buffer[k]+buffer[k+1])/10000.0;
  k+=2;
  
  batpack.max_temp = buffer[k];
  k++; 
  
  batpack.SOC = buffer[k]; 
  k++;
  
  batpack.status = (256*buffer[k])+buffer[k+1];
  k+=2;    
  
}


   
   
      
  
    
