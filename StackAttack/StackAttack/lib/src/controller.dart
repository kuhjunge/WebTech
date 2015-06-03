part of stackAttackLib;

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
  var _timerIntervall = new Duration(milliseconds: 20);
  
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
   * TODO herausnehmen und in model migrieren; bzw. da, wo die Json-Level-Dateien eingeladen werden
   */
  int counter = 0;
  
  /**
   * das Timer-Event
   */
  void timerEvent(){
    //TODO hier könnten counter/randomValue werte durch Datei eingeladen werden
    if( counter == 50){      
      if( new Random().nextInt(100) < _randomValue){
        //Zufallsfarbe TODO Farben hinzufügen
        String color = "";
        switch(new Random().nextInt(DIFFERENT_COLORS)){
          case 0:
            color = RED;
            break;
          case 1:
            color = BLUE;
            break;
          case 2:
            color = GREEN;
            break;
          case 3:
            color = BLACK;
            break;
        }          
        Block block = new Block(0,0,color,false);
        block.targetX = block.getElementWidth()*new Random().nextInt(BLOCKS_PER_ROW);;         
        _view.addElement(block.element); 
        _model.movingElements = block; // füge Blocks zur List der sich bewegenden Blöcke
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
    _model.block = new Block(0,400,RED, false);
    _model.block = new Block(20,400,GREEN, false);
    _model.block = new Block(40,400,BLUE, false);
    _model.block = new Block(60,400,BLACK, true);
    
    _model.player = new Player(80, 380);

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