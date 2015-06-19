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
  Model(){    
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
 // List<Block> get blocks => _blockMap.values.toList();
  
  /**
   * gibt den Block an übergebender Position x,y zurück
   */
  Block getBlock(int x, int y) => _blockMap[(x).toString() + " " + (y).toString()];
   
  /**
   * setter für Player
   */
  set player(Player player) => _player = player;
  
  /**
   * getter für player
   */
  Player get player => _player;
 
  /**
   * löscht einen Block aus _blockMap 
   */
  void _deleteBlock(Block b){
    _blockMap.remove(b._x.toString()+" "+b.y.toString());
  }
  
  /**
   * Alle Blöcke aus _blockMap fallen so weit sie können nach unten
   */
  void allBlocksFallingDown(){
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
               _deleteBlock(e);
             });
            //zähle Punkte hoch 
             _player.points += POINTS_PER_ROW;             
            //verschiebe den Rest nach unten
             allBlocksFallingDown();
             //verschiebe auch player nach unten
             _playerFalling(_player);
           }        
  }
  
  /**
   * Bewege einen Block in _blockMap
   */
  void _moveOneBlock(Block b, int newX, int newY){
    int oldX = b.x;
    int oldY = b.y;
    b.y = newY;
    b.x = newX;
    block = b;
    _blockMap.remove(oldX.toString()+" "+oldY.toString());
  }
    
  /**
   * Überprüft, ob Player und Block kollidieren
   */
  bool _playerCollision(Player p, Block b){    
    if( b.x == p.x &&  b.y == p.y ){
      return true;
    }
    else{
      return false;
    }
  }
  
  /**
   * Bewegt alle Blöcke in _movingBlockList
   * return 0 keine Collisionen
   * return -1 Block ist oben angekommen => Spiel verloren und Spielfeld gelöscht
   * return -2 Block hat Spieler getroffen => Spiel verloren;
   */
 int moveBlocks(){
    List<Block> tmpList = new List();

    for(Block e in _movingBlocks){      
        //bewege nach Rechts
        if( e.targetX > e.x){
          _moveOneBlock(e, e.x +1, e.y);
        }          
        else{
          //Abfrage auf Kollision mit Player
          if (_playerCollision(_player, e) ){
            if(e.isWalkable){
              e.walkThrough(this);
              _deleteBlock(e);
              tmpList.add(e);              
            }
            else{
              return -1;
            }
          }
          // "fallen" bis unten maximal oder kollision Block 
          if ( ( e.y >= BLOCK_ROWS) 
            || ( getBlock( e.x, e.y + 1) != null ) ){          
            //Spiel verloren, wenn e.y == 0 bleibt
            if( e.y == 0 ){
              return -2;
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
    return 0;
  }
    
  /**
   * der übergebende Player versucht x/y nach Direction.LEFT oder .RIGHT sich zu bewegen    
   * Entweder Bewegung Player oder Block wird verschoben
   */
  void _playerMove(Player p, int x, int y, Direction d){
    Block b = getBlock( p.x + x, p.y + 1 + y);
    Block aboveB = getBlock( p.x + x, p.y + y); 
    Block a;
    if(d == Direction.LEFT){
        a = getBlock( p.x -1 + x, p.y + 1 + y);
    }
    else{
      a = getBlock( p.x +1 + x, p.y + 1 + y);
    }
    //Abfrage, ob Block.isWalkable == true
    if(b != null && b.isWalkable && aboveB == null){
      b.walkThrough(this);
      _deleteBlock(b);
      p.x = p.x + x;
      p.y = p.y + y;
      _playerFalling(p);
      return;
    }
    //bewege direkt den Player
    if(aboveB == null && b == null && ((d==Direction.LEFT) ? (p.x + x  >= 0) : (p.x + x < BLOCKS_PER_ROW)) ){
      p.x = p.x + x;
      p.y = p.y + y;
      _playerFalling(p);
      return;
    }
    //verschiebe Block
    if( b != null && !b.isSolid && !_movingBlocks.contains(b) && aboveB == null && a == null 
        && ( (d==Direction.LEFT) ? (b.x +  x >= 0) : (b.x + x < BLOCKS_PER_ROW) )){
      _moveOneBlock(b, b.x +x, b.y);
      _blockFalling(b);
      _checkDeletionOfFullRow(b.y);
    }                
  }
  
  
  /**
   * Bewegt den Player
   */
  void movingPlayer(Direction d){
      switch( d ){
          case Direction.DOWN:
            break;
          case Direction.LEFT:   
            _playerMove(_player, -1, 0, Direction.LEFT); 
            break;
          case Direction.RIGHT:
            _playerMove(_player, 1, 0, Direction.RIGHT);            
            break;
          case Direction.TOPLEFT:
            _playerMove(_player, -1, -1, Direction.LEFT);
            break;
          case Direction.TOPRIGHT:           
            _playerMove(_player, 1, -1, Direction.RIGHT);
            break;
      }
  }  
  
  /**
   * Abfrage, ob Player fallen muß
   */
  void _playerFalling(Player p){
    
    while( p.y + 1 < BLOCK_ROWS && ( getBlock(p.x, p.y + 2)==null ||  (getBlock(p.x, p.y + 2)!= null &&  getBlock(p.x, p.y + 2).isWalkable) ) ) { 
      Block  b = getBlock(p.x, p.y + 2);
      if( b != null && b.isWalkable){
        b.walkThrough(this);
        _deleteBlock(b);
      }
      p.y = p.y + 1;
    }
  }
  
  void _blockFalling(Block b){    
    while( b.y < BLOCK_ROWS && getBlock( b.x, b.y + 1) == null){          
      _moveOneBlock(b, b.x, b.y + 1);          
    }
  }
  
  /**
   * Gibt MovingElement für übergebende id zurück
   */
  MovingElement getMovingElement(int nr){
    MovingElement tmp = null;
    
    _blockMap.keys.toList().forEach( (f) {      
      if( _blockMap[f].nr == nr){
        tmp = _blockMap[f];
      }
    });    
    if( _player.nr == nr){
      tmp = _player;
    }
    return tmp;
  }
  
}