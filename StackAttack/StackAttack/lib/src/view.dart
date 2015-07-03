part of stackAttackLib;

/**
 * View
 */
class View{
  /**
   * zuständiger Controller
   */
  Controller _control;
  /**
   * Der DivElement Container
   */
  Element _container;
  
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
  //Element _message;
  
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
    
    /*
     * Bewegung des Players per Tastatur
     */
    body.onKeyDown.listen( (e){      
      _control.keyEvent(e);      
    });
    
    /*
     * Bewegung des Players per Mausdruck
     */    
      _container.onMouseUp.listen( (ev){      
      int x = ev.client.x - _container.offsetLeft;
      int y = ev.client.y - _container.offsetTop;

      if( x < FIELD_WIDTH~/2 && y < FIELD_HEIGHT~/2){
        _control.keyEvent(new KeyEvent('keydown', keyCode: 81));        
      }
      if( x < FIELD_WIDTH~/2 && y >= FIELD_HEIGHT~/2){
        _control.keyEvent(new KeyEvent('keydown', keyCode: 65));
      }
      if( x >= FIELD_WIDTH~/2 && y < FIELD_HEIGHT~/2){
        _control.keyEvent(new KeyEvent('keydown', keyCode: 69));
      }
      if( x >= FIELD_WIDTH~/2 && y >= FIELD_HEIGHT~/2){
        _control.keyEvent(new KeyEvent('keydown', keyCode: 68));
      } 
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
    addInfo("<h2>Regeln:</h2><p>Der Spieler muss die Spielsteine verschieben und darf sich nicht treffen lassen.<br />"+
        "Blockverbunde und Reihen geben Punkte.</p><h2>Tastenbelegung:</h2><p>A: Links <br />Q: Linkssprung<br/>D: Rechts<br/>E: Rechtssprung</p>"+
        "<h2>Touch:</h2><p>Spielfeld in den Ecken anklicken.<br/>Oben Links für Sprung nach links.<br/>Oben Rechts für Sprung nach Rechts.<br/>Unten Links für Schritt nach Links.<br/>Unten Rechts für Schritt nach Rechts.</p>"+
        "<h2>Blockarten:</h2><div class='red prev block'></div><p> Ein normaler Block kann verschoben werden und gibt in einem Verbund von mindestens 3 gleichfarbigen Blöcken "
        +POINTS_PER_GROUPELEMENT.toString() +
        " Punkte pro Block und wird aufgelößt <br/> Es gibt: "+COLORS.toString()+"</p>"+
        "<div class='black prev block'></div><p> Schwarze Blöcke verhalten sich wie normale Blöcke, können aber NICHT verschoben werden.</p>"+
        "<div class='powerup_heart prev block'></div><p> Ein Herz gibt ein zusätzliches Leben. Max: "+MAX_LIFE.toString() +"</p>"+
        "<div class='powerup_bomb prev block'></div><p> Eine Bombe zerstört alle Blöcke die am Spieler anliegen.</p>"+
        "<div class='powerup_coin prev block'></div><p> Ein Geldstück gibt "+(POINTS_PER_GROUPELEMENT*4).toString() +" Punkte.</p>"+
        "<div class='powerup_lightning prev block'></div><p> Der Blitz zerstört eine ganze Reihe von Blöcken.</p>"+
        "<p>Eine komplette Reihe gibt "+POINTS_PER_ROW.toString() +" Punkte.</p>");
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