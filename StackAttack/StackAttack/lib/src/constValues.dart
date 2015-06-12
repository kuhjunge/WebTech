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
const int DIFFERENT_COLORS = 4; //Anzahl verschiedener Farben
const String PLAYER_STANDING = "/pics/player_standing";//Bild des stehenden Spielers
const String PICS_TYP = ".png";

enum Direction{
  LEFT, RIGHT, DOWN, TOPLEFT, TOPRIGHT
}