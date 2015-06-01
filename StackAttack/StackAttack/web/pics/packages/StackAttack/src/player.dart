part of test;

/**
 * Playerklasse
 * TODO wie leite ich Factory-Klassen ab??
 */
class Player {
  int _x, _y, _realX, _realY;
  ImageElement _element;
  
  Player(this._x, this._y){
    _element = new ImageElement();
    _element.classes.add("player");
    _element.style
          ..left = (_x*BLOCK_SIZE).toString() + "px"
          ..top =  (_y*BLOCK_SIZE).toString() + "px";
    _element.src = "pics/player_standing.png";
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
    
    ImageElement get getElement => _element;
    
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