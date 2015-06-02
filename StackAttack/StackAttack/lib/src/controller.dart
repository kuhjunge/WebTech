part of stackAttackLib;

/**
 * globale Konstanten
 */
const int BLOCK_SIZE = 50;
const int BLOCKS_PER_ROW = 10;// Blöcke pro Zeile
const int BLOCK_ROWS = 10; // maximale Anzahl an Zeilen, inclusive 0
const int FIELD_WIDTH = 500;
const int FIELD_HEIGHT = 500;
const String red = "red";
const String blue = "blue";
const String green = "green";
const String black = "black";
const int DIFFERENT_COLORS = 4; //Anzahl verschiedener Farben


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
   * TimerIntervall 
   */
  var _timerIntervall = new Duration(milliseconds: 10);
  
  /**
   * Wahrscheinlichkeit für Erzeugung eines neuen Blocks
   * 0 .. 99
   */
  var _randomValue = 99;
   
  /**
   * 
   */
  var _isStarted = false;
  
  /**
   * Konstruktor
   */
  Controller();
  
  /**
   * TODO herausnehmen und in model migrieren
   */
  int counter = 0;
  
  /**
   * das Timer-Event
   */
  void timerEvent(){
    if( counter == 50){      
      if( new Random().nextInt(100) < _randomValue){
        //Zufallsfarbe TODO Farben hinzufügen
        String color = "";
        switch(new Random().nextInt(DIFFERENT_COLORS)){
          case 0:
            color = red;
            break;
          case 1:
            color = blue;
            break;
          case 2:
            color = green;
            break;
          case 3:
            color = black;
            break;
        }          
        Block block = new Block(0,0,color,false);      
        _view.addElement(block.element); // zeichne den Block an Startposition      
        block.x = new Random().nextInt(BLOCKS_PER_ROW);
        block.y = BLOCK_ROWS;      
        _model.movingBlocks = block; // füge Blocks zur List der sich bewegenden Blöcke
        counter = 0;
      }
    }
    else{
      counter++;
    }
    
    
    //bewege Blöcke inklusive Kollisionsdetection
    if( !_model.moveBlocks() ){
      //setze StartBool
      _isStarted = false;
      //TODO Verlier-Bild etc einblenden
      _timer.cancel();
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
    //TODO Unterschiedliche Schwierigkeitsgrade einstellbar(ladbar und hier umsetzen)
    _model.block = new Block(0,10,red, false);
    _model.block = new Block(1,10,green, false);
    _model.block = new Block(3,10,blue, false);
    _model.block = new Block(9,10,black, true);
    
    _model.player = new Player(8,10);

  }  
  
  /**
   * Startet neues Spiel
   */
  void startGame(){
    // lösche alte Werte
    _model = new Model();
    _view.clear();
    if( _timer != null)
      _timer.cancel();
    // lade Level
     loadLevel();
     // zeige alle Blöcke im View an
     _model.blocks.forEach( (e) => _view.addElement(e.element) );
     // füge Spieler hinzu
    _view.addElement(_model.player.element);     

    //setze StartBool
    _isStarted = true;
    // starte TimerEvent 
    _timer = new Timer.periodic(_timerIntervall, (_)=> timerEvent() );
  }
  
  /**
   * Pausiert das Spiel
   */
  void pauseGame(){
    if(!_isStarted)
      return;
    if( _timer != null &&_timer.isActive )
      _timer.cancel();
    else
      _timer = new Timer.periodic(_timerIntervall, (_)=> timerEvent() );      
  }
  
  /**
   * Reaktion auf KeyboardEingabe
   */
  void keyEvent(var key){  
    if( _isStarted)
      _model.movingPlayer(key);
  }
  
}