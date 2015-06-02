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
  List<MovingElement> _movingBlocks = new List();
  
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
   * setter für _movingBlocks
   */
  set movingBlocks(Block block) => _movingBlocks.add(block);
  
  /**
   * getter für _movingBlocks
   */
  List<Block> get movingBlockList => _movingBlocks.toList();
  
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
            for(int b = BLOCK_ROWS-1; b >= 0; b--)
            for(int a = 0; a < BLOCKS_PER_ROW; a++) {
              Block tmpBlock = this.getBlock(a, b);
              if(tmpBlock != null){
                
               _blockMap.remove(tmpBlock.x.toString()+" "+tmpBlock.y.toString());              
               tmpBlock.y = tmpBlock.y + 1;
               tmpBlock.realY = tmpBlock.y * BLOCK_SIZE;
               this.block = tmpBlock;
              }
            }
           }
        
  }
  /**
   * Kollisionsdetection ob Block unter übergebenden Block ist   * 
   */
  bool _kollisionWithBlock(MovingElement block){
    int y = block.realY ~/ BLOCK_SIZE ;
    if( this.getBlock(block.x, y +1) != null || y == BLOCK_ROWS){
        _movingBlocks.remove(block);
        block.y = y;
        block.realY = block.y * BLOCK_SIZE;
        this.block = block;
        
        //Überprüfe, ob ganze Zeile gelöscht werden muß
        if(y == BLOCK_ROWS){
          checkDeletionOfFullRow(y);
        }
        
        return true;
    }    
    
    return false;
  }
  
  bool _kollisionWithPlayer(MovingElement block){
    return false;
  }
  
  /**
   * Bewegt alle Blöcke in _movingBlockList
   */
  bool moveBlocks(){
    
    movingBlockList.forEach( (e) {
      //TODO es lassen sich die +2 eventuell noch auslagern
        
      
        //bewege nach Rechts
         if(e.realX < e.x * BLOCK_SIZE){
           e.realX += 2;        
         }//bewege nach unten
         else{
           e.realX = e.x * BLOCK_SIZE;
           
           //Überprüfe, ob Kollision mit Block
           if( ! _kollisionWithBlock(e) ){
             e.realY += 2;  
           }
           //Überprüfe, ob Kollision mit Spieler
           if( !_kollisionWithPlayer(e) ){
                   
           }
           
         }
       });
    
    /*
     * Überprüfe, ob ein Block in 0ter Zeile ist
     */
    for(int i = 0; i < BLOCKS_PER_ROW; i++){
         if( this.getBlock(i, 0) != null)
           return false;
       }
    return true;
  }
  
  /**
   * Bewegt den Computerspieler
   */
  void movingPlayer(var key){
    
    switch( key.keyCode ){
          case KeyCode.LEFT:
                  _player.realX -= 10;
                  break;
          case KeyCode.RIGHT:
                  _player.realX += 10;
                  break;
          case KeyCode.UP:
                  _player.realY -= 50;
                  break;                
        }
  }
  
}