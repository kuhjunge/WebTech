part of stackAttackLib;

/**
 * abstracte Klasse für sich bewegende Elemente
 */
abstract class MovingElement{
  int _x, _y;
  int _targetX;
  DivElement _element;  
   
   /**
    * Konstruktor
    */
   MovingElement(this._x, this._y){
     _element = new DivElement();
     _element.style
                ..left = (_x).toString() + "px"
                ..top = (_y).toString() + "px"     
               ..width = getElementWidth().toString() + "px"
               ..height = getElementHeight().toString() + "px";     
   }
   
   /**
    * getter
    */
   int get x => _x;
   int get y => _y;
   
   /**
    * setter
    */
   set x(int x) {
     _x = x;
     _element.style.left = (_x).toString()+"px";
   }
     
   set y(int y){
     _y = y;
     _element.style.top = (_y).toString()+"px";
   }
   
   DivElement get element => _element;
   set element(DivElement e) => _element = e;
   
   int get targetX => _targetX;
   set targetX(int x) => _targetX = x; 
   
   /**
    * gibt berechnete Breite zurück
    */
   int getElementWidth();
   /**
    * gibt berechnete Höhe zurück
    */
   int getElementHeight();   

}