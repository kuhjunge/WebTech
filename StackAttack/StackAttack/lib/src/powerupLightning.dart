part of stackAttackLib;

/**
 * Powerups
 */
class PowerupLightning extends Powerup {
  
  /**
   * Konstruktor
   */
  PowerupLightning(int x, int y):super(x,y){    
    addClass("powerup_lightning");
  }
  
  void walkThrough(Model m){    
    int length = 0;
    
    //lösche alle Blöcke in einer Zeile
    for(int i = 0; i < BLOCKS_PER_ROW; i++){
      Block b = m.getBlock(i, y);
      if(b != null && b != this){
        length++;
        m.deleteBlock(b);
      }
    }    
    
    //vergebe Punkte wie für zusammenhängende Blöcke durch zwei
    m.player.points += POINTS_PER_GROUPELEMENT~/2 * length;
    
    //alle fallen runter
    m.allBlocksFallingDown();
    //Player fällt runter
    m.player.falling(m);
  }
  
}