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
  
  /**
   * Alle Powerups bleiben, wenn mehr als 3 aneinander sind
   */
  void blocksDeletion(Model m){    
  }
  
}