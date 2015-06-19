part of stackAttackLib;

/**
 * Block Class
 */
class Block extends MovingElement {  
  bool _isWalkable = false;
  bool _isSolid = false; 
  String _color;
    
  /**
   * Konstruktor
   */
  Block(int x, int y, this._color, this._isWalkable, this._isSolid):super(x,y,BLOCK_SIZE, BLOCK_SIZE){ 
    addClass("block");
    addClass(_color);    
  }
  
  bool get isWalkable => _isWalkable;  
  bool get isSolid => _isSolid;
  
  /**
   * Für abgeleitete Klassen zu nutzen, wenn isWalkable==true
   */
  void walkThrough(Model m){  
  }
  
}
