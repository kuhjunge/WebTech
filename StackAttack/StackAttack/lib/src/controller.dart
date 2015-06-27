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
  var _timerIntervall;
 
  /**
   * 
   */
  var _isStarted = false;

  /**
   * Liste der Level
   */
  Map<int, Level> _levels = new Map();

  /**
   * aktuelles Level
   */
  int _aktLevel = 1;
  
  /**
   * Zählt hoch für die Erzeugung neuer Blöcke
   */
  int _counter = 0;
  
  /**
   * Konstruktor
   */
  Controller() {
    _loadParameters().then( (f) {
      View view = new View(document.body, this); 
      _view = view;  
    });
  }
  
  /**
   * Lade Spielparameter ein
   */
  Future _loadParameters() async{
    //Laden von globalen Parametern
    String inputString = await HttpRequest.getString('/parameters/global_settings.json');    
    Map jMap = JSON.decode(inputString);    
    BLOCK_SIZE = jMap["BLOCK_SIZE"];
    BLOCKS_PER_ROW = jMap["BLOCKS_PER_ROW"];
    BLOCK_ROWS = jMap["BLOCK_ROWS"];     
    NO_COLOR = jMap["NO_COLOR"];
    COLORS = jMap["COLORS"];
    SOLID_COLORS = jMap["SOLID_COLORS"];        
    POWERUPS = jMap["POWERUPS"];       
    POINTS_PER_ROW = jMap["POINTS_PER_ROW"];
    POINTS_PER_GROUPELEMENT = jMap["POINTS_PER_GROUPELEMENT"];
    START_LIFE = jMap["START_LIFE"];
    MAX_LIFE = jMap["MAX_LIFE"];
    LEVEL_PATH = jMap["LEVEL_PATH"];
    LEVEL_COUNT = jMap["LEVEL_COUNT"];
    //Laden der Level
    for(int i = 1; i <= LEVEL_COUNT; i++){
      inputString = await HttpRequest.getString("/parameters/$LEVEL_PATH/level$i.json");
      jMap = JSON.decode(inputString);
      Map<String, int> colors_share = jMap["COLORS_SHARE"];
      Map<String, int> solid_colors_share = jMap["SOLID_COLORS_SHARE"];
      Map<String, int> powerup_share = jMap["POWERUPS_SHARE"];          
      _levels[i] = new Level(colors_share, solid_colors_share, powerup_share, jMap["END_POINTS"], jMap["FALLING_SPEED"], jMap["CREATION_SPEED"]);
    }
    //Einstellen TimerIntervall
    _timerIntervall = new Duration(milliseconds: _levels[_aktLevel].falling_speed);
  }
  
  /**
   * das Timer-Event
   */
  void _timerEvent(){
    
    //bewege Blöcke inklusive Kollisionsdetection
       int isCollision = _model.moveBlocks(); 
       if( isCollision < 0 ){
         //Zähle Leben runter
         if(_model.player.life > 1){        
           
           //starte Spiel erneut
           _timer.cancel();
           
           int life = _model.player.life -1;
           int points = _model.player.points;
           int x = _model.player.x;
           
           if(isCollision == -2){
             // alte Blöcke fallen nach unten
              _model.allBlocksFallingDown();
              _model.player.y--;
           }
           else{
             //lösche Spielfeld          
             _model = new Model();
             _view.clear();
             _model.player = new Player(x, Player.getStartHeight());
             _view.addElement(_model.player);          
           }
           
           _model.player.life = life;
           _model.player.points = points;
                   
           //restart Timer
           _timer = new Timer.periodic(_timerIntervall, (_)=> _timerEvent() );
         }
         else{
           //Game over
           _view.addInfo("Game Over!");
           //setze StartBool
           _isStarted = false;           
           _timer.cancel();  
           return;
         }      
       }
    
    Level level = _levels[_aktLevel];
    if( level != null && _counter == level.creation_speed){
      Block block = _model.getRandomBlock(level);
      
      block.targetX = new Random().nextInt(BLOCKS_PER_ROW);          
      _model.addMovingBlock(block);
      _view.addElement(block);
      _counter = 0;
    }
    else{
      _counter++;
    }    
       
    //Überprüfung, ob Level erhöht werden muß
    if( _model.player.points >= _levels[_aktLevel].end_points && _levels.containsKey(_aktLevel+1)){      
      _aktLevel++;
      _timerIntervall = new Duration(milliseconds: _levels[_aktLevel].falling_speed);
      //restart Timer
      _timer.cancel();
      _timer = new Timer.periodic(_timerIntervall, (_)=> _timerEvent() );
    }
    
    //update des Views 
    _view.updateView(_model.player, _aktLevel);
    _view.updateMovingElements(_model);
   
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
  
    //setze Level zurück
    _aktLevel = 1;
    
     // füge Spieler hinzu
     _model.player = new Player(Player.getStartWidth(), Player.getStartHeight() );
     _view.addElement(_model.player);

     //update View    
     _view.updateView(_model.player, _aktLevel);
     
    //setze StartBool
    _isStarted = true;
    // starte TimerEvent 
    _timer = new Timer.periodic(_timerIntervall, (_)=> _timerEvent() );
  }
  
  /**
   * Pausiert das Spiel
   */
  void pauseGame(){
    if(!_isStarted)
      return;
    if( _timer != null &&_timer.isActive ){
      _view.showRules();
      _timer.cancel();
    }
    else {
      _view.removeInfo();
      _timer = new Timer.periodic(_timerIntervall, (_)=> _timerEvent() ); 
    }
  }
  
  /**
   * Reaktion auf KeyboardEingabe
   */
  void keyEvent(var key){
    if( _isStarted && _timer.isActive){
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
      _view.updateMovingElements(_model);
    }
  }
}