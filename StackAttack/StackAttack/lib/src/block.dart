part of stackAttackLib;

/**
 * Block Class
 */
class Block extends MovingElement {  
  bool _isWalkable = false;
  bool _isSolid = false; 
  String _color;
    
  /**
   * Konstruktor
   */
  Block(int x, int y, this._color, this._isWalkable, this._isSolid):super(x,y,BLOCK_SIZE, BLOCK_SIZE){ 
    addClass("block");
    addClass(_color);
    image = PICS_PATH+BLOCK+PICS_TYP;
  }
  
  bool get isWalkable => _isWalkable;  
  bool get isSolid => _isSolid;
  
  /**
   * Für abgeleitete Klassen zu nutzen, wenn isWalkable==true
   */
  void walkThrough(Model m){  
  }
  
  /**
   * Bewege diesen Block;
   * return 0, wenn erfolgreich bewegt
   * return -1, wenn keine Bewegung erfolgt ist
   * return -2, wenn Block oben angekommen ist
   */
  int move(Model m){
      //bewege nach Rechts
      if( targetX > x){
        m.moveOneBlock(this, x +1, y);
        return 0;
      }
      else{        
        //"fallen" bis unten maximal oder kollision Block 
        if ( ( y >= BLOCK_ROWS) 
         || ( m.getBlock( x, y + 1) != null ) ){          
         //Spiel verloren, wenn y == 0 bleibt
         if( y == 0 ){
           return -2;
         }
         return -1;
        }
        else{
          m.moveOneBlock(this, x, y+1);
          return 0;
        }
      }
    return -1;
  }
  
  /**
   * Block fällt runter
   */
  void falling(Model m){
    while( y < BLOCK_ROWS &&  m.getBlock(x, y + 1) == null ) {       
      m.moveOneBlock(this, x, y +1 );      
    }         
  }
  
}
