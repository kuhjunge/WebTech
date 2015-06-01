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
      ..left = (_x*BLOCK_SIZE).toString() + "px"
      ..top = (_y*BLOCK_SIZE).toString() + "px";
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
  
  /**
   * tatsächliche Position x/y
   */
  int get realX {
    String  str = _element.style.left;
    str = str.substring(0, str.length-2);
    return int.parse(str, onError: (_)=> 0);
  }
  int get realY {
      String  str = _element.style.top;
      str = str.substring(0, str.length-2);
      return int.parse(str, onError: (_)=> 0);
    }
  set realX(int x) => _element.style.left = x.toString()+"px";

  set realY(int y) => _element.style.top = y.toString()+"px";
}
