part of stackAttackLib;

/**
 * Speichert die Informationen eines Levels
 */
class Level{
  
  int yellow_share;
  int red_share;
  int green_share;
  int blue_share;
  int white_share;
  int black_share;
  int start_points;
  int end_points;
  int falling_speed;
  int creation_speed;
  
  //Konstruktor
  Level(this.yellow_share, this.red_share, this.green_share, this.blue_share, this.white_share, this.black_share, this.start_points, this.end_points, this.falling_speed, this.creation_speed){    
  }
  
}