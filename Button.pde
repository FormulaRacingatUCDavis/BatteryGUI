public class Button{
  private int x;
  private int y;
  private int w;
  private int h;
  private String text;
  private color text_color;
  private color button_color;
  private color hover_color;
  private int text_size;
  
  public Button(int x, int y, int w, int h, String text, color button_color, color hover_color, color text_color, int text_size){
    this.x = x;
    this.y = y; 
    this.w = w;
    this.h = h;
    this.text = text;
    this.button_color = button_color;
    this.hover_color = hover_color;
    this.text_color = text_color;
    this.text_size = text_size;
  }
  
  public void draw_button(){
    if(this.mouse_over()){
      fill(this.hover_color);
    } else {
      fill(this.button_color);
    }
    rect(this.x, this.y, this.w, this.h);
    fill(this.text_color);
    textAlign(CENTER, CENTER);
    textSize(this.text_size);
    text(this.text, this.x + (this.w/2), this.y + (this.h/2));
  }
  
  public boolean mouse_over(){
    if(mouseX < this.x) return false;
    if(mouseX > (this.x + this.w)) return false;
    if(mouseY < this.y) return false;
    if(mouseY > (this.y + this.h)) return false;
    return true;
  }
  
  
}
    
  
