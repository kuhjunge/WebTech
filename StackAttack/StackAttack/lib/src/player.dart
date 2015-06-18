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
  int _life = START_LIFE;
  
  int _height = PLAYER_HEIGHT * BLOCK_SIZE;
  int _width  = PLAYER_WIDTH * BLOCK_SIZE;
  
  /**
   * Konstruktor
   */
  Player(int x, int y) : super(x, y){    
    element.innerHtml = '<img src="'+PICS_PATH+PLAYER.toString()+PICS_TYP+'" height="$_height px" width="$_width px"></img>';    
    element.classes.add("player");
    element.style
        ..width = (_width.toString() + "px")
        ..height = _height.toString()+"px";
  }  
    
  int get points => _points;
  set points(int p) => _points = p;
  
  int get life => _life; 
  set life(int l){
    if(l <= MAX_LIFE){
      _life = l;      
    }
  }
    
}