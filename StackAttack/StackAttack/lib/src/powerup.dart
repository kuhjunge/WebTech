part of stackAttackLib;

/**
 * Powerups
 */
abstract class Powerup extends Block {
  
  /**
   * Konstruktor
   */
  Powerup(int x, int y):super(x,y, NO_COLOR, true, false){    
    element.classes.add("powerup");       
  }
  
  void walkThrough(Model m);
  
}