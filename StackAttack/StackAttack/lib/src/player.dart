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
    
  /**
   * Konstruktor
   */
  Player(int x, int y) : super(x, y, PLAYER_WIDTH*BLOCK_SIZE, PLAYER_HEIGHT*BLOCK_SIZE){    
    //element.innerHtml = '<img src="'+PICS_PATH+PLAYER.toString()+PICS_TYP+'" height="$_height px" width="$_width px"></img>';    
    addClass("player");
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