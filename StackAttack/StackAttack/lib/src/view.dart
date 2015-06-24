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
  List<Element> _lifeView;
  
  /**
   * Anzeige des Levels
   */
  Element _levelView;
  /**
   * Anzeige für Pause, Game Over
   */
  Element _message;
  
  /**
   * Konstruktor
   * Übergabe des html-body
   * Initialisierung
   */
  View(Element body, Controller control){
    List<Element> _menu;
    
    _container = body.querySelector("#field"); 
    _pointView = body.querySelector("#pointView");
    _lifeView = body.querySelectorAll(".heart");
    _levelView = body.querySelector("#levelView");
    _menu = body.querySelectorAll(".menu");
    _control = control;
    //setze die Dimensionen des Feldes
    _container.style
      ..height = (FIELD_HEIGHT + BLOCK_SIZE).toString() + "px"
      ..width = (FIELD_WIDTH ).toString() + "px";
    
    _menu.forEach((a)=> a.style
      ..width = (FIELD_WIDTH ).toString() + "px");
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
    // zeige die Regeln
    showRules();
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
  void addElement(MovingElement elem){
   DivElement div = new DivElement();
    div.style
             ..left = (elem.x*BLOCK_SIZE).toString() + "px"
             ..top = (elem.y*BLOCK_SIZE).toString() + "px"     
             ..width = elem.width.toString() + "px"
             ..height = elem.height.toString() + "px";
    div.classes.addAll(elem.classes);
    div.attributes.putIfAbsent("nr", ()=>elem.nr.toString());
    _container.append(div);    
  }
  
  /**
   * zeigt die Regeln an
   */
  void showRules(){
    addInfo("<h2>Regeln:</h2><p>Der Spieler muss die Spielsteine verschieben und darf sich nicht treffen lassen. Schwarze Steine sind unbeweglich. "+
        "3er Farbkombinationen und Reihen geben Punkte.</p><h2>Tastenbelegung:</h2><p>A: Links <br>Q: Linkssprung <br>D: Rechts <br>E: Rechtssprung </p>");
  }
  /**
   * zeigt die Regeln an
   */
  void removeInfo(){
    List<Element> _info;
    _info = _container.querySelectorAll(".info");
    
    _info.forEach((e) {
      e.remove();
    });
  }
  
  
  /**
   * fügt ein HtmlElement zum container hinzu
   */
  void addInfo(var mes){
   DivElement div = new DivElement();
    div.classes.add("info");
    div.appendHtml("<p>"+mes+"</p>");
    _container.append(div);    
  }
  
  /**
   * refresht die Punkteanzeige, refresht die Lebensanzeige
   */
  void updateView(Player p, int level){
    var i = 0;
    _pointView.text = p.points.toString();
    _lifeView.reversed.forEach((h){
      h.classes..remove("hoff")..remove("hon");
      if (i < p.life){
       h.classes.add("hon");
      }
      else{
        h.classes.add("hoff");
      }
      i++;
    });
    /*_lifeView.text = p.life.toString();*/
    _levelView.text = level.toString();
  }
    
  /**
   * update der Positionen aller MovingElemente
   * und eventuell Löschen von nicht mehr existierenden Elemente
   */
  void updateMovingElements(Model m){
    List<Element> deletedElem = new List();
    List<Element> elemente = _container.querySelectorAll(".MovingElement");
    for(Element elem in elemente){            
      MovingElement mE = m.getMovingElement( elem.attributes["nr"] );
      if( mE != null ){      
        elem.style
          ..left = (mE.x*BLOCK_SIZE).toString() + "px"
          ..top = (mE.y*BLOCK_SIZE).toString() + "px";        
      }
      else{
        deletedElem.add(elem);
      }
    }
    //löschen nicht existierender Elemente
    deletedElem.forEach( (f) {
      f.remove();
    });
  }
  
}