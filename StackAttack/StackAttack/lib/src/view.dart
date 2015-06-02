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
   * Konstruktor
   * Übergabe des html-body
   * Initialisierung
   */
  View(Element body, Controller control){
    _container = body.querySelector("#field");
    _control = control;    
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
    
   
}