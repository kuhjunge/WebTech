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
    element.innerHtml = '<img src="'+PICS_PATH+BLOCK+BLOCK_SIZE.toString()+PICS_TYP+'"></img>';
    element.classes
      ..add("block")
      ..add(_color);
  }
  
  
  
}
