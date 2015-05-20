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
   
  
}