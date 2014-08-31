
// Корпус
translate([0, 110]) rotate([-20, 0, 0]) translate([0, -110]) {
  // корпус
  linear_extrude(height=3) 
    import(file = "корпус.dxf");

  // рама (крепление моторов)
  translate([0, 10, -6])
    linear_extrude(height=3) 
      import(file = "рама-моторы.dxf");

  // моторы
  // левый
  translate([0, 42, -5]) rotate([0, 0, 270]) 
    motor2();
  // правый
  translate([110, 17, -5]) rotate([0, 0, 90]) 
    motor2();
}

// Днище
translate([0, -5, -1]) linear_extrude(height=3) 
  import(file = "днище.dxf");


// Колеса
wheels();

/* Колеса */
module wheels() {
  // переднее левое
  translate([0, 23, -4]) rotate([0, 270, 0])
    wheel_with_axis();
  // заднее левое
  translate([0, 100, -2]) rotate([0, 270, 0])
    wheel_with_axis();

  // переднее правое
  translate([110, 23, -4]) rotate([0, 90, 0])
    wheel_with_axis();
  // заднее правое
  translate([110, 100, -2]) rotate([0, 90, 0])
    wheel_with_axis();
}


/* Колесо с отверстием под ось */
module wheel_with_axis() {
  difference() {
    wheel();
    //generic_axis();
    //motor1_axis();
    motor2_axis();
    //motor3_axis();
    //motor4_axis();
  }
}

/* Колесо */
module wheel() {
  // внешний обод
  difference() {
    translate([0, 0, 10]) {
      mirror([0, 0, -1]) linear_extrude(height=10, center=false, twist=10) 
        import(file = "колесо.dxf");
      linear_extrude(height=10, center=false, twist=10) 
        import(file = "колесо.dxf");
    }

    translate([0, 0, -1])
      cylinder(h=22, r=20, $fn=100);
  }

  // внутренний вал
  cylinder(h=20, r=5, $fn=100);

  // спицы
  for(angle = [0, 72, 144, 216, 288]) {
    rotate(a=angle) 
      cube([22, 3, 10]);
  }
}

/* Просто круглая ось, по умолчанию диаметр 1мм */
module generic_axis(length=22, radius=0.5) {
  translate([0,0,-1])
    cylinder(h=length, r=radius, $fn=20);
}

/** 
 * Ось для для мотора 1 (прямой, белый).
 * Диаметр оси мотора 2мм, сделаем модель 1,5мм.
 */
module motor1_axis(length=22) {
  // 1,5мм диаметр
  generic_axis(length, 0.75);
}

/** 
 * Ось для для мотора 2 (прямой, желтый).
 * Диаметр оси мотора 3мм, срез с одного бока 1мм.
 */
module motor2_axis(length=22) {
  // диаметр 3мм, срез с одного бока 1мм
  translate([0,0,-1])
  difference() {
    cylinder(h=length, r=1.5, $fn=20);
    translate([0.75, -1.5, 0]) 
      cube([2, 3, length]);
  }
}

module motor2() {
  // бокс с мотором
  translate([2.5, 1.5, 0]) cube([20, 11, 20]);
  translate([1, 3.5, 0]) cube([23, 7, 20]);

  // "юбочка"
  translate([0, 0, 2]) cube([25, 14, 3]);
  
  // редуктор
  translate([2.5, 0, -28]) cube([20, 14, 30]);
  
  // вал
  translate([12.5, 0, -28]) rotate([270, 0, 0]) 
    cylinder(r=10, h=14);

  // ось
  translate([12.5, 12, -28]) rotate([90, 0, 0]) 
    motor2_axis();
}

