part of stackAttackLib;

/**
 * Playerklasse 
 */
class Player extends MovingElement {
  /**
   * Punktezähler
   */
  int _points = 0;
  
  /**
   * Anzahl der Leben
   */
  int _life = START_LIFE;
    
  /**
   * Konstruktor
   * für einen Spieler mit 2*Block_Size hoch und 1*Block_Size breit
   */
  Player(int x, int y) : super(x, y, 1*BLOCK_SIZE, 2*BLOCK_SIZE){        
    addClass("player");
  }  
    
  int get points => _points;
  set points(int p) => _points = p;
  
  int get life => _life; 
  set life(int l){
    if(l <= MAX_LIFE){
      _life = l;      
    }
  }
  
  /**
     * der Player versucht x/y nach Direction.LEFT oder .RIGHT sich zu bewegen    
     * Entweder Bewegung Player oder Block wird verschoben
     */
    void move(Model m, int x_t, int y_t, Direction d){
      Block b = m.getBlock( x + x_t, y + 1 + y_t);
      Block aboveB = m.getBlock( x + x_t, y + y_t); 
      Block a;
      if(d == Direction.LEFT){
          a = m.getBlock( x -1 + x_t, y + 1 + y_t);
      }
      else{
        a = m.getBlock( x +1 + x_t, y + 1 + y_t);
      }
      //Abfrage, ob Block.isWalkable == true
      if(b != null && b.isWalkable && aboveB == null){        
        x = x + x_t;
        y = y + y_t;
        m.deleteBlock(b);        
        b.walkThrough(m);
        falling(m);
        return;
      }
      //bewege direkt den Player
      if(aboveB == null && b == null && ((d==Direction.LEFT) ? (x + x_t  >= 0) : (x + x_t < BLOCKS_PER_ROW)) ){
        x = x + x_t;
        y = y + y_t;
        falling(m);
        return;
      }
      //verschiebe Block
      if( b != null && !b.isSolid && !m.isAMovingBlock(b) && aboveB == null && a == null 
          && ( (d==Direction.LEFT) ? (b.x +  x_t >= 0) : (b.x + x_t < BLOCKS_PER_ROW) )){
        m.moveOneBlock(b, b.x+ x_t, b.y);
        b.targetX = b.x;
        m.addMovingBlock(b);        
      }                
    }
  
    void falling(Model m){
      while( y + 1 < BLOCK_ROWS && ( m.getBlock(x, y + 2)==null ||  (m.getBlock(x, y + 2)!= null &&  m.getBlock(x, y + 2).isWalkable) ) ) { 
        Block  b = m.getBlock(x, y + 2);
        if( b != null && b.isWalkable){
          y = y + 1;
          m.deleteBlock(b);
          b.walkThrough(m);
        }
        else{
          y = y + 1;
        }
      }     
    }
  
    /**
     * Überprüfung, ob Block in Player ist
     * return 0, wenn keine Kollision
     * return -1, wenn Kollision mit Powerup
     * return -2, wenn Kollision mit Block
     */
     int collision(Model m, Block b){
      if(b.x == x && b.y == y){
        //Powerup
        if(b.isWalkable){
          b.walkThrough(m);
          m.deleteBlock(b);
          return -1;
        }
        return -2;
      }
      return 0;
    }
    
  /**
   * Gibt eine Liste von benachbarten Blöcken zurück
   */
  List<Block> getNeighbours(Model m){
    List<Block> list = new List();    
    
    Block b = m.getBlock(x-1, y+1);
    if(b != null){
      list.add(b);
    }    
    b = m.getBlock(x+1, y+1);
    if(b != null){
      list.add(b);
    }    
    
    b = m.getBlock(x-1, y);
    if(b != null){
      list.add(b);
    }    
    b = m.getBlock(x+1, y);
    if(b != null){
      list.add(b);
    }    
    
    b = m.getBlock(x-1, y-1);
    if(b != null){
      list.add(b);
    }    
    b = m.getBlock(x+1, y-1);
    if(b != null){
      list.add(b);
    }    
    
    
    b = m.getBlock(x-1, y+2);
    if(b != null){
      list.add(b);
    }    
    b = m.getBlock(x, y+2);
    if(b != null){
      list.add(b);
    }   
    b = m.getBlock(x+1, y+2);
    if(b != null){
      list.add(b);
    }
    
    
    return list;
  }
     
  /**
   * gibt für neue Elemente eine sinnvolle Startposition für die y-Koordinate zurück
   */
  static int getStartTop(){
    return BLOCK_ROWS-1;
  }
  
  /**
   * gibt für neue Elemente einen sinnvollen x-Startwert zurück
   */
  static int getStartLeft(){
    return BLOCKS_PER_ROW~/2;    
  }
}