part of stackAttackLib;

/**
 * Powerups
 */
class PowerupColorChange extends Powerup {
  
  /**
   * Konstruktor
   */
  PowerupColorChange(int x, int y):super(x,y){    
    addClass("powerup_colorchange");
  }
  
  void walkThrough(Model m){
    List<Block> list = m.getAllBlocksAsList();
    print("Colorchange"+list.length.toString());
    list.forEach( (f){
      if(!f.isWalkable){
        f.color = RED;
        f.blocksDeletion(m);
        print("hier");
      }
    });
  }
  
}