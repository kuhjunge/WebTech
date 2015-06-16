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
  Block(int x, int y, this._color, this._isWalkable, this._isSolid):super(x,y){    
    element.innerHtml = '<img src="'+PICS_PATH+BLOCK.toString()+PICS_TYP+'" height="$BLOCK_SIZE px" width="$BLOCK_SIZE px"></img>';
    element.classes
      ..add("block")
      ..add(_color);
  }
  
  bool get isWalkable => _isWalkable;  
 
  /**
   * Für abgeleitete Klassen zu nutzen, wenn isWalkable==true
   */
  void walkThrough(Player p){  
  }
  
}
