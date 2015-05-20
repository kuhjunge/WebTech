part of test;

/**
 * Block Class
 */
class Block {
  int _x, _y;
  bool _isSolid;  
  String _color;
  DivElement _element;
  
  /**
   * Konstruktor
   */
  Block(this._x, this._y, this._color, this._isSolid){
    _element = new DivElement();
    _element.style
      ..left = ((_x-1)*BLOCK_SIZE).toString() + "px"
      ..top = ((BLOCK_ROWS - _y)*BLOCK_SIZE).toString() + "px";
    _element.classes
      ..add("block")
      ..add(_color);    
  }
  
  /**
   * getter
   */
  int get x => _x;
  int get y => _y;
  
  /**
   * setter
   */
  set x(int x) => _x = x;
  set y(int y) => _y = y;
  
  DivElement get getElement => _element;
}
