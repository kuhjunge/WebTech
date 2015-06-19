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
   * refresht die Punkteanzeige, refresht die Lebensanzeige
   */
  void updateView(Player p, int level){
    _pointView.text = "Punktestand: "+p.points.toString();
    _lifeView.text = "Leben: "+p.life.toString();
    _levelView.text = "Level: "+level.toString();
  }
    
  /**
   * update der Positionen aller MovingElemente
   * und eventuell Löschen von nicht mehr existierenden Elemente
   */
  void updateMovingElements(Model m){
    List<Element> deletedElem = new List();
    List<Element> elemente = _container.querySelectorAll(".MovingElement");
    for(Element elem in elemente){
      int nr = int.parse(elem.attributes["nr"], onError: (_)=> -1);      
      MovingElement mE = m.getMovingElement( nr );
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