part of stackAttackLib;

/**
 * Model-Class
 * beinhaltet das Spielmodel 
 */
class Model{
  
  /**
   * Der Spieler
   */
  Player _player;  
  
  /**
   * Map aller Blöcke
   */
  Map<String, Block> _blockMap = new Map();
  
  /**
   * Liste sich bewegender Elemente
   */
  List<MovingElement> _movingElements = new List();
  
  /**
   * Default-Konstruktor
   */
  model(){    
  }
  
  /**
   * fügt einen Block zur Blockmap hinzu
   */
  set block(Block block) {
    _blockMap[(block.x).toString() + " " + (block.y).toString()] = block;
  }
  
  /**
   * gibt die Values der BlockMap als List zurück
   */
  List<Block> get blocks => _blockMap.values.toList();
  
  /**
   * gibt den Block an übergebender Position x,y zurück
   */
  Block getBlock(int x, int y) => _blockMap[(x).toString() + " " + (y).toString()];
  
  /**
   * setter für _movingElements
   */
  set movingElements(MovingElement block) => _movingElements.add(block);
  
  /**
   * getter für _movingBlocks
   */
  List<MovingElement> get movingElementsList => _movingElements.toList();
  
  /**
   * setter für Player
   */
  set player(Player player) => _player = player;
  
  /**
   * getter für player
   */
  Player get player => _player;
  
  /**
   *  Lösche Zeile, wenn in übergebender Zeile alle Blöcke belegt sind
   */
  void checkDeletionOfFullRow(var row){        
           int counter = 0;
           List<Block> tmpList = new List();
                      
           //überprüfen
           for(int i = 0; i < BLOCKS_PER_ROW; i++){
            Block tmpBlock = this.getBlock(i, row);
            if( tmpBlock != null){
              counter++;
              tmpList.add(tmpBlock);
            }
           }
           //löschen
           if(counter == BLOCKS_PER_ROW){
            tmpList.forEach( (e) {
              _blockMap.remove(e.x.toString()+" "+e.y.toString());
              e.element.remove();
            });
            //TODO zähle Punkte hoch
            // verschiebe alle anderen Blöcke nach unten
            _blockMap.forEach( (s,b) {
              b.x += b.getElementHeight();
            });
           }
        
  }
  /**
   * Kollisionsdetection ob Block unter übergebenden Block ist    
   */
  bool _kollisionWithBlock(int posX, int posY){
             
    if( getBlock(posX, posY) != null){
      return true;
    }   
    
    return false;
  }
  
  bool _kollisionWithPlayer(int posY){
    return false;
  }
  
  /**
   * Bewegt alle Blöcke in _movingBlockList
   * return false Block ist oben angekommen => Spiel verloren;
   */
  bool moveBlocks(){
    
    for( int i = 0; i < _movingElements.length; i++){
      var e = _movingElements.elementAt(i);
        //bewege nach Rechts
        if( e.targetX > e.x){
          e.x = e.x + 3;
        }
        else{          
          //setze e.x richtig
          e.x = e.targetX;
          // "fallen" bis unten maximal oder kollision mit Player oder Block 
          if ( ( e.y >= FIELD_HEIGHT) 
            || ( _kollisionWithBlock( e.x, e.y + e.getElementHeight()))//TODO Fehler bei Kollisionsdetection, aufGrund der unterschiedlichen e.y bewegung
            || ( _kollisionWithPlayer(e.y + e.getElementHeight())) ){          
            //Spiel verloren, wenn e.y == 0 bleibt
            if( e.y == 0){
              return false;
            }
            //Lösche vielleicht ganze Zeile, wenn Block bis nach ganz unten gefallen ist
            if( e.y >= FIELD_HEIGHT){
              checkDeletionOfFullRow(e.y+e.getElementHeight());
            }
            // lösche aus _movingElement Liste und füge zu blockList hinzu
            _movingElements.removeAt(i);      
            block = e;//TODO nur, wenn es ein Block und kein Player ist
          } 
          else{
            e.y = e.y + 3;
          }
        }
     }
    
    return true;
  }
  
  /**
   * Bewegt den Computerspieler
   */
  void movingPlayer(var key){
    /*
    switch( key.keyCode ){
          case KeyCode.LEFT:
                  
                  break;
          case KeyCode.RIGHT:
                  
                  break;
          case KeyCode.UP:
                  
                  break;                
        }*/
  }
  
}