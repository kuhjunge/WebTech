part of stackAttackLib;

/**
 * Powerups
 */
class PowerupColorChange extends Powerup {
  
  /**
   * Konstruktor
   */
  PowerupColorChange(int x, int y):super(x,y){    
    addClass("powerup_colorchange");
  }
  
  void walkThrough(Model m){
    print("colorChange");
  }
  
}