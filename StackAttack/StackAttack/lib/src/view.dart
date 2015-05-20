part of test;

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
    
  }
  
  /**
   * fügt ein DivElement zum container hinzu
   */
  void addElement(DivElement elem){
    _container.append(elem);
  }  
  
   
}