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

 //Farben
 String RED;
 String BLUE;
 String GREEN;
 String BLACK;
 String WHITE;
 String YELLOW;
 String NO_COLOR;
 int DIFFERENT_COLORS;//Anzahl verschiedener Farben

 //Externe Bilder
 String PICS_PATH;
 String PLAYER;//Bild des stehenden Spielers
 String POWERUP_HEART;
 String POWERUP_BOMB;
 String BLOCK;
 String PICS_TYP;
 //Level
 String LEVEL_PATH;
 int LEVEL_COUNT;

 //Punktesystem
 int POINTS_PER_ROW;
 int POINTS_PER_GROUPELEMENT;
 int START_LIFE;
 int MAX_LIFE;
 
 //Globaler id - Counter
 int nrCounter = 0;
 
/**
 * Bewegungsrichtungen eines Players
 */
enum Direction{
  LEFT, RIGHT, DOWN, TOPLEFT, TOPRIGHT
}