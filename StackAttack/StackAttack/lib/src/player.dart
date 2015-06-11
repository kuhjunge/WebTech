part of stackAttackLib;

/**
 * Playerklasse 
 */
class Player extends MovingElement {
    
  Player(int x, int y) : super(x, y){ 
    if(BLOCK_SIZE == 20){
      element.innerHtml = '<img src="'+PLAYER_STANDING+'"></img>';
    }
    else{
      element.classes.add(RED);
    }
    element.classes.add("player");
    element.style.height = BLOCK_SIZE.toString() + "px";
  }  
    

}