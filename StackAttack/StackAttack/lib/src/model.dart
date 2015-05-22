part of test;

/**
 * Model-Class
 * beinhaltet das Spielmodel 
 */
class Model{
  
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
   * Kollisionsdetection ob Block unter übergebenden Block ist
   */
  bool kollisionDetection(Block block){
    int y = block.realY ~/ BLOCK_SIZE ;
    if( this.getBlock(block.x, y +1) != null || y == BLOCK_ROWS){
        _movingBlocks.remove(block);
        block.y = y;
        block.realY = block.y * BLOCK_SIZE;
        this.block = block;
        // Lösche Zeile, wenn block in unterste Zeile gefallen ist
        if(y == BLOCK_ROWS){
          int counter = 0;
          List<Block> tmpList = new List();
          //überprüfen
          for(int i = 0; i < BLOCKS_PER_ROW; i++){
           Block tmpBlock = this.getBlock(i, y);
           if( tmpBlock != null){
             counter++;
             tmpList.add(tmpBlock);
           }
          }
          //löschen
          if(counter == BLOCKS_PER_ROW){
           tmpList.forEach( (e) {
             _blockMap.remove(e.x.toString()+" "+e.y.toString());
             e.getElement.remove();             
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
        return true;
    }    
    
    return false;
  }
  
  /**
   * Überprüfe, ob ein Block in 0ter Zeile ist
   */
  bool isLost(){
    for(int i = 0; i < BLOCKS_PER_ROW; i++){
      if( this.getBlock(i, 0) != null)
        return true;
    }
    return false;
  }
  
}