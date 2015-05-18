// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'Controller.dart';


/**
 * Main-Methode 
 */
void main() {
 Model model = new Model();
 Controller control = new Controller(model);
 View view = new View(document.body, control); 
 control.view = view;
 control.startGame();
}

