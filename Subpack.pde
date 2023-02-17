public class Subpack{
  public static final float AMBIENTTEMP = 25.0;
  public int subpackNumber;
  public int[] cellTemps = new int[num_cell_temps];
  public int[] boardTemps = new int[num_board_temps];
  public float[] cellVoltages = new float[num_voltages];
  
  float acceptableVoltageDifference = 0.014;
  float worryingVoltageDifference = 0.03;
  
  final color CYAN = color(#00FFFF);
  final color PURPLE = color(#FFA0FF);
  final color ORANGE = color(#FFE090);
  
  int textSize = 14;
  int padding = 40;
  
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
    int boardTempXPos = xPos;
    int voltageXPos = xPos + subpackWindowWidth*25/100;
    int cellTempXPos = xPos + subpackWindowWidth*65/100;
    
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
    
    text("Board Temps", xPos + subpackWidth/200, yPos + textSize);
    
    int gb = 255;
    for(int j = 0; j < num_board_temps; j++){
        gb = 255;
        if(boardTemps[j] > AMBIENTTEMP){
          gb = 255-(int)map(boardTemps[j], AMBIENTTEMP, 60, 150,255);
        }
          
        textY = yPos + j*textSize + padding;
        textX = boardTempXPos + padding;
        
        fill(gb == 255 ? color(0,255,0) : color(255, gb, gb));   //set fill color for color sqare
        rect(textX - 20, textY - textSize, textSize, textSize); //draw color square
        
        if(j < 4) fill(CYAN);
        else if(j < 7)  fill(PURPLE);
        else fill(ORANGE);
        
        try{
          text("Board Temp " + str(j) + ": " + str(boardTemps[j]), textX, textY);
        }
        catch(Exception e){
          System.out.println("Oh man it didn't like that float");
        }
      
    }
    
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
        text("Cell " + (i+1) + ": " + (i < 9 ? "  " : "") + str(cellVoltages[i]), textX, textY);
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
