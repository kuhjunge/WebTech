part of stackAttackLib;

/**
 * View
 */
class View{
  /**
   * Der DivElement Container
   */
  Element _container;
  /**
   * zuständiger Controller
   */
  Controller _control;
  
  /**
   * Anzeige der Punkte
   */
  Element _pointView;
  
  /**
   * Anzeige der Leben
   */
  Element _lifeView;
  
  /**
   * Anzeige des Levels
   */
  Element _levelView;
  
  /**
   * Konstruktor
   * Übergabe des html-body
   * Initialisierung
   */
  View(Element body, Controller control){
    _container = body.querySelector("#field");    
    _pointView = body.querySelector("#pointView");
    _lifeView = body.querySelector("#lifeView");
    _levelView = body.querySelector("#levelView");
    _control = control;
    //setze die Dimensionen des Feldes
    _container.style
      ..height = (FIELD_HEIGHT + BLOCK_SIZE).toString() + "px"
      ..width = (FIELD_WIDTH ).toString() + "px";
    /*
     * verknüpfe mit controller.startGame
     */
    body.querySelector("#button_start").onClick.listen( (e) {
      _control.startGame();
    });
    
    /*
     * verknüpfe mit controller.pauseGame
     */
    body.querySelector("#button_pause").onClick.listen(( e){
      _control.pauseGame();
    });

    body.onKeyDown.listen( (e){      
      _control.keyEvent(e);      
    });
    
  }
  
  /**
   * löscht alle Elemente
   */
  void clear(){
    _container.children.clear();
  }
  
  /**
   * fügt ein HtmlElement zum container hinzu
   */
  void addElement(DivElement elem){    
    _container.append(elem);
  }  
  
  /**
   * refresht die Punkteanzeige, refresht die Lebensanzeige
   */
  void updateView(Player p, int level){
    _pointView.text = "Punktestand: "+p.points.toString();
    _lifeView.text = "Leben: "+p.life.toString();
    _levelView.text = "Level: "+level.toString();
  }
    
  
}