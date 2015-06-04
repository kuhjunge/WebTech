part of stackAttackLib;

/**
 * Playerklasse 
 */
class Player extends MovingElement {
    
  Player(int x, int y) : super(x, y){ 
    element.innerHtml = '<img src="'+PLAYER_STANDING+'"></img>';
    element.classes.add("player");
    element.style.height = BLOCK_SIZE.toString() + "px";
  }  
    

}