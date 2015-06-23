part of stackAttackLib;

/**
 * Powerups
 */
class PowerupHeart extends Powerup {
  
  /**
   * Konstruktor
   */
  PowerupHeart(int x, int y):super(x,y){    
    addClass("powerup_heart");
  }
  
  void walkThrough(Model m){
    m._player.life += 1;  
  }
}