import 'dart:html';

/**
 * Ball Class
 */
class Ball{
  /**
   * das zugehörige DivElement im DOM-Tree
   */
  DivElement _element;
  /**
   * Position
   */
  int _x,_y;
  /**
   * Bewegungsvector
   */
  int _dx, _dy;
  
  /**
   * Konstruktor
   */
  Ball(this._x, this._y, this._dx, this._dy){
    _element = new DivElement();
    _element
      ..classes.add("ball");
  }
  
  DivElement get element => _element;
  set dx(int dx) => _dx = dx;
  set dy(int dy) => _dy = dy;
  
  set x(int x){
    _x = x;
    _setPos();
  }
  
  /**
   * setzt Position in DivElement
   */
  void _setPos(){
    _element.style
      ..left = (_x).toString()+"px"
      ..top = (_y).toString()+"px";
  }
  
  /**
   * Bewege Ball
   */
  void move(){
    _x += _dx;
    _y += _dy;
    _setPos();
  }
  
  /**
   * gebe die nächste Position an
   */
  List<int> nextPos(){
    List<int> list = new List<int>();
    list.add(_x+_dx);
    list.add(_y+_dy);
    list.add(_dx);
    list.add(_dy);
    return  list;
  }
  
}