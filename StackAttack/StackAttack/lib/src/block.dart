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
  }
  
  bool get isWalkable => _isWalkable;  
  bool get isSolid => _isSolid;
  String get color => _color;  
  
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
  
  void _rekDel(String color, Block tmp, List<Block> list, Model m){
    Block  left, right, top, down;    
    left = m.getBlock(tmp.x-1, tmp.y);
    right= m.getBlock(tmp.x+1, tmp.y);
    top = m.getBlock(tmp.x, tmp.y+1);
    down = m.getBlock(tmp.x, tmp.y-1);
    
    if(left != null && left.color == color && !list.contains(left)){
      list.add(left);
      _rekDel(color, left, list, m);
    }
    if(right != null && right.color == color && !list.contains(right)){
      list.add(right);
      _rekDel(color, right, list, m);
    }
    if(top != null && top.color == color && !list.contains(top)){
      list.add(top);
      _rekDel(color, top, list, m);
    }
    if(down != null && down.color == color && !list.contains(down)){
      list.add(down);
      _rekDel(color, down, list, m);
    } 
    
  }
  
  /**
   * Überprüft, ob zusammenhängende Blöcke an diesem dran sind
   */
  void blocksDeletion(Model m){
    List<Block> list = new List();
    list.add(this);    
    _rekDel(this.color, this, list, m);
  
    //min 3 zusammenhängende
    if(list.length >= 3){     
      //lösche gesammelte Blöcke
      list.forEach( (f) => m.deleteBlock(f));
      //zähle Punkte hoch  
       m.player.points += POINTS_PER_GROUPELEMENT*list.length;             
      //verschiebe den Rest nach unten
       m.allBlocksFallingDown();
      //verschiebe auch player nach unten
       m.player.falling(m);
    }
    
  }
  
  /**
    *  Lösche Zeile, wenn in übergebender Zeile alle Blöcke belegt sind
    */
   bool rowDeletion(Model m, row){        
            int counter = 0;
            List<Block> tmpList = new List();
                       
            //überprüfen
            for(int i = 0; i < BLOCKS_PER_ROW; i++){
             Block tmpBlock = m.getBlock(i, row);
             if( tmpBlock != null){
               counter++;
               tmpList.add(tmpBlock);
             }
            }
            //löschen
            if(counter == BLOCKS_PER_ROW){             
              //lösche Zeile
              tmpList.forEach( (e){
                m.deleteBlock(e);
              });
             //zähle Punkte hoch 
              m.player.points += POINTS_PER_ROW;             
             //verschiebe den Rest nach unten
              m.allBlocksFallingDown();
              //verschiebe auch player nach unten
              m.player.falling(m);
              return true;
            }
            return false;
   }  
   
}
