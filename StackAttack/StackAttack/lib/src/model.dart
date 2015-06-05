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
  void _checkDeletionOfFullRow(var row){        
           int counter = 0;
           List<Block> tmpList = new List();
                      
           //überprüfen
           for(int i = 0; i < FIELD_WIDTH; i++){
            Block tmpBlock = getBlock(i, row);
            if( tmpBlock != null){
              counter++;
              tmpList.add(tmpBlock);
            }
           }
           //löschen
           if(counter == BLOCKS_PER_ROW){             
             //lösche Zeile
             tmpList.forEach( (e){
               _blockMap.remove(e);
               e.element.remove();
             });
            //TODO zähle Punkte hoch
            //verschiebe den Rest nach unten
             for(int a = 0; a < FIELD_WIDTH; a+=BLOCK_SIZE){
               for(int b = row; b > 0; b-=BLOCK_SIZE){
                Block bl = getBlock(a, b);
                if( bl != null){
                  _moveOneBlock(bl, bl.x, bl.y + BLOCK_SIZE);     
                }
               }
             }
           }        
  }
  
  /**
   * Bewege einen Block in _blockMap
   */
  void _moveOneBlock(Block b, int newX, int newY){
    _blockMap.remove(b.x.toString()+" "+b.y.toString());
    b.y = newY;
    b.x = newX;
    block = b;
  }
    
  /**
   * Bewegt alle Blöcke in _movingBlockList
   * return false Block ist oben angekommen => Spiel verloren;
   * return false Block hat Spieler getroffen => Spiel verloren;
   */
  bool moveBlocks(){
    
    for( int i = 0; i < _movingElements.length; i++){
      var e = _movingElements.elementAt(i);
        //bewege nach Rechts
        if( e.targetX > e.x){
          e.x = e.x + 1;
        }
        else{          
          //setze e.x richtig
          e.x = e.targetX;
          // "fallen" bis unten maximal oder kollision mit Player oder Block 
          if ( ( e.y >= FIELD_HEIGHT) 
            || ( getBlock( e.x, e.y + BLOCK_SIZE) != null )
            /*|| TODO abfrage, Playerkollision */){          
            //Spiel verloren, wenn e.y == 0 bleibt
            if( e.y == 0){
              return false;
            }
            // lösche aus _movingElement Liste und füge zu blockList hinzu
            _movingElements.removeAt(i);      
             block = e;//TODO nur, wenn es ein Block und kein Player ist
            //Lösche vielleicht ganze Zeile, wenn Block bis nach ganz unten gefallen ist
            if( e.y + BLOCK_SIZE >= FIELD_HEIGHT){
              _checkDeletionOfFullRow(e.y);
            }
            
          } 
          else{
            e.y = e.y + 1;
          }
        }
     }
    
    return true;
  }
  
  
  
  /**
   * Bewegt den Computerspieler
   */
  void movingPlayer(Direction d){
      
      switch( d ){
          case Direction.DOWN:
            break;
          case Direction.LEFT:                
                  Block b = getBlock(_player.x - BLOCK_SIZE, _player.y + BLOCK_SIZE);
                  //Abfrage ob Bock verschiebbar ist
                  if( b != null){
                    Block a = getBlock(b.x - BLOCK_SIZE, b.y);
                    if( a == null && b.x - BLOCK_SIZE >= 0){
                      _moveOneBlock(b, b.x-BLOCK_SIZE, b.y);                      
                    }
                  }
                  else{
                    if(_player.x >= BLOCK_SIZE){
                      _player.x = _player.x - BLOCK_SIZE;                      
                      _playerFalling();
                    }
                  }                  
                  break;
          case Direction.RIGHT:                  
                  Block b = getBlock(_player.x + BLOCK_SIZE, _player.y + BLOCK_SIZE);
                  //Abfrage ob Bock verschiebbar ist
                  if( b != null){
                    Block a = getBlock(b.x + BLOCK_SIZE, b.y);
                    if( a == null && b.x + BLOCK_SIZE < FIELD_WIDTH){
                      _moveOneBlock(b, b.x +BLOCK_SIZE, b.y);
                    }
                  }      
                  else{
                    if(_player.x + BLOCK_SIZE < FIELD_WIDTH ){
                      _player.x = _player.x + BLOCK_SIZE;
                      _playerFalling();
                    }
                  }
                  break;
          case Direction.TOPLEFT:
                  _player.x = _player.x - BLOCK_SIZE;
                  _player.y = _player.y - BLOCK_SIZE;
                  _playerFalling();
                  break;
          case Direction.TOPRIGHT:
                 _player.x = _player.x + BLOCK_SIZE;
                 _player.y = _player.y - BLOCK_SIZE;
                 _playerFalling();
                 break;
      }     
    
    
  }
  
  /**
   * Abfrage, ob Player fallen muß
   */
  void _playerFalling(){   
    while( _player.y + BLOCK_SIZE < FIELD_HEIGHT && getBlock(_player.x, _player.y + 2*BLOCK_SIZE) == null){
            _player.y = _player.y + BLOCK_SIZE;
    }
  }
  
}