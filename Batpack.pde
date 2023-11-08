final int NO_ERROR = 0x0000;
final int CHARGEMODE = 0x0001;
final int PACK_TEMP_OVER = 0x0002;
final int FUSE_BLOWN = 0x0004;
final int PACK_TEMP_UNDER = 0x0008;
final int LOW_SOC = 0x0010;
final int CRITICAL_SOC = 0x0020;
final int IMBALANCE = 0x0040;
final int COM_FAILURE = 0x0080;
final int SPI_FAULT = 0x0400;
final int CELL_VOLT_OVER = 0x0800;
final int CELL_VOLT_UNDER = 0x1000;
final int CHARGE_HAULT = 0x2000;
final int FULL = 0x4000;

final int padding = 20;
final int line_space = 16; 
final int text_size = 20;


public class Batpack{
  public float pack_voltage = 0;
  public float min_cell_voltage = 0;
  public float max_cell_voltage = 0;
  public int max_temp = 0;
  public int min_temp = 0;
  public int avg_temp = 0;
  public int status = 0;
  public int SOC = 0;
  
  private int text_x;
  private int text_y;
  
  void print_status(){
    fill(255);
    print_text("STATUS:");
    
    if(status == NO_ERROR){
      fill(0, 255, 0);
      print_text("Normal :)");
    } else {
      //FAULTS
      fill(255, 0, 0);
      if((status & PACK_TEMP_OVER) != 0) print_text("Pack overtemp!");
      if((status & FUSE_BLOWN)  != 0) print_text("Fuse blown!");
      if((status & PACK_TEMP_UNDER)  != 0) print_text("Pack undertemp!");
      if((status & CRITICAL_SOC)  != 0) print_text("Critical SOC!");
      if((status & SPI_FAULT)  != 0) print_text("SPI Fault!");
      
      //WARNINGS
      fill(255, 255, 0);
      if((status & LOW_SOC)  != 0) print_text("Low SOC!");
      if((status & CHARGEMODE) != 0) print_text("Charge mode");
      if((status & IMBALANCE)  != 0) print_text("Imbalance!"); 
     
    }
  }
  
  void draw_batpack(int xpos, int ypos){
    text_x = xpos + padding;
    text_y = ypos + padding;
    float balance = (max_cell_voltage - min_cell_voltage)*1000.0;
    String str;
    
    fill(255);
    
    str = String.format("SOC: %d%%", SOC);
    print_text(str);
    
    str = String.format("HI Temp: %dC", max_temp);
    print_text(str);
    
    str = String.format("LO Temp: %dC", min_temp);
    print_text(str);
    
    str = String.format("AVG Temp: %dC", avg_temp);
    print_text(str);
    
    str = String.format("Pack voltage: %.2fV", pack_voltage);
    print_text(str);
    
    str = String.format("LO Voltage: %.4fV", min_cell_voltage);
    print_text(str);
    
    str = String.format("HI Voltage: %.4fV", max_cell_voltage);
    print_text(str);
    
    str = String.format("Balance: %.1fmV", balance);
    print_text(str);
    
    print_text("");
    print_status();
    
  }  
  
  void print_text(String str){
     text(str, text_x, text_y);
     text_y += line_space;
  }
    
}
