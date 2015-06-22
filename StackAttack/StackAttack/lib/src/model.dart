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
    _blockMap[block.nr.toString()] = block;
  }
    
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
  void deleteBlock(Block b){
    _blockMap.remove(b._x.toString()+" "+b.y.toString());
    _blockMap.remove(b.nr.toString());
  }
  
  /**
   * Alle Blöcke aus _blockMap fallen so weit sie können nach unten
   */
  void allBlocksFallingDown(){
    for(int a = 0; a < BLOCKS_PER_ROW; a++){
      for(int b = BLOCK_ROWS; b > 0; b--){
        Block bl = getBlock(a, b);
        if( bl != null && !_movingBlocks.contains(bl)){
          bl.falling(this);     
        }
      }
    }
  }
  
  /**
   * Bewege einen Block in _blockMap
   */
  void moveOneBlock(Block b, int newX, int newY){
    int oldX = b.x;
    int oldY = b.y;
    b.y = newY;
    b.x = newX;
    block = b;
    _blockMap.remove(oldX.toString()+" "+oldY.toString());
  }
    
  /**
   * Bewegt alle Blöcke in _movingBlockList
   * return 0 keine Collisionen
   * return -1 Block ist oben angekommen => Spiel verloren und Spielfeld gelöscht   
   * return -2 Block ist mit Spieler kollidiert 
   */
 int moveBlocks(){
    List<Block> tmpList = new List();

    for(Block e in _movingBlocks){      
      int value = e.move(this);
      //Überprüfung, ob Player mit diesem Block eine Collision hat
      int col = _player.collision(this, e); 
      if( col == -2 ){
        return -2;
      }
      if( col == -1){
        tmpList.add(e);
      }
      //Block bewegt sich nicht mehr
      //überprüfung, ob ganze Zeile oder zusammenhängende Blöcke gelöscht werden soll
      if(value == -1){
        tmpList.add(e);        
        if( !e.rowDeletion(this, e.y) ){           
          e.blocksDeletion(this);
        }
      }
      //Block ist oben angekommen => Player verliert Leben
      if(value == -2){
        return -1;
      }      
    }
    
    //lösche aus _movingElement Liste
    tmpList.forEach( (f) {
      _movingBlocks.remove(f);    
    });
    return 0;
  }
    
  
  /**
   * Bewegt den Player
   */
  void movingPlayer(Direction d){
      switch( d ){
          case Direction.DOWN:
            break;
          case Direction.LEFT:   
            _player.move(this, -1, 0, Direction.LEFT); 
            break;
          case Direction.RIGHT:
            _player.move(this, 1, 0, Direction.RIGHT);            
            break;
          case Direction.TOPLEFT:
            _player.move(this,  -1, -1, Direction.LEFT);
            break;
          case Direction.TOPRIGHT:           
            _player.move(this,  1, -1, Direction.RIGHT);
            break;
      }      
  }  
   
    
  /**
   * Gibt entweder ein Element aus _blockMap oder einen Spieler zurück
   */
  MovingElement getMovingElement(String nr) { 
    if( _player.nr == int.parse(nr)){
      return _player;
    }
        
    return _blockMap[nr];
  }
  
  /**
   * Gibt zurück, ob Block in _movingBlock-List ist
   */
  bool isAMovingBlock(Block b){
    return _movingBlocks.contains(b);
  }
  
}