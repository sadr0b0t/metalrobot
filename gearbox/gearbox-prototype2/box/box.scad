use <../gears/gears.scad>;

print_error=0.2;

// половинка с мотором
//box_half_motor(print_error=print_error);

// половинка с колесами
box_half_wheels(print_error=print_error);

// в сборке
//gearbox();

//motor_fix();

/**
 * Редуктор в сборке.
 */
module gearbox() {
  // значения высоты для разных деталей
  wheels_half_height = 4;
  //motor_half_height = 4;

  gear_motor_height = 5;
  gear_transmission_height1 = 0.3+3;
  gear_transmission_height2 = 5;
  gear_transmission_height = 
    gear_transmission_height1+gear_transmission_height2;
  gear_wheel_height = 0.3+3;

  // стенки
  box_half_wheels();
  translate([0, 0, wheels_half_height+0.5+gear_transmission_height+0.5]) 
    box_half_motor();
  
  // шестерни (см координаты в gearbox4-dev.svg в Inkscape)

  // шестерня на вал мотора
  translate([0, 0, wheels_half_height + 0.1])
    gear_motor(print_error=0.2); // diam=2.4

  // передача от мотора к колесу
  // слева
  translate([-15.9, -5.1, 0.3+wheels_half_height+0.5])
    gear_transmission(print_error=0.2);
  // справа
  translate([15.9, -5.1, 0.3+wheels_half_height+0.5])
    gear_transmission(print_error=0.2);

  // шестерня на колесо
  // слева
  translate([-35, -5.1, 
    0.3+wheels_half_height+1.5+gear_transmission_height1+0.1])
      gear_wheel(print_error=0.1);
  // справа
  translate([35, -5.1, 
    0.3+wheels_half_height+1.5+gear_transmission_height1+0.1])
      gear_wheel(print_error=0.1);
}



/**
 * Половина коробки со стороны мотора.
 */
module box_half_motor(print_error=0) {
  // для "рассверливания" дырок
  max_height=wheels_half_height+gear_transmission_height;
  screw_bar_r = 2.5;
  

  difference() {
    union() {
      // внутренняя поверхность
      linear_extrude(height=3) 
        import(file="box-motor-inside-43d.dxf");

      // внешняя стенка
      translate([0, 0, 2.9]) linear_extrude(height=1.1)
        import(file="box-motor-wall-43d.dxf");

      // крепление мотора
      translate([0, 0, 3.9]) motor_fix();
    }

    // "рассверлить" дырки для учета погрешности при печати на 3д-принтере,
    // добавить углубления стоек

    // для винтов (см координаты в gearbox4-dev.svg в Inkscape)
    // левый верхний
    translate([-47.4, 7.3, -1])
      cylinder(r=1.5+print_error, h=max_height+2, $fn=100);
    // для стойки
    translate([-47.4, 7.3, -1])
      cylinder(r=screw_bar_r+print_error, h=3, $fn=100);
    // левый нижний
    translate([-47.4, -17.6, -1])
      cylinder(r=1.5+print_error, h=max_height+2, $fn=100);
    // для стойки
    translate([-47.4, -17.6, -1])
      cylinder(r=screw_bar_r+print_error, h=3, $fn=100);

    // правый верхний
    translate([47.4, 7.3, -1])
      cylinder(r=1.5+print_error, h=max_height+2, $fn=100);
    // для стойки
    translate([47.4, 7.3, -1])
      cylinder(r=screw_bar_r+print_error, h=3, $fn=100);
    // правый нижний
    translate([47.4, -17.6, -1])
      cylinder(r=1.5+print_error, h=max_height+2, $fn=100);
    // для стойки
    translate([47.4, -17.6, -1])
      cylinder(r=screw_bar_r+print_error, h=3, $fn=100);

    // винт по центру
    translate([0, -17.6, -1])
      cylinder(r=1.5+print_error, h=max_height+2, $fn=100);
    // для стойки
    translate([0, -17.6, -1])
      cylinder(r=screw_bar_r+print_error, h=3, $fn=100);


    // для шестеренок на колесах 
    // (см координаты в gearbox4-dev.svg в Inkscape)
    // слева
    translate([-35, -5.1, -1])
      cylinder(r=1.5+print_error, h=4, $fn=100);
    // справа
    translate([35, -5.1, -1])
      cylinder(r=1.5+print_error, h=4, $fn=100);

    // для шестеренок на передачах
    // слева
    translate([-15.9, -5.1, -1])
      cylinder(r=1+print_error, h=4, $fn=100);
    // справа
    translate([15.9, -5.1, -1])
      cylinder(r=1+print_error, h=4, $fn=100);
  }
}

/**
 * Половина коробки со стороны колёс.
 */
module box_half_wheels(print_error=0) {
  // значения высоты для разных деталей
  wheels_half_height = 4;

  // шестеренки
  gear_motor_height = 3;
  gear_transmission_height1 = 0.3+3;
  gear_transmission_height2 = 5;
  gear_transmission_height = 
    gear_transmission_height1+gear_transmission_height2;
  gear_wheel_height = 0.3+3;

  // высота стоек между половинками коробки (с учетом утопления)
  screw_bar_height = 0.5+gear_transmission_height+0.5+2;
  screw_head_radius = 3.5;

  // для "рассверливания" дырок
  max_height=wheels_half_height+gear_transmission_height;

  
  difference() {
    union() {
      // внешняя стенка
      linear_extrude(height=1.1)
        import(file="box-wheels-wall-43d.dxf");

      // внутренняя поверхность
      translate([0, 0, 1]) linear_extrude(height=3) 
        import(file="box-wheels-inside-43d.dxf");

      // стойки для винтов и шестеренок

      // для винтов (см координаты в gearbox4-dev.svg в Inkscape)
      // левый верхний
      translate([-47.4, 7.3, wheels_half_height-0.1])
        box_column(height=0.1+screw_bar_height);
      // левый нижний
      translate([-47.4, -17.6, wheels_half_height-0.1])
        box_column(height=0.1+screw_bar_height);

      // правый верхний
      translate([47.4, 7.3, wheels_half_height-0.1])
        box_column(height=0.1+screw_bar_height);
      // правый нижний
      translate([47.4, -17.6, wheels_half_height-0.1])
        box_column(height=0.1+screw_bar_height);

      // винт по центру
      translate([0, -17.6, wheels_half_height-0.1])
        box_column(height=0.1+screw_bar_height);


      // стойки для шестеренок на колесах 
      // (см координаты в gearbox4-dev.svg в Inkscape)
      // слева
      translate([-35, -5.1, wheels_half_height-0.1])
        box_column(height=0.1+gear_transmission_height1+1.5);
      // справа
      translate([35, -5.1, wheels_half_height-0.1])
        box_column(height=0.1+gear_transmission_height1+1.5);

      // стойки для шестеренок на передачах
      // слева
      translate([-15.9, -5.1, wheels_half_height-0.1])
        box_column(height=0.5+0.1);
      // справа
      translate([15.9, -5.1, wheels_half_height-0.1])
        box_column(height=0.5+0.1);
    }

    // "рассверлить" дырки для учета погрешности при печати на 3д-принтере,
    // добавить углубления для головок винтов

    // для винтов (см координаты в gearbox4-dev.svg в Inkscape)
    // левый верхний
    translate([-47.4, 7.3, -1])
      cylinder(r=1.5+print_error, h=max_height+2, $fn=100);
    // головка винта
    translate([-47.4, 7.3, -2])
      cylinder(r=screw_head_radius+print_error, h=3, $fn=100);
    // левый нижний
    translate([-47.4, -17.6, -1])
      cylinder(r=1.5+print_error, h=max_height+2, $fn=100);
    // головка винта
    translate([-47.4, -17.6, -2])
      cylinder(r=screw_head_radius+print_error, h=3, $fn=100);

    // правый верхний
    translate([47.4, 7.3, -1])
      cylinder(r=1.5+print_error, h=max_height+2, $fn=100);
    // головка винта
    translate([47.4, 7.3, -2])
      cylinder(r=screw_head_radius+print_error, h=3, $fn=100);
    // правый нижний
    translate([47.4, -17.6, -1])
      cylinder(r=1.5+print_error, h=max_height+2, $fn=100);
    // головка винта
    translate([47.4, -17.6, -2])
      cylinder(r=screw_head_radius+print_error, h=3, $fn=100);

    // винт по центру
    translate([0, -17.6, -1])
      cylinder(r=1.5+print_error, h=max_height+2, $fn=100);
    // головка винта
    translate([0, -17.6, -2])
      cylinder(r=screw_head_radius+print_error, h=3, $fn=100);


    // для шестеренок на колесах 
    // (см координаты в gearbox4-dev.svg в Inkscape)
    // слева
    translate([-35, -5.1, -1])
      cylinder(r=1.5+print_error, h=max_height+2, $fn=100);
    // справа
    translate([35, -5.1, -1])
      cylinder(r=1.5+print_error, h=max_height+2, $fn=100);

    // для шестеренок на передачах
    // слева
    translate([-15.9, -5.1, 1])
      cylinder(r=1+print_error, h=max_height+2, $fn=100);
    // справа
    translate([15.9, -5.1, 1])
      cylinder(r=1+print_error, h=max_height+2, $fn=100);
  }
}

/**
 * Крепление мотора.
 */
module motor_fix() {
  // блок для мотора
  size_x = 24;
  size_y = 17.4;
  difference() {
    translate([-size_x/2, -size_y/2, 0]) cube([size_x, size_y, 20]);

    translate([0, 0, -1])
      linear_extrude(height=22)
        import(file="motor_face-43d.dxf");

    // пазик для контактов
    translate([-15/2, -size_y/2-1, 16]) cube([15, 3, 5]);
  }
}

/**
 * Стойки для коробки и шестеренок.
 * внутреннее отверстие для винта=4мм 
 * (+зазор 1мм для погрешности печати)
 */
module box_column(height=6, r1=2.5, r2=1.5) {
  difference(){
    cylinder(h=height, r=r1, $fn=100);
    translate([0,0,-1])
      cylinder(h=height+2, r=r2, $fn=100);
  }
}
