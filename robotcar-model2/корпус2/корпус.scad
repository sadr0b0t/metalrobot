$fn=100;

//print_error = 0.0;
print_error = 0.2;

motor_fix(print_error=print_error);
//rod_fix(print_error=print_error);





/**
 * Крепление для мотора-редуктора popolu.
 */
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
      linear_extrude(height=2) import(file="крепление-мотор-43d.dxf");
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
    
    // рассверлить отверстия под винты с учетом print_error
    // справа
    translate([23+2, 0+2, -0.1]) cylinder(h=3+0.2, r=2+print_error);
    translate([23+2, -10+2, -0.1]) cylinder(h=3+0.2, r=2+print_error);
    translate([23+2, -20+2, -0.1]) cylinder(h=3+0.2, r=2+print_error);
    translate([13+2, -20+2, -0.1]) cylinder(h=3+0.2, r=2+print_error);
    translate([3+2, -20+2, -0.1]) cylinder(h=3+0.2, r=2+print_error);
    // слева
    translate([-(23+2), 0+2, -0.1]) cylinder(h=3+0.2, r=2+print_error);
    translate([-(23+2), -10+2, -0.1]) cylinder(h=3+0.2, r=2+print_error);
    translate([-(23+2), -20+2, -0.1]) cylinder(h=3+0.2, r=2+print_error);
    translate([-(13+2), -20+2, -0.1]) cylinder(h=3+0.2, r=2+print_error);
    translate([-(3+2), -20+2, -0.1]) cylinder(h=3+0.2, r=2+print_error);
  }
}

/**
 * Крепление для оси
 */
module rod_fix(print_error=0) {
  rod_fix_lenx = 20;
  rod_fix_leny = 20;
  difference() {
    linear_extrude(height=3) import(file="крепление-ось-43d.dxf");
    
    // круглая ось
    translate([-0.1, rod_fix_leny/2, 1]) rotate([0, 90, 0]) 
      cylinder(r=1+print_error, h=rod_fix_lenx+0.2, $fn=100);
    // прямоугольный выход
    translate([-0.1, rod_fix_leny/2-1-print_error, -0.1]) 
      cube([rod_fix_lenx+0.2, 2+print_error*2, 1+0.1]);
      
    // рассверлить отверстия под винты с учетом print_error
    translate([3+2, 3+2, -0.1]) cylinder(h=3+0.2, r=2+print_error);
    translate([3+4+6+2, 3+2, -0.1]) cylinder(h=3+0.2, r=2+print_error);
    translate([3+2, 3+4+6+2, -0.1]) cylinder(h=3+0.2, r=2+print_error);
    translate([3+4+6+2, 3+4+6+2, -0.1]) cylinder(h=3+0.2, r=2+print_error);
  }
}
