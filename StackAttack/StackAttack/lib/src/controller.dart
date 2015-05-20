part of test;

/**
 * globale Konstanten
 */
const int BLOCK_SIZE = 50;
const int BLOCKS_PER_ROW = 10;// Blöcke pro Zeile
const int BLOCK_ROWS = 10; // maximale Anzahl an Zeilen
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
    _timer = new Timer.periodic(new Duration(milliseconds: 50), (_)=> timerEvent() );
  }
  
  /**
   * das Timer-Event
   */
  void timerEvent(){
    
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
    _model.block = new Block(1,1,"red", false);
    _model.block = new Block(2,1,"green", false);
    _model.block = new Block(3,1,"blue", false);
    _model.block = new Block(10,1,"black", true);

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
  }
  
}