part of stackAttackLib;

/**
 * Playerklasse 
 */
class Player extends MovingElement {
  /**
   * Punktezähler
   */
  int _points = 0;
  
  Player(int x, int y) : super(x, y){    
    element.innerHtml = '<img src="'+PLAYER_STANDING+BLOCK_SIZE.toString()+PICS_TYP+'"></img>';    
    element.classes.add("player");
    element.style.height = (2*BLOCK_SIZE).toString() + "px";
  }  
    

}