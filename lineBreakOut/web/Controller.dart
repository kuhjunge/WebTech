import 'dart:async';
import 'dart:html';
import 'Ball.dart';

//Konstante
const int FIELD_HEIGHT = 600;
const int FIELD_WIDTH = 600;
const int CURSOR_TOP = FIELD_HEIGHT - 50;
const int CURSOR_START_WIDTH = 50;
const int CURSOR_HEIGHT = 10;
const int BLOCK_WIDTH = 40;
const int BLOCK_HEIGHT = 20;
const int BALL_WIDTH = 10;
//------------------------

/**
 * Controller-Class
 */
class Controller{
  /**
   * das verwendete Model
   */
  Model _model;
  /**
   * der verwendete View
   */
  View _view;
  /**
   * Timer
   */
  Timer _timer;
  
  /**
   * gestartet
   */
  bool started = false;
  
  /**
   * pausiert
   */
  bool paused = false;
  
  /**
   * Konstruktor
   */
  Controller(Model m){
    _model = m;
    _timer = new Timer.periodic(new Duration(milliseconds: 1), (_)=> timerEvent() );
  }
  
  /**
   * Verarbeitet die Cursor-Bewegungen
   */
  void moveCursor(var ev){
    if(ev >= FIELD_WIDTH - _model.cursor.width){      
      _model.cursor.x = FIELD_WIDTH - _model.cursor.width;  
    }
    else{
      _model.cursor.x = ev;
    } 
    /*
     * setze x-Position des Startballs mit 
     */
    if(!started){
      _model.balls.first.x = _model.cursor.x+_model.cursor.width~/2;      
    }
  }
  
  /**
   * das Timer-Event
   */
  void timerEvent(){
    if( started ){
      _model.move();      
    }
  }

  /**
   * Setter für den View
   */
  set view(View v) => _view = v;
  
  /**
   * lade Level 
   */
  void loadLevel(){
    //TODO xml documente einladen
    /*
    Block block = new Block(1,1,BLOCK_WIDTH, BLOCK_HEIGHT,"redBlock",1,false);
    _model.block = block;
    _view.addElement(block.element);
    block = new Block(14,2,BLOCK_WIDTH, BLOCK_HEIGHT,"blueBlock",1,false);
    _model.block = block;
    _view.addElement(block.element);
    block = new Block(6,6,BLOCK_WIDTH, BLOCK_HEIGHT,"greenBlock",1,false);
    _model.block = block;
    _view.addElement(block.element);
    block = new Block(14,10,BLOCK_WIDTH, BLOCK_HEIGHT,"solidBlock",0,true);
    _model.block = block;
    _view.addElement(block.element);*/
    for(int i = 2; i < 12; i++){
      for(int a = 2; a < 20; a++){
        Block block = new Block(i,a,BLOCK_WIDTH, BLOCK_HEIGHT,"greenBlock",1,false);
        _model.block = block;
        _view.addElement(block.element);
        
      }
    }
  }
  
  /**
   * Startet neues Spiel
   */
  void startGame(){
    /*
     * TODO level laden ergänzen für mehrere Level
     */
     this.loadLevel();
     /*
      * cursor erstellen und hinzufügen
      */
     Cursor cursor = new Cursor(0,CURSOR_TOP, CURSOR_START_WIDTH);
     _view.addElement(cursor.element);
     _model.cursor = cursor;
     
     Ball ball = new Ball(CURSOR_START_WIDTH~/2,CURSOR_TOP-CURSOR_HEIGHT-1,1,-1);
     _view.addElement(ball.element);
     _model.ball = ball;
               
  }
  
}

/**
 * View
 */
class View{
  /**
   * Das html-Body-Element
   */
  Element _body;
  /**
   * zuständiger Controller
   */
  Controller _control;
  
  /**
   * Konstruktor
   * Übergabe des body-Elements der html-Seite
   * Initialisierung
   */
  View(Element body, Controller control){
    _body = body;
    _control = control;
    /*
     * Listener für Cursor
     */
    _body.onMouseMove.listen((e) => _control.moveCursor(e.clientX));
    _body.onKeyPress.listen( (e){
      //TODO einfügen der von Keyboard-Steuerung !!!!!!!!!!!!!!!!!!!!!!    
    });
    /*
     * Listener für Pause game und aktivate ball
     */
    _body.onMouseDown.listen( (e) {
      //TODO pause funktion
      if( !_control.started ){
        _control.started = true;
      }
      
    });
    
  }
  
  /**
   * Füge DivElement zu html hinzu
   */
  void addElement(DivElement elem){
    _body.append(elem);    
  }  
}


/**
 * Model-Class
 * beinhaltet das Spielmodel 
 */
class Model{
  
  /**
   * Liste aller Blöcke
   */
  List<Block> _blockList = new List<Block>();

  /**
   * Liste aller Bälle
   */
  List<Ball> _balls = new List<Ball>();
  
  /**
   * Cursor
   */
  Cursor _cursor;
  
  /**
   * Default-Konstruktor
   */
  Model(){    
    /*
     * füge drei Blöcke für die Wände hinzu
     */
    _blockList.add( new Block(-1, -1, FIELD_WIDTH+2, 1, "",0, true));
    _blockList.add( new Block(-1, -1, 1, FIELD_HEIGHT+2, "",0, true));
    _blockList.add( new Block(FIELD_WIDTH, -1, 2, FIELD_HEIGHT+2, "",0, true));
  }
  
  /**
   * fügt einen Block zur Blocklist hinzu
   */
  set block(Block block) => _blockList.add(block);
  
  /**
   * gibt die ganze BlockList zurück
   */
  List<Block> get blocks => _blockList;
  
  /**
   * fügt Ball hinzu 
   */  
  set ball(Ball ball) => _balls.add(ball);
  
  /**
   * gibt alle Bälle zurück
   */
  List<Ball> get balls => _balls; 
  
  /**
   * fügt Cursor hinzu
   */
  set cursor(Cursor cursor) => _cursor = cursor;
  
  /**
   * gibt Cursor zurück
   */
  Cursor get cursor => _cursor;
  
  /**
   * Kollisionsberprüfung
   * Übergabe List mit neuen Positionswerten
   * Vergleich, ob am Rand oder mit Blöcken kollision erfolgen würde
   * und Bberechnung der neuen delta-Werte 
   */
  void collisionDetection(List<int> list, Ball ball){
    int x = list[0];
    int y = list[1];
    int dx = list[2];
    int dy = list[3];
   
    //TODO passe Kanten an, d.h. BALL_WIDTH muß +/- zu x/y gerechnet werden
    
    /*
     * Überprüfe auf Cursor-Kollision
     * TODO die abgerundeten Ecken müssen noch hinzugenommen werden 
     * TODO und die Bewegung des Cursor mit Einwirkung auf die Ballrichtung
     * TODO Abfrage klappt noch nicht ganz
     */
    if(y == _cursor.y && (x >= _cursor.x || x <= _cursor.x+_cursor.width)){
      ball.dy = -dy;
      return;
    }
    
    /*
     * Überprüfe alle Blöcke auf Kollision
     */
    for(int i = 0; i < _blockList.length; i++){      
      Block b = _blockList.elementAt(i);
      
      //damit ist der Ball im Block
      if(x >= b.x && x <= b.x+b.width && y >= b.y && y <= b.y+b.height){
        
        //Fall 4, 7
        if(dy < 0 && dx < 0){
          //Fall 7
          if(x == b.x+b.width){
            ball.dx = -dx; 
          }
          //Fall 4
          if(y == b.y+b.height){
            ball.dy = -dy;
          }            
        }
        //Fall 3, 6
        if(dy < 0 && dx > 0){
          //Fall 6
          if(x == b.x){
            ball.dx = -dx; 
          }
          //Fall 3
          if(y == b.y+b.height){
            ball.dy = -dy;
          }       
        }
        //Fall 2, 8
        if(dy >0 && dx < 0){
          //Fall 8
          if(x == b.x+b.width){
            ball.dx = -dx; 
          }
          //Fall 2
          if(y == b.y){
            ball.dy = -dy;
          }            
        }
        //Fall 1, 5
        if(dy > 0 && dx > 0){
          //Fall 5
          if(x == b.x){
            ball.dx = -dx; 
          }
          //Fall 1
          if(y == b.y){
            ball.dy = -dy;
          }
        }
        
        //ist es ein Block?
        if(b.element != null){
          _blockList.remove(b);
          b.delete();
         }
      }
      
      
          
    }    
  }
  
  /**
   * Bewegungsfunktion für Ball und Boni
   */
  void move(){    
    balls.forEach( (ball) {
      collisionDetection( ball.nextPos(), ball );
      ball.move();  
    });
    
  }
}


/**
 * Block Class
 */
class Block {
  /**
   * zugehöriges DivElement im Dom-tree
   */
  DivElement _element;
  int _x, _y, _width, _height;
  bool _isSolid;
  int _hitCounter;
  String _colorClass;
  
  /**
   * Konstruktor
   */
  Block(this._x, this._y, this._width, this._height, this._colorClass, this._hitCounter, this._isSolid){
    if(_colorClass.isNotEmpty){
      _element = new DivElement();
      _element
       ..classes.add(_colorClass)
       ..style.left = (BLOCK_WIDTH*_x).toString()+"px"
       ..style.top = (BLOCK_HEIGHT*_y).toString()+"px";
      _x *= BLOCK_WIDTH;
      _y *= BLOCK_HEIGHT;
    }
  }
  
  /**
   * löscht dieses Element
   */
  void delete(){
    element.remove();    
  }
  
  /**
   * getter
   */
  int get x => _x;
  int get y => _y;
  int get width => _width;
  int get height => _height;
  DivElement get element => _element;
}

/**
 * Cursor class
 */
class Cursor{
  DivElement _element;
  int _x, _y;
  int _cursorWidth;
  /**
   * Konstruktor
   */
  Cursor(this._x, this._y, this._cursorWidth){
    _element = new DivElement();
    _element
      ..id = "cursor"
      ..style.left = (_x).toString()+"px"
      ..style.top = (_y).toString()+"px";
  }

  DivElement get element => _element;
  int get width => _cursorWidth;
  set x(int value){
    _x = value;
    _element.style.left = _x.toString()+"px";
  }
  int get x => _x;
  int get y => _y;
}
