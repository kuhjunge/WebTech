part of test;

/**
 * Model-Class
 * beinhaltet das Spielmodel 
 */
class Model{
  
  /**
   * Map aller Blöcke
   */
  Map<int, Block> _blockMap = new Map();
  
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
    _blockMap[block.y * BLOCKS_PER_ROW + block.x] = block;
  }
  
  /**
   * gibt die Values der BlockMap als List zurück
   */
  List<Block> get blocks => _blockMap.values.toList();
  
  /**
   * gibt den Block an übergebender Position x,y zurück
   */
  Block getBlock(int x, int y) => _blockMap[y*BLOCKS_PER_ROW+x];
  
  /**
   * setter für _movingBlocks
   */
  set movingBlocks(Block block) => _movingBlocks.add(block);
  
  /**
   * getter für _movingBlocks
   */
  List<Block> get movingBlockList => _movingBlocks.toList();
}