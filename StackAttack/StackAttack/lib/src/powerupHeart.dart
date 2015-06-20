part of stackAttackLib;

/**
 * Powerups
 */
class PowerupHeart extends Powerup {
  
  /**
   * Konstruktor
   */
  PowerupHeart(int x, int y):super(x,y){    
    image = PICS_PATH+POWERUP_HEART+PICS_TYP;              
  }
  
  void walkThrough(Model m){
    m._player.life += 1;  
  }
}