part of stackAttackLib;

/**
 * Powerups
 */
class PowerupBomb extends Powerup {
  
  /**
   * Konstruktor
   */
  PowerupBomb(int x, int y):super(x,y){    
    addClass("powerup_bomb");
  }
  
  void walkThrough(Model m){
    print("bombe");
    return;
    Player p = m.player;
    //links und rechts der Figur    
    for(int i = -1; i <= p.height; i++){
      Block b = m.getBlock(p.x - 1, p.y - i);
      if( b != null){
        m.deleteBlock(b);  
      }
      b = m.getBlock(p.x + p.width, p.y - i);
      if( b != null){
        m.deleteBlock(b);  
      }      
    }
    //unterhalb der Figur
    for(int i = -1; i <= p.width; i++){
      Block b = m.getBlock(p.x - i, p.y + p.height);
      if( b != null){
        m.deleteBlock(b);  
      }      
    }        
    //alle fallen runter
    m.allBlocksFallingDown();
  }
  
}