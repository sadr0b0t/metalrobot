//print_error = 0.0;
print_error = 0.2;

motor_fix(print_error=print_error);

module motor_fix(print_error=0) {
  // главный блок с шестеренками
  mlenx_1 = 20;
  // защелка
  mlenx_2 = 25;
  // рамка
  mlenx_3 = 25;
  // блок с мотором
  mlenx_4 = 23;
    
  // главный блок с шестеренками
  mleny_1 = 14;
  // защелка
  mleny_2 = 7;
  // рамка
  mleny_3 = 14;
  // блок с мотором
  mleny_4 = 12;
  
  // защелка
  mlenz_2 = 2;
  // рамка
  mlenz_3 = 3;
    
  // всё центрируем по x и по y
  difference() {
    union() {
      // по ширине рамки + стенки 2мм
      translate([-(mlenx_3+4)/2, -mleny_1/2-2, 0]) cube([mlenx_3+4, mleny_1+2, 20]);
      // крепления на корпус
      linear_extrude(height=2) import(file="корпус-43d.dxf");
      //translate([-2, 2, 20]) cube([mlenx_1, mleny_1, 2]);
    }
    // главный блок с шестеренками
    translate([-mlenx_1/2-print_error, -mleny_1/2-print_error, -0.1]) 
      cube([mlenx_1+print_error*2, mleny_1+print_error*2+0.1, 22+0.2]);
    // защелки
    translate([-mlenx_2/2-print_error, -mleny_2/2-print_error, -0.1]) 
      cube([mlenx_2+print_error*2, mleny_2+print_error*2, mlenz_3+mlenz_2]);
    // рамка вокруг мотора
    translate([-mlenx_3/2-print_error, -mleny_3/2-print_error, -0.1]) 
      cube([mlenx_3+print_error*2, mleny_3+print_error*2+0.1, mlenz_3]);
  }
}
