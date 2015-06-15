part of stackAttackLib;

/**
 * Playerklasse 
 */
class Player extends MovingElement {
  /**
   * Punktezähler
   */
  int _points = 0;
  
  /**
   * Anzahl der Leben
   */
  int _life = 3;
  String _height =  (2*BLOCK_SIZE).toString() + "px";
  Player(int x, int y, int life) : super(x, y){    
    element.innerHtml = '<img src="'+PICS_PATH+PLAYER.toString()+PICS_TYP+'" height="$_height px" width="$BLOCK_SIZE px"></img>';    
    element.classes.add("player");
    element.style.height = _height;
    _life = life;
  }  
    
  int get points => _points;
  set points(int p) => _points = p;
  
  int get life => _life;  
}