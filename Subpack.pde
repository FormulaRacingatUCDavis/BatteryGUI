public class Subpack{
  public int subpackNumber;
  int xPos;
  int yPos; 
  
  public int[] cellTemps = new int[num_cell_temps];
  public int[] boardTemps = new int[num_board_temps];
  public float[] cellVoltages = new float[num_voltages];
  
  final float acceptableVoltageDifference = 0.02;
  final float worryingVoltageDifference = 0.2;
  
  final color CYAN = color(#00FFFF);
  final color PURPLE = color(#FFA0FF);
  final color ORANGE = color(#FFE090);
  
  final int subpack_title_pos = 22;
  final int vt_title_pos = 38;
  final int values_pos = 40;
  final int textSize = 14;
  final int left_padding = 20;
  
  TextyBoxy tb_voltage = new TextyBoxy("V", "V", 0, 0);
  TextyBoxy tb_temp = new TextyBoxy("T", "C", 40, 50);
  
  public Subpack(){
    //for testing
    for(int i = 0; i < cellTemps.length; i++){
     cellTemps[i] = int(random(20, 30)); 
    }
    for(int i = 0; i < boardTemps.length; i++){
     boardTemps[i] = int(random(20,30)); 
    }
    for(int i = 0; i < cellVoltages.length; i++){
     cellVoltages[i] = random(3,3.08); 
    }
  }
  
  public Subpack(int[] cellTemperatures, int[] boardTemperatures, float[] cellVoltages, int subpackNumber){
    this.cellTemps = cellTemperatures;
    this.boardTemps = boardTemperatures;
    this.cellVoltages = cellVoltages;
    this.subpackNumber = subpackNumber;
  }
  
  public void drawSubpack(int xPos, int yPos, int subpackWindowWidth, int subpackWindowHeight, float min_cell_voltage){
    fill(0);
    stroke(255);
    rect(xPos, yPos, subpackWindowWidth-1, subpackWindowHeight-1);
    stroke(0);
    fill(255);
    
    draw_title(xPos, yPos);

    tb_voltage.green_yellow_cutoff = min_cell_voltage + acceptableVoltageDifference;
    tb_voltage.yellow_red_cutoff = min_cell_voltage + worryingVoltageDifference;
    
    int text_x = xPos + padding;

    fill(255);
    textSize(14);
    textAlign(LEFT, BOTTOM);
    text("Cell Voltages", text_x, yPos + vt_title_pos);
    
    for(int i = 0; i < num_voltages; i++){
      int boxy_y = yPos + values_pos + (tb_voltage.size)*(i % (num_voltages / 2));
      int boxy_x = text_x + (subpackWindowWidth/4)*(i / (num_voltages / 2));
      tb_voltage.drawit(boxy_x, boxy_y, i, this.cellVoltages[i]);  
    }
    
    text_x += subpackWindowWidth / 2;
    
    fill(255);
    textSize(14);
    textAlign(LEFT, BOTTOM);
    text("Cell Temps", text_x, yPos + vt_title_pos);
    
    for(int i = 0; i < num_cell_temps; i++){
      int boxy_y = yPos + values_pos + (tb_voltage.size)*(i % (num_voltages / 2));
      int boxy_x = text_x + (subpackWindowWidth/4)*(i / (num_voltages / 2));
      tb_temp.drawit(boxy_x, boxy_y, i, this.cellTemps[i]);   
    }
  }
  
  private void draw_title(int xPos, int yPos){
    fill(255);
    textSize(18);
    textAlign(LEFT, BOTTOM);
    text("Subpack " + this.subpackNumber, xPos + left_padding, yPos + subpack_title_pos);
  }
}

public class TextyBoxy{
  private String declaration;
  private String units;
  public float green_yellow_cutoff;
  public float yellow_red_cutoff;
  
  final public int size = 16;
  final int box_size = size - 2;
  final int text_size = 14;
  final int text_offset = 10;
  
  public TextyBoxy(String declaration, String units, float green_yellow_cutoff, float yellow_red_cutoff){
    this.declaration = declaration;
    this.units = units;
    this.green_yellow_cutoff = green_yellow_cutoff;
    this.yellow_red_cutoff = yellow_red_cutoff;
  }
  
  public void drawit(int x, int y, int index, int value){
    draw_box(x, y, (float)value);
    drawit_str(x, y, index, str(value)); 
  }
  
  public void drawit(int x, int y, int index, float value){
    draw_box(x, y, value);
    drawit_str(x, y, index, nf(value, 0, 4)); 
  }
  
  private void drawit_str(int x, int y, int index, String value){
    fill(color(#00FFFF));
    String s = this.declaration + index + ": " + value + this.units;
    textAlign(LEFT, CENTER);
    textSize(this.text_size);
    text(s, (x + this.box_size + this.text_offset), (y + (this.box_size / 2)));
  }
  
  public void draw_box(int x, int y, float value){
    color c = get_color(value);
    fill(c);
    rect(x, y, this.box_size, this.box_size);
  }
  
  public color get_color(float value){
    
    color red = color(255, 0, 0);
    color yellow = color(255, 255, 0);
    color green = color(0, 255, 0);
    
    if(yellow_red_cutoff > green_yellow_cutoff){
      if(value > yellow_red_cutoff) return red;
      if(value > green_yellow_cutoff) return yellow;
      return green;
    } else {
      if(value < yellow_red_cutoff) return red;
      if(value < green_yellow_cutoff) return yellow;
      return green;
    }
  }
}
