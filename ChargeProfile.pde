public enum ChargeProfile {
  ESDC(0),
  COMP(1);
  
  private int id;
  
  private ChargeProfile(int id) {
    this.id = id;
  }
  
  public int getId() {
    return id;
  }
}
