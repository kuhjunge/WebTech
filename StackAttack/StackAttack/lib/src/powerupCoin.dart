part of stackAttackLib;

/**
 * Powerups
 */
class PowerupCoin extends Powerup {
  
  /**
   * Konstruktor
   */
  PowerupCoin(int x, int y):super(x,y){    
    addClass("powerup_coin");
  }
  
  void walkThrough(Model m){
    //vergebe Punkte wie GroupElement * 4
    m.player.points += POINTS_PER_GROUPELEMENT*4;
    
  }
  
}