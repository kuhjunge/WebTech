part of stackAttackLib;

/**
 * globale Konstanten
 */
//Spieldimensionen
 int BLOCK_SIZE;//Blockgröße
 int BLOCKS_PER_ROW;// Blöcke pro Zeile
 int BLOCK_ROWS; // maximale Anzahl an Zeilen, inclusive 0
 int FIELD_WIDTH = BLOCKS_PER_ROW * BLOCK_SIZE;
 int FIELD_HEIGHT = BLOCK_ROWS * BLOCK_SIZE;

 //Farben/Powerups
 List<String> COLORS = new List(); 
 String NO_COLOR; 
 List<String> POWERUPS = new List();
 List<String> SOLID_COLORS = new List();

 //Level
 String LEVEL_PATH;
 int LEVEL_COUNT;

 //Punktesystem
 int POINTS_PER_ROW;
 int POINTS_PER_GROUPELEMENT;
 int START_LIFE;
 int MAX_LIFE;
 
 //Globaler nr - Counter
 int nrCounter = 0;
 
/**
 * Bewegungsrichtungen eines Players
 */
enum Direction{
  LEFT, RIGHT, DOWN, TOPLEFT, TOPRIGHT
}