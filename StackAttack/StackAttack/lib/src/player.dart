part of stackAttackLib;

/**
 * Playerklasse
 * TODO wie leite ich Factory-Klassen ab??
 */
class Player extends MovingElement {
    
  Player(int x, int y) : super(x, y){     
    element.classes.add("player");
    element.innerHtml = '<img src="pics/player_standing.png"></img>';    
     
  }
    

}