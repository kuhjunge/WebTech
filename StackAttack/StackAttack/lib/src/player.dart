part of stackAttackLib;

/**
 * Playerklasse
 *  vorbereitet für abgeleitete andere Player mit anderen Dimensionen 
 */
class Player extends MovingElement {
    
  Player(int x, int y) : super(x, y){ 
    element.innerHtml = '<img src="'+PLAYER_STANDING+'"></img>';
    element.classes.add("player");    
  }  
  
  int getElementWidth(){    
        return BLOCK_SIZE;
      }
      
      int getElementHeight(){
        return BLOCK_SIZE * 2;
      }

}