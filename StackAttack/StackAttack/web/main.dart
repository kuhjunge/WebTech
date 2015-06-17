// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'package:StackAttack/stackAttackLib.dart';

void main(){   
   Controller control = new Controller();
   control.loadParameters().then( (f) {
     View view = new View(document.body, control); 
     control.view = view;  
   });
      
}

/* TODO: in Doku aufnehmen
 * Farben: Gelb (17%), Rot (17%), Grün (17%), Blau (17%), weiß(17%), Schwarz(Solid, 10%), Powerup (5%) (parametrisierbar) * 
 * http://www.iconarchive.com/show/character-icons-by-martin-berube/Kid-icon.html
 * http://icons.iconarchive.com/icons/kyo-tux/phuzion/256/Misc-Box-icon.png
 * https://stocksnap.io/photo/77G671166K
 * 
 */
