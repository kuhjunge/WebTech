part of stackAttackLib;

/**
 * Block Class
 */
class Block extends MovingElement {  
  bool _isSolid;  
  String _color;
    
  /**
   * Konstruktor
   */
  Block(int x, int y, this._color, this._isSolid):super(x,y){    
    element.innerHtml = '<img src="'+PICS_PATH+BLOCK.toString()+PICS_TYP+'" height="$BLOCK_SIZE px" width="$BLOCK_SIZE px"></img>';
    element.classes
      ..add("block")
      ..add(_color);
  }
  
  
  
}
