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
  List<Block> _movingElements = new List();
    
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
  set movingElements(Block block) => _movingElements.add(block);
  
  /**
   * getter für _movingBlocks
   */
  List<Block> get movingElementsList => _movingElements.toList();
  
  /**
   * setter für Player
   */
  set player(Player player) => _player = player;
  
  /**
   * getter für player
   */
  Player get player => _player;
 
  /**
   * Alle Blöcke aus _blockMap fallen so weit sie können nach unten
   */
  void _allBlocksFallingDown(){
    for(int a = 0; a < FIELD_WIDTH; a +=BLOCK_SIZE){
      for(int b = FIELD_HEIGHT-BLOCK_SIZE; b > 0; b -=BLOCK_SIZE){
        Block bl = getBlock(a, b);
        if( bl != null){
          _blockFalling(bl);     
        }
      }
    }
  }
  
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
               _blockMap.remove(e._x.toString()+" "+e.y.toString());
               e.element.remove();
             });
            //zähle Punkte hoch 
             _player.points += POINTS_PER_ROW;             
            //verschiebe den Rest nach unten
             _allBlocksFallingDown();
             //verschiebe auch player nach unten
             _playerFalling(_player);
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
   * Überprüft, ob die übergebenden Koordinaten im Player drin sind
   */
  bool _playerCollision(Player p, int x, int y){
    if( x >= p.x && x < p.x + BLOCK_SIZE && y+BLOCK_SIZE >= p.y && y < p.y + 2*BLOCK_SIZE ){
      return true;
    }
    else{
      return false;
    }
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
          //Abfrage auf Kollision mit Player
          if (_playerCollision(_player, e.x, e.y)){
            return false;
          }
          // "fallen" bis unten maximal oder kollision Block 
          if ( ( e.y >= FIELD_HEIGHT) 
            || ( getBlock( e.x, e.y + BLOCK_SIZE) != null ) ){          
            //Spiel verloren, wenn e.y == 0 bleibt
            if( e.y == 0 ){
              return false;
            }
            // lösche aus _movingElement Liste und füge zu blockList hinzu
            _movingElements.removeAt(i);      
             block = e;
            //Lösche ganze Zeile, wenn Block bis nach ganz unten gefallen ist
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
    // TODO Bewegung - contra Kollisiondetection überprüfen; wenn Block verschoben teilweise gestorben      
      switch( d ){
          case Direction.DOWN:
            break;
          case Direction.LEFT:                
                  Block b = getBlock(_player.x - BLOCK_SIZE, _player.y + BLOCK_SIZE);
                  //Abfrage ob Bock verschiebbar ist
                  if( b != null){
                    Block a = getBlock(b.x - BLOCK_SIZE, b.y);
                    Block aboveB = getBlock(b.x, b.y - BLOCK_SIZE);
                    if( aboveB == null && a == null && b.x - BLOCK_SIZE >= 0){
                      _moveOneBlock(b, b.x-BLOCK_SIZE, b.y);
                      _blockFalling(b);
                      _checkDeletionOfFullRow(b.y);
                    }
                  }
                  else{
                    if(_player.x >= BLOCK_SIZE){
                      _player.x = _player.x - BLOCK_SIZE;                      
                      _playerFalling(_player);
                    }
                  }                  
                  break;
          case Direction.RIGHT:                  
                  Block b = getBlock(_player.x + BLOCK_SIZE, _player.y + BLOCK_SIZE);
                  //Abfrage ob Bock verschiebbar ist
                  if( b != null){
                    Block a = getBlock(b.x + BLOCK_SIZE, b.y);
                    Block aboveB = getBlock(b.x, b.y - BLOCK_SIZE);
                    if( aboveB == null && a == null && b.x + BLOCK_SIZE < FIELD_WIDTH){
                      _moveOneBlock(b, b.x +BLOCK_SIZE, b.y);
                      _blockFalling(b);
                      _checkDeletionOfFullRow(b.y);
                    }
                  }      
                  else{
                    if(_player.x + BLOCK_SIZE < FIELD_WIDTH ){
                      _player.x = _player.x + BLOCK_SIZE;
                      _playerFalling(_player);
                    }
                  }
                  break;
          case Direction.TOPLEFT:
                  Block b = getBlock( _player.x - BLOCK_SIZE, _player.y);
                  if( b != null){
                    Block a = getBlock(b.x - BLOCK_SIZE, b.y);
                    Block aboveB = getBlock(b.x, b.y - BLOCK_SIZE);
                    if( aboveB == null && a == null && b.x - BLOCK_SIZE >= 0){
                      _moveOneBlock(b, b.x-BLOCK_SIZE, b.y);
                      _blockFalling(b);
                      _checkDeletionOfFullRow(b.y);
                    }                    
                  }
                  else{                    
                    if(_player.x >= BLOCK_SIZE){
                      _player.x = _player.x - BLOCK_SIZE;
                      _player.y = _player.y - BLOCK_SIZE;
                      _playerFalling(_player);
                    }
                  }
                  break;
          case Direction.TOPRIGHT:
                 Block b = getBlock(_player.x + BLOCK_SIZE, _player.y);                 
                 if( b != null){
                   Block a = getBlock(b.x + BLOCK_SIZE, b.y);
                   Block aboveB = getBlock(b.x, b.y - BLOCK_SIZE);
                   if( aboveB == null && a == null && b.x + BLOCK_SIZE < FIELD_WIDTH){
                    _moveOneBlock(b, b.x +BLOCK_SIZE, b.y);
                    _blockFalling(b);
                    _checkDeletionOfFullRow(b.y);
                   }                 
                 }
                 else{                   
                   if(_player.x + BLOCK_SIZE < FIELD_WIDTH){
                      _player.x = _player.x + BLOCK_SIZE;
                      _player.y = _player.y - BLOCK_SIZE;
                      _playerFalling(_player);
                   }
                 }                 
                 break;
      }     
    
    
  }
  
  /**
   * Abfrage, ob Player fallen muß
   */
  void _playerFalling(Player p){   
    while( p.y + BLOCK_SIZE < FIELD_HEIGHT && getBlock(p.x, p.y + 2*BLOCK_SIZE) == null){//TODO 2*BLOCK_SIZE modular gestalten
            p.y = p.y + BLOCK_SIZE;
    }
  }
  
  void _blockFalling(Block b){    
    while( b.y < FIELD_HEIGHT && getBlock( b.x, b.y + BLOCK_SIZE) == null){          
      _moveOneBlock(b, b.x, b.y + BLOCK_SIZE);          
    }
  }
  
}