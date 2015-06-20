part of stackAttackLib;

/**
 * Powerups
 */
class PowerupBomb extends Powerup {
  
  /**
   * Konstruktor
   */
  PowerupBomb(int x, int y):super(x,y){    
    image = PICS_PATH+POWERUP_BOMB+PICS_TYP;              
  }
  
  void walkThrough(Model m){
    Player p = m.player;
    //m.getBlock();
  }
}