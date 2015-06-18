part of stackAttackLib;

/**
 * Powerups
 */
class PowerupHeart extends Powerup {
  
  /**
   * Konstruktor
   */
  PowerupHeart(int x, int y):super(x,y){    
    element.innerHtml = '<img src="'+PICS_PATH+POWERUP_HEART.toString()+PICS_TYP+'" height="$BLOCK_SIZE px" width="$BLOCK_SIZE px"></img>';              
  }
  
  void walkThrough(Model m){
    m._player.life += 1;  
  }
}