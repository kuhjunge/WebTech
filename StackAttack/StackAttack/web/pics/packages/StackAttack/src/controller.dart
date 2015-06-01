part of test;

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
   * Konstruktor
   */
  Controller(Model m){
    _model = m;
  }
  
  /**
   * TODO herausnehmen und in model migrieren
   */
  int counter = 0;
  
  /**
   * das Timer-Event
   */
  void timerEvent(){
    //TODO Wahrscheinlichkeit für Erzeugung neuer Blöcke
    if(counter == 40){
      
      //Zufallsfarbe TODO Farben hinzufügen
      String color = "";
      switch(new Random().nextInt(4)){
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
      _view.addElement(block.getElement); // zeichne den Block an Startposition      
      block.x = new Random().nextInt(BLOCKS_PER_ROW);
      block.y = BLOCK_ROWS;      
      _model.movingBlocks = block; // füge Blocks zur List der sich bewegenden Blöcke
      counter = 0;
    }
    else{
      counter++;
    }
    // bewege Blöcke
    _model.movingBlockList.forEach( (e) {
      //bewege nach Rechts
      if(e.realX < e.x * BLOCK_SIZE){
        e.realX += 3;        
      }//bewege nach unten
      else{
        e.realX = e.x * BLOCK_SIZE;
        //VerlierKriterium
        if(_model.isLost()){
          _timer.cancel();
        }
        //KollisionsDetektion
        if( !_model.kollisionDetection(e) ){
          e.realY += 3;  
        }
      }
    });
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
    //TODO lösche alte Werte
    // lade Level
     loadLevel();
     // zeige alle Blöcke im View an
     _model.blocks.forEach( (e) => _view.addElement(e.getElement) );
     // füge Spieler hinzu
    _view.addElement(_model.player);
     
     _view.addElement(player);
    // starte TimerEvent 
    _timer = new Timer.periodic(new Duration(milliseconds: 25), (_)=> timerEvent() );
  }
  
}