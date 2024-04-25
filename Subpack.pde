public class Subpack{
  public static final float AMBIENTTEMP = 60.0;
  public int subpackNumber;
  public int[] cellTemps = new int[num_cell_temps];
  public int[] boardTemps = new int[num_board_temps];
  public float[] cellVoltages = new float[num_voltages];
  
  final float acceptableVoltageDifference = 0.001;
  final float worryingVoltageDifference = 0.05;
  
  final color CYAN = color(#00FFFF);
  final color PURPLE = color(#FFA0FF);
  final color ORANGE = color(#FFE090);
  
  final int textSize = 14;
  final int padding = 40;
  
  public Subpack(){
    //for testing
    for(int i = 0; i < cellTemps.length; i++){
     cellTemps[i] = int(random(AMBIENTTEMP-10, 30)); 
    }
    for(int i = 0; i < boardTemps.length; i++){
     boardTemps[i] = int(random(AMBIENTTEMP - 10,30)); 
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
  
  public void drawSubpack(int xPos, int yPos, int subpackWindowWidth, int subpackWindowHeight){
    //
    //FRAME SETUP
    //
    int voltageXPos = xPos;
    int cellTempXPos = xPos + subpackWindowWidth/2;
    
    int subpackWidth = subpackWindowWidth * 2;
    int subpackHeight = subpackWindowHeight * 3;
    stroke(255);
    fill(0);
    strokeWeight(4);
    rect(xPos, yPos, subpackWidth/2, subpackHeight/3);
    strokeWeight(1);
    line(voltageXPos, yPos, voltageXPos, yPos + subpackWindowHeight);
    line(cellTempXPos, yPos, cellTempXPos, yPos + subpackWindowHeight);
    fill(255);
    textSize(subpackHeight/(3*17));
    text("Subpack " + subpackNumber, xPos + subpackWindowWidth * 90/100, yPos + subpackHeight/(3*17));
    
    //
    //BOARD TEMPERATURES
    //
    
    int textX;
    int textY;
    fill(255);
    textSize(textSize);
    int gb;
    
    //
    //CELL VOLTAGES
    //

    int cellVoltageTextXPos = voltageXPos + padding;
    
    fill(255);
    text("Cell Voltages",cellVoltageTextXPos, yPos + textSize);
    line(xPos, yPos + textSize + 2, xPos + subpackWidth/2, yPos + textSize + 2);
    
    for(int i = 0; i < cellVoltages.length; i++){
      
      textX = (i < cellVoltages.length /2) ? (cellVoltageTextXPos): (cellVoltageTextXPos + 120);
      textY = yPos + i%(cellVoltages.length/2)*textSize + padding;
      
      if(i < 12) fill(CYAN);
      else if(i < 24) fill(PURPLE);
      else fill(ORANGE);

      try{
        text("Cell " + (i+1) + ": " + (i < 9 ? "  " : "") + nf(cellVoltages[i], 1, 4), textX, textY);
      }
      catch(Exception e){
        System.out.println("Oh man it didn't like that float");
      }
      
      //draw boxes
      if(cellVoltages[i] - Stats.min(cellVoltages) > worryingVoltageDifference){
        fill(255,0,0);
      }
      else if(cellVoltages[i] - Stats.min(cellVoltages) > acceptableVoltageDifference){
        fill(255,255,0);
      }
      else{
        fill(0,255,0);
      }
      rect(textX - 20, textY - textSize, textSize, textSize);
    }
    
    //
    //CELL TEMPERATURES
    //
    
    int textXPos = cellTempXPos + padding; 
    fill(255);
    text("Cell Temps", xPos + subpackWidth*37/100, yPos + textSize);
    
    for(int i = 0; i < cellTemps.length; i++){
      
      if(cellTemps[i] > AMBIENTTEMP){
        gb = 255-(int)map(cellTemps[i], AMBIENTTEMP, 60, 150, 255);
      }
      else{
        gb = 255;
      }
      
      textX = (i < cellTemps.length /2) ? (textXPos): (textXPos + 120);
      textY = yPos + i%(num_cell_temps/2)*textSize + padding;
      
      fill(gb == 255 ? color(0,255,0) : color(255, gb, gb));
      rect(textX - 20, textY - textSize, textSize, textSize);
      
      if(i < 12) fill(CYAN);
      else if(i < 24) fill(PURPLE);
      else fill(ORANGE);
      
      try{
        text("Cell Temp " + i + ": " + str(cellTemps[i]), textX, textY);
      }
      catch(Exception e){
        System.out.println("Oh man it didn't like that float");
      }
    }
  }
}
