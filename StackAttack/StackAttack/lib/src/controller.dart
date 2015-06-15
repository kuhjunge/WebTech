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
  var _timerIntervall = new Duration(milliseconds: 200);
  
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
  Controller() {
  }
  
  /**
   * TODO herausnehmen und in model migrieren; bzw. da, wo die Json-Level-Dateien eingeladen werden
   */
  int counter = 0;
  
  /**
   * Lade Spielparameter ein
   */
  Future loadParameters() async{
    //Laden von Parametern
    String inputString = await HttpRequest.getString('/parameters/global_settings.json');    
    Map jMap = JSON.decode(inputString);    
    BLOCK_SIZE = jMap["BLOCK_SIZE"];
    BLOCKS_PER_ROW = jMap["BLOCKS_PER_ROW"];
    BLOCK_ROWS = jMap["BLOCK_ROWS"];   
    RED = jMap["RED"];
    BLUE = jMap["BLUE"];
    GREEN = jMap["GREEN"];
    BLACK = jMap["BLACK"]; 
    DIFFERENT_COLORS = jMap["DIFFERENT_COLORS"];
    PICS_PATH = jMap["PICS_PATH"];
    PLAYER = jMap["PLAYER"];
    POWERUP_HEART = jMap["POWERUP_HEART"];
    BLOCK = jMap["BLOCK"];
    PICS_TYP = jMap["PICS_TYP"];
    POINTS_PER_ROW = jMap["POINTS_PER_ROW"];
    POINTS_PER_GROUPELEMENT = jMap["POINTS_PER_GROUPELEMENT"];
    START_LIFE = jMap["START_LIFE"];    
  }
  
  /**
   * das Timer-Event
   */
  void timerEvent(){
    //TODO hier könnten counter/randomValue werte durch Datei eingeladen werden
    if( counter == 5){      
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
        Block block = new Block(0,0, color,false);
        //Powerup block = new Powerup(0,0);//TODO Powerup-Mechaniken übernehmen => aufsammeln können in model :)
        
        block.targetX = new Random().nextInt(BLOCKS_PER_ROW);         
        _view.addElement(block.element); 
        _model.addMovingBlock(block); 
        counter = 0;
      }
    }
    else{
      counter++;
    }    
      
    //bewege Blöcke inklusive Kollisionsdetection
    if( !_model.moveBlocks() ){
      //Zähle Leben runter
      if(_model.player.life > 0){
        int life = _model.player.life - 1;
        
        //starte Spiel erneut
        _timer.cancel();
        // lösche alte Werte
        _model = new Model();
        _view.clear();
        
        //neuer Player mit weniger Leben
        _model.player = new Player(BLOCKS_PER_ROW~/2, BLOCK_ROWS-1, life);       
        _view.addElement(_model.player.element);
        //update LifeView
        _view.updateLife(_model.player.life);
        //restart Timer
        _timer = new Timer.periodic(_timerIntervall, (_)=> timerEvent() );
      }
      else{
      //setze StartBool
        _isStarted = false;
        //TODO Verlier-Bild etc einblenden
        _timer.cancel();  
      }      
    }
    
    //update des Views für Punkteanzeige
    _view.updatePoints(_model.player.points);
   
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
    
    _model.player = new Player(BLOCKS_PER_ROW~/2, BLOCK_ROWS-1, START_LIFE);

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

     //update LifeView    
     _view.updateLife(_model.player.life);
     
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
    if( _isStarted){
      switch( key.keyCode ){
        case KeyCode.A:          
          _model.movingPlayer(Direction.LEFT);
          break;
        case KeyCode.D:
          _model.movingPlayer(Direction.RIGHT);          
          break;
        case KeyCode.Q:
          _model.movingPlayer(Direction.TOPLEFT);
          break;
        case KeyCode.E:
          _model.movingPlayer(Direction.TOPRIGHT);
          break;
      }
    }
      
  }
  
}