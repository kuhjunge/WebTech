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
    //lösche alle Nachbarn des Players
    var l = m.player.getNeighbours(m); 
    l.forEach( (f)=> m.deleteBlock(f) );
    
    //vergebe Punkte wie für zusammenhängende Blöcke
    m.player.points += POINTS_PER_GROUPELEMENT*l.length;
    
    //alle fallen runter
    m.allBlocksFallingDown();
    //Player fällt runter
    m.player.falling(m);
  }
  
}