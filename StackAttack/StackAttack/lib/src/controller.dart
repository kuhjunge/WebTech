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
  Map<int, Level> _levels = new Map();

  /**
   * aktuelles Level
   */
  int _aktLevel = 1;
  
  /**
   * Konstruktor
   */
  Controller() {
  }
  
  /**
   * Zählt hoch für die Erzeugung neuer Blöcke
   */
  int _counter = 0;
  
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
    NO_COLOR = jMap["NO_COLOR"];
    DIFFERENT_COLORS = jMap["DIFFERENT_COLORS"];
    POWERUP_COUNT = jMap["POWERUP_COUNT"];
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
      _levels[i] = new Level(jMap["YELLOW_SHARE"], jMap["RED_SHARE"], jMap["GREEN_SHARE"],jMap["BLUE_SHARE"],
        jMap["WHITE_SHARE"],jMap["BLACK_SHARE"], jMap["POWERUP_SHARE"], jMap["START_POINTS"],jMap["END_POINTS"],jMap["FALLING_SPEED"],
        jMap["CREATION_SPEED"]);
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
           //TODO GAME OVER könnte hier eingebaut werden
           _view.addInfo("Game Over!");
         //setze StartBool
           _isStarted = false;
           //TODO Verlier-Bild etc einblenden
           _timer.cancel();  
           return;
         }      
       }
    
    Level level = _levels[_aktLevel];
    if( level != null && _counter == level.creation_speed){
      //zähle alle share-Werte hoch
      int maxValue = level.black_share+level.blue_share+level.green_share+level.powerup_share+level.red_share+level.white_share+level.yellow_share;
      //nehme Zufallszahl
      int randomValue = new Random().nextInt(maxValue);
      String color = "";
      bool isSolid = false;
      bool isPowerup = false;
      
      maxValue -= level.yellow_share;
      if(randomValue > maxValue){
        color = YELLOW;
      }
      else{
        maxValue -= level.blue_share;
        if(randomValue > maxValue){
          color = BLUE;
        }  
        else{
          maxValue -= level.green_share;
          if(randomValue > maxValue){
           color = GREEN; 
          }
          else{
            maxValue -= level.red_share;
            if(randomValue > maxValue){
              color = RED;
            }
            else{
              maxValue -= level.white_share;
              if(randomValue > maxValue){
                color = WHITE;
              }
              else{
                maxValue -= level.black_share;
                if(randomValue > maxValue){
                  color = BLACK;
                  isSolid = true;
                }
                else{
                  color = NO_COLOR;
                  isPowerup = true;
                }
              }
            }
          }
        }
      }      
        
      Block block;
      if( !isPowerup ){
        block = new Block(0,0, color, false, isSolid);        
      }
      else{
        int powerUpRandom = new Random().nextInt(POWERUP_COUNT);
        if(powerUpRandom == 1){
          block = new PowerupHeart(0,0);
        }
        else{
          if(powerUpRandom == 2){
            block = new PowerupBomb(0,0);
          }
          else{
            block = new PowerupColorChange(0,0);
          }
        }
                
      }
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
    if( _timer != null &&_timer.isActive )
      _timer.cancel();
    else
      _timer = new Timer.periodic(_timerIntervall, (_)=> _timerEvent() );      
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