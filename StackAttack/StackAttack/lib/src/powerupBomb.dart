part of stackAttackLib;

/**
 * Powerups
 */
class PowerupBomb extends Powerup {
  
  /**
   * Konstruktor
   */
  PowerupBomb(int x, int y):super(x,y){    
    //element.innerHtml = '<img src="'+PICS_PATH+POWERUP_BOMB.toString()+PICS_TYP+'" height="$BLOCK_SIZE px" width="$BLOCK_SIZE px"></img>';              
  }
  
  void walkThrough(Model m){
    Player p = m.player;
    //m.getBlock();
  }
}