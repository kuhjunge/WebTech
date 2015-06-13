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
   * Liste sich bewegender Blöcke
   */
  List<Block> _movingBlocks = new List();
    
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
   * Füge einen Block zur MovingBlockList hinzu
   */
  void addMovingBlock(Block block){
    _movingBlocks.add(block);    
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
   * setter für _movingBlocks
   */
  //set movingBlocks(Block block) => _movingBlocks.add(block);
  
  /**
   * getter für _movingBlocks
   */
  //List<Block> get movingBlocksList => _movingBlocks.toList();
  
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
    for(int a = 0; a < BLOCKS_PER_ROW; a++){
      for(int b = BLOCK_ROWS; b > 0; b--){
        Block bl = getBlock(a, b);
        if( bl != null && !_movingBlocks.contains(bl)){
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
           for(int i = 0; i < BLOCKS_PER_ROW; i++){
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
   * Überprüft, ob Player und Block kollidieren
   */
  bool _playerCollision(Player p, Block b){    
    if( b.x == p.x && ( b.y == p.y || b.y == p.y +1) ){
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
    List<Block> tmpList = new List();

    for(Block e in _movingBlocks){      
        //bewege nach Rechts
        if( e.targetX > e.x){
          _moveOneBlock(e, e.x +1, e.y);
        }          
        else{
          //Abfrage auf Kollision mit Player
          if (_playerCollision(_player, e) ){
            return false;
          }
          // "fallen" bis unten maximal oder kollision Block 
          if ( ( e.y >= BLOCK_ROWS) 
            || ( getBlock( e.x, e.y + 1) != null ) ){          
            //Spiel verloren, wenn e.y == 0 bleibt
            if( e.y == 0 ){
              return false;
            }
            //füge zum Löschen aus Liste hinzu
            tmpList.add(e);                 
            //Lösche ganze Zeile, wenn Block bis nach ganz unten gefallen ist
            if( e.y >= BLOCK_ROWS){
              _checkDeletionOfFullRow(e.y);             
            }            
          } 
          else{
            _moveOneBlock(e, e.x, e.y+1);            
          }
        }
     }
    
    //lösche aus _movingElement Liste
    tmpList.forEach( (f) {
      _movingBlocks.remove(f);    
    });
    return true;
  }
    
  
  /**
   * Bewegt den Player
   */
  void movingPlayer(Direction d){  
      Player p = _player;
      switch( d ){
          case Direction.DOWN:
            break;
          case Direction.LEFT:   
            Block b = getBlock( p.x - 1, p.y + 1);
            Block aboveB = getBlock( p.x -1, p.y);       
            Block a = getBlock( p.x - 2, p.y + 1);            
            //bewege direkt den Player
            if(aboveB == null && b == null && p.x - 1 >= 0){
              p.x = p.x - 1;
              _playerFalling(p);
              break;
            }
            //verschiebe Block
            if( b != null && !_movingBlocks.contains(b) && aboveB == null && a == null && b.x - 1 >= 0){
              _moveOneBlock(b, b.x -1, b.y);
              _blockFalling(b);
              _checkDeletionOfFullRow(b.y);
              break;
            }                   
            break;
          case Direction.RIGHT:             
            Block b = getBlock( p.x + 1, p.y + 1);
            Block aboveB = getBlock( p.x + 1, p.y);       
            Block a = getBlock( p.x + 2, p.y + 1);
            //bewege direkt den Player
            if(aboveB == null && b == null && p.x + 1 < BLOCKS_PER_ROW){
              p.x = p.x + 1;
              _playerFalling(p);
              break;
            }
            //verschiebe Block
            if( b != null && !_movingBlocks.contains(b) && aboveB == null && a == null && b.x + 1 < BLOCKS_PER_ROW){
              _moveOneBlock(b, b.x + 1, b.y);
              _blockFalling(b);
              _checkDeletionOfFullRow(b.y);
              break;
            }                    
            break;
          case Direction.TOPLEFT:                 
            Block b = getBlock( p.x - 1, p.y);
            Block aboveB = getBlock( p.x - 1, p.y - 1);       
            Block a = getBlock( p.x - 2, p.y);            
            //bewege direkt den Player
            if(aboveB == null && b == null && p.x - 1 >= 0){
              p.x = p.x - 1;
              p.y = p.y -1;
              _playerFalling(p);
              break;
            }
            //verschiebe Block
            if( b != null  && !_movingBlocks.contains(b)&& aboveB == null && a == null && b.x -1 >= 0){
              _moveOneBlock(b, b.x -1, b.y);
              _blockFalling(b);
              _checkDeletionOfFullRow(b.y); 
              break;
            }                    
            break;
          case Direction.TOPRIGHT:
            Block b = getBlock( p.x + 1, p.y);
            Block aboveB = getBlock( p.x + 1, p.y - 1);       
            Block a = getBlock( p.x + 2, p.y);            
            //bewege direkt den Player
            if(aboveB == null && b == null && p.x + 1 < BLOCKS_PER_ROW){
              p.x = p.x + 1;
              p.y = p.y -1;
              _playerFalling(p);
              break;
            }
            //verschiebe Block
            if( b != null  && !_movingBlocks.contains(b)&& aboveB == null && a == null && b.x + 1 < BLOCKS_PER_ROW){
              _moveOneBlock(b, b.x +1, b.y);
              _blockFalling(b);
              _checkDeletionOfFullRow(b.y); 
              break;
            }                                                        
            break;
      }     
    
    
  }
  
  
  /**
   * Abfrage, ob Player fallen muß
   */
  void _playerFalling(Player p){   
    while( p.y + 1 < BLOCK_ROWS && getBlock(p.x, p.y + 2) == null){//TODO 2*BLOCK_SIZE modular gestalten
            p.y = p.y + 1;
    }
  }
  
  void _blockFalling(Block b){    
    while( b.y < BLOCK_ROWS && getBlock( b.x, b.y + 1) == null){          
      _moveOneBlock(b, b.x, b.y + 1);          
    }
  }
  
}