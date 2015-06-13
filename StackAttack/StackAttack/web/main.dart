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
