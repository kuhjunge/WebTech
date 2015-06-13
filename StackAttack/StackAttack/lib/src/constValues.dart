part of stackAttackLib;

/**
 * globale Konstanten
 */
const int BLOCK_SIZE = 20;//TODO Größenänderung einfach möglich, allerdings müssen entsprechnde Bilder vorhanden sein
const int BLOCKS_PER_ROW = 10;// Blöcke pro Zeile
const int BLOCK_ROWS = 20; // maximale Anzahl an Zeilen, inclusive 0
const int FIELD_WIDTH = BLOCKS_PER_ROW * BLOCK_SIZE;
const int FIELD_HEIGHT = BLOCK_ROWS * BLOCK_SIZE;

const String RED = "red";
const String BLUE = "blue";
const String GREEN = "green";
const String BLACK = "black";
const String NO_COLOR = "none";
const int DIFFERENT_COLORS = 4; //Anzahl verschiedener Farben

const String PICS_PATH = "/pics/";
const String PLAYER_STANDING = "player_standing";//Bild des stehenden Spielers
const String POWERUP_HEART = "powerup_heart";
const String BLOCK = "block";
const String PICS_TYP = ".png";

const int POINTS_PER_ROW = 10;
const int POINTS_PER_GROUPELEMENT = 5;
const int START_LIFE = 3;

/**
 * Bewegungsrichtungen eines Players
 */
enum Direction{
  LEFT, RIGHT, DOWN, TOPLEFT, TOPRIGHT
}