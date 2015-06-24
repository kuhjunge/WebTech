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
  
  /**
   * Überprüft, ob zusammenhängende Blöcke an diesem dran sind
   */
  void blocksDeletion(Model m){
    int counter = 1;
    //a)
    Block tmpBlock = m.getBlock(x-1, y);   
    if( tmpBlock != null && tmpBlock.color.compareTo(color) == 0 ) {
      counter++;
      tmpBlock = m.getBlock(x-2, y);
      if( tmpBlock != null && tmpBlock.color.compareTo(color) == 0 ) {
        counter++;
      }
      tmpBlock = m.getBlock(x-1, y-1);
      if( tmpBlock != null && tmpBlock.color.compareTo(color) == 0 ) {
        counter++;
      }
      tmpBlock = m.getBlock(x-1, y+1);
      if( tmpBlock != null && tmpBlock.color.compareTo(color) == 0 ) {
        counter++;
      }
    }
    //b)
    tmpBlock = m.getBlock(x+1, y);   
    if( tmpBlock != null && tmpBlock.color.compareTo(color) == 0 ) {
      counter++;
      tmpBlock = m.getBlock(x+2, y);
      if( tmpBlock != null && tmpBlock.color.compareTo(color) == 0 ) {
        counter++;
      }
      tmpBlock = m.getBlock(x+1, y-1);
      if( tmpBlock != null && tmpBlock.color.compareTo(color) == 0 ) {
        counter++;
      }
      tmpBlock = m.getBlock(x+1, y+1);
      if( tmpBlock != null && tmpBlock.color.compareTo(color) == 0 ) {
        counter++;
      }
    }
    //c)
    tmpBlock = m.getBlock(x, y-1);   
    if( tmpBlock != null && tmpBlock.color.compareTo(color) == 0 ) {
      counter++;
      tmpBlock = m.getBlock(x, y-2);
      if( tmpBlock != null && tmpBlock.color.compareTo(color) == 0 ) {
        counter++;
      }
      tmpBlock = m.getBlock(x-1, y-1);
      if( tmpBlock != null && tmpBlock.color.compareTo(color) == 0 ) {
        counter++;
      }
      tmpBlock = m.getBlock(x+1, y-1);
      if( tmpBlock != null && tmpBlock.color.compareTo(color) == 0 ) {
        counter++;
      }
    }
    //d)
    tmpBlock = m.getBlock(x, y+1);   
    if( tmpBlock != null && tmpBlock.color.compareTo(color) == 0 ) {
      counter++;
      tmpBlock = m.getBlock(x, y+2);
      if( tmpBlock != null && tmpBlock.color.compareTo(color) == 0 ) {
        counter++;
      }
      tmpBlock = m.getBlock(x-1, y+1);
      if( tmpBlock != null && tmpBlock.color.compareTo(color) == 0 ) {
        counter++;
      }
      tmpBlock = m.getBlock(x+1, y+1);
      if( tmpBlock != null && tmpBlock.color.compareTo(color) == 0 ) {
        counter++;
      }
    }
  
    //min 3 zusammenhängende
    if(counter >= 3){     
      _rekDelete(m, this);
      //zähle Punkte hoch  
       m.player.points += POINTS_PER_GROUPELEMENT*counter;             
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
  
   /**
    * Rekursives Löschen zusammenhängender Blöcke
    */
   void _rekDelete(Model m, Block b){
     int x_t = b.x;
     int y_t = b.y;
     String color_t = b.color;
     //Lösche Block
     m.deleteBlock(b);
     //lösche Nachbarn, wenn gleiche Farbe
     Block tmpBlock = m.getBlock(x_t - 1, y_t);
     if( tmpBlock != null && tmpBlock.color.compareTo(color_t) == 0 ){
       _rekDelete(m, tmpBlock);       
     }
     tmpBlock = m.getBlock(x_t + 1, y_t);
     if( tmpBlock != null && tmpBlock.color.compareTo(color_t) == 0 ){
       _rekDelete(m, tmpBlock);       
     }
     tmpBlock = m.getBlock(x_t, y_t -1 );
     if( tmpBlock != null && tmpBlock.color.compareTo(color_t) == 0 ){
       _rekDelete(m, tmpBlock);       
     }
     tmpBlock = m.getBlock(x_t, y_t+1);
     if( tmpBlock != null && tmpBlock.color.compareTo(color_t) == 0 ){
       _rekDelete(m, tmpBlock);       
     }     
     
   }
   
}
