part of stackAttackLib;

/**
 * Powerups
 */
abstract class Powerup extends Block {
  
  /**
   * Konstruktor
   */
  Powerup(int x, int y):super(x,y, NO_COLOR, true, false){    
    addClass("powerup");
  }
  
  void walkThrough(Model m);
  
}