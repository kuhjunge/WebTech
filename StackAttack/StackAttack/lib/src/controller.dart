part of test;

/**
 * globale Konstanten
 */
const int BLOCK_SIZE = 50;
const int BLOCKS_PER_ROW = 10;// Blöcke pro Zeile
const int BLOCK_ROWS = 11; // maximale Anzahl an Zeilen
const int FIELD_WIDTH = 500;
const int FIELD_HEIGHT = 500;


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
    //Wahrscheinlichkeit für Erzeugung neuer Blöcke
    if(counter == 60){
      Block block = new Block(0,0,"blue",false);      
      _view.addElement(block.getElement); // zeichne den Block an Startposition
      block.x = 5;
      block.y = 10;
      _model.block = block; // setze Block in Model mit gewünschter Position
      _model.movingBlocks = block; // füge Blocks zur List der sich bewegenden Blöcke
      counter = 0;
    }
    else{
      counter++;
    }
    // bewege Blöcke
    _model.movingBlockList.forEach( (e) {      
      if(e.realX != e.x * BLOCK_SIZE){
        e.realX += 2;
        
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
    //TODO xml documente einladen
    _model.block = new Block(0,10,"red", false);
    _model.block = new Block(1,10,"green", false);
    _model.block = new Block(3,10,"blue", false);
    _model.block = new Block(9,10,"black", true);

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
     ImageElement im = new ImageElement();
     DivElement player = new DivElement();
     
     _view.addElement(player);
    // starte TimerEvent 
    _timer = new Timer.periodic(new Duration(milliseconds: 50), (_)=> timerEvent() );
  }
  
}