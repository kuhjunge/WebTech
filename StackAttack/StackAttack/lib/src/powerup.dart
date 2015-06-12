part of stackAttackLib;

/**
 * Powerups
 */
class Powerup extends Block {
  
  /**
   * Konstruktor
   */
  Powerup(int x, int y):super(x,y, NO_COLOR, false){
    //TODO andere Powerups hinzufügen
    element.innerHtml = '<img src="'+PICS_PATH+POWERUP_HEART+BLOCK_SIZE.toString()+PICS_TYP+'"></img>';    
    element.classes.add("powerup");       
  }
}