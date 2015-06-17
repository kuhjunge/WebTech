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
   * 
   */
  var _isStarted = false;

  /**
   * Liste der Level
   */
  Map<int, Level> levels = new Map();

  /**
   * aktuelles Level
   */
  int aktLevel = 1;
  
  /**
   * Konstruktor
   */
  Controller() {
  }
  
  /**
   * Zählt hoch für die Erzeugung neuer Blöcke
   */
  int counter = 0;
  
  /**
   * Lade Spielparameter ein
   */
  Future loadParameters() async{
    //Laden von globalen Parametern
    String inputString = await HttpRequest.getString('/parameters/global_settings.json');    
    Map jMap = JSON.decode(inputString);    
    BLOCK_SIZE = jMap["BLOCK_SIZE"];
    BLOCKS_PER_ROW = jMap["BLOCKS_PER_ROW"];
    BLOCK_ROWS = jMap["BLOCK_ROWS"];   
    RED = jMap["RED"];
    BLUE = jMap["BLUE"];
    WHITE = jMap["WHITE"];
    YELLOW = jMap["YELLOW"];
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
    PLAYER_HEIGHT = jMap["PLAYER_HEIGHT"];
    PLAYER_WIDTH = jMap["PLAYER_WIDTH"];
    LEVEL_PATH = jMap["LEVEL_PATH"];
    LEVEL_COUNT = jMap["LEVEL_COUNT"];
    //Laden der Level
    for(int i = 1; i <= LEVEL_COUNT; i++){
      inputString = await HttpRequest.getString("/parameters/$LEVEL_PATH/level$i.json");
      jMap = JSON.decode(inputString);
      levels[i] = new Level(jMap["YELLOW_SHARE"], jMap["RED_SHARE"], jMap["GREEN_SHARE"],jMap["BLUE_SHARE"],
        jMap["WHITE_SHARE"],jMap["BLACK_SHARE"], jMap["POWERUP_SHARE"], jMap["START_POINTS"],jMap["END_POINTS"],jMap["FALLING_SPEED"],
        jMap["CREATION_SPEED"]);
    }
  }
  
  /**
   * das Timer-Event
   */
  void timerEvent(){
    Level level = levels[aktLevel];
    if( level != null && counter == level.creation_speed){
      //zähle alle share-Werte hoch
      int maxValue = level.black_share+level.blue_share+level.green_share+level.powerup_share+level.red_share+level.white_share+level.yellow_share;
      //nehme Zufallszahl
      int randomValue = new Random().nextInt(maxValue);
      String color = "";
      bool isSolid = false;
      bool isPowerup = false;
      
      if()
      
      Block block;
      if( !isPowerup ){
        block = new Block(0,0, color,false,isSolid);        
      }
      else{
        block = new PowerupHeart(0,0);        
      }
      block.targetX = new Random().nextInt(BLOCKS_PER_ROW);         
      _view.addElement(block.element); 
      _model.addMovingBlock(block); 
      counter = 0;      
    }
    else{
      counter++;
    }    
      //TODO Anzeige, in welchem Level man ist, reinnehmen
    //bewege Blöcke inklusive Kollisionsdetection
    if( !_model.moveBlocks() ){
      //Zähle Leben runter
      if(_model.player.life > 0){
        int life = _model.player.life - 1;
        int points = _model.player.points;
        
        //starte Spiel erneut
        _timer.cancel();
        // lösche alte Werte
        _model = new Model();
        _view.clear();
        
        //neuer Player mit weniger Leben
        _model.player = new Player(BLOCKS_PER_ROW~/2, BLOCK_ROWS-(PLAYER_HEIGHT-1));
        _model.player.points = points;
        _model.player.life = life;
        _view.addElement(_model.player.element);        
        
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
    
    //Überprüfung, ob Level erhöht werden muß
    if( _model.player.points >= levels[aktLevel].end_points && levels.containsKey(aktLevel+1)){
      aktLevel++;
    }
    
    //update des Views 
    _view.updateLife(_model.player.life);
    _view.updatePoints(_model.player.points);
   
  }

  /**
   * Setter für den View
   */
  set view(View v) => _view = v;
 

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
    aktLevel = 1;
    
     // füge Spieler hinzu
     _model.player = new Player(BLOCKS_PER_ROW~/2, BLOCK_ROWS-(PLAYER_HEIGHT-1));
     _view.addElement(_model.player.element);     

     //update View    
     _view.updateLife(_model.player.life);
     _view.updatePoints(_model.player.points);
     
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
    }
      
  }
  
}