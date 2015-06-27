part of stackAttackLib;

/**
 * Speichert die Informationen eines Levels
 */
class Level{
  
  Map<String, int> colors_share = new Map();
  Map<String, int> solid_colors_share = new Map();
  Map<String, int> powerups_share = new Map();  
  int end_points;  
  int falling_speed;
  int creation_speed;
  
  //Konstruktor
  Level(this.colors_share, this.solid_colors_share, this.powerups_share, this.end_points, this.falling_speed, this.creation_speed){    
  }
  
}