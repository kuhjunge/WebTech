part of stackAttackLib;

/**
 * abstracte Klasse für sich bewegende Elemente
 */
abstract class MovingElement{
  int _x, _y;
  int _targetX;
    
  int _height;
  int _width;
  int _nr;
  
  List<String> _classes = new List();
    
   /**
    * Konstruktor
    */
   MovingElement(this._x, this._y, this._width, this._height){
     _nr = nrCounter;
     nrCounter++;
     addClass("MovingElement");
   }
   
   /**
    * getter
    */
   int get x => _x;
   int get y => _y;
   int get height => _height;
   int get width => _width;
   int get targetX => _targetX;
   List<String> get classes => _classes;
   int get nr => _nr;
   
   /**
    * setter
    */
   set x(int x) =>  _x = x;     
   set y(int y) => _y = y;
   set targetX(int x) => _targetX = x;
   
   /**
    * fügt eine Klasse hinzu
    */
   void addClass(String c) {
     _classes.add(c);
   }

}