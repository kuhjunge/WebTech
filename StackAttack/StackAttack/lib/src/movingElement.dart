part of stackAttackLib;

/**
 * abstracte Klasse für sich bewegende Elemente
 */
abstract class MovingElement{
  int _x, _y;
  DivElement _element;
   
   /**
    * Konstruktor
    */
   MovingElement(this._x, this._y){
     element = new DivElement();
     element.style
       ..left = (_x*BLOCK_SIZE).toString() + "px"
       ..top = (_y*BLOCK_SIZE).toString() + "px";
     element.style
       ..left = (_x*BLOCK_SIZE).toString() + "px"
       ..top = (_y*BLOCK_SIZE).toString() + "px";     
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
   
   DivElement get element => _element;
   set element(DivElement e) => _element = e;
   
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