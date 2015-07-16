use <../gears/gears.scad>;


// половинка с мотором
//box_half_motor();

// половинка с колесами
box_half_wheels();

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

  gear_motor_height = 3;
  gear_transmission_height1 = 0.3+3;
  gear_transmission_height2 = 5;
  gear_transmission_height = 
    gear_transmission_height1+gear_transmission_height2;
  gear_wheel_height = 0.3+3;

  // стенки
  box_half_wheels();
  translate([0, 0, wheels_half_height+0.1+gear_transmission_height+0.1]) 
    box_half_motor();
  
  // шестерни (см координаты в gearbox4-dev.svg в Inkscape)

  // шестерня на вал мотора
  translate([0, 0, wheels_half_height + 0.1])
    gear_motor(print_error=0.2); // diam=2.4

  // передача от мотора к колесу
  // слева
  translate([-14.9-1, -6.1+1, 0.3+wheels_half_height+0.1])
    gear_transmission(print_error=0.2);
  // справа
  translate([14.9+1, -6.1+1, 0.3+wheels_half_height+0.1])
    gear_transmission(print_error=0.2);

  // шестерня на колесо
  // слева
  translate([-33.5-1.5, -6.6+1.5, 
    0.3+wheels_half_height+0.1+gear_transmission_height1+0.1])
      gear_wheel(print_error=0.1);
  // справа
  translate([33.5+1.5, -6.6+1.5, 
    0.3+wheels_half_height+0.1+gear_transmission_height1+0.1])
      gear_wheel(print_error=0.1);
}



/**
 * Половина коробки со стороны мотора.
 */
module box_half_motor() {

  // внутренняя поверхность
  linear_extrude(height=3) 
    import(file="box-motor-inside-43d.dxf");

  // внешняя стенка
  translate([0, 0, 2.9]) linear_extrude(height=1.1)
    import(file="box-motor-wall-43d.dxf");

  // крепление мотора
  translate([0, 0, 3.9]) motor_fix();
}

/**
 * Половина коробки со стороны колёс.
 */
module box_half_wheels() {
  // значения высоты для разных деталей
  wheels_half_height = 4;

  // шестеренки
  gear_motor_height = 3;
  gear_transmission_height1 = 0.3+3;
  gear_transmission_height2 = 5;
  gear_transmission_height = 
    gear_transmission_height1+gear_transmission_height2;
  gear_wheel_height = 0.3+3;

  // внешняя стенка
  linear_extrude(height=1.1)
    import(file="box-wheels-wall-43d.dxf");

  // внутренняя поверхность
  translate([0, 0, 1]) linear_extrude(height=3) 
    import(file="box-wheels-inside-43d.dxf");

  // стойки для винтов и шестеренок

  // для винтов (см координаты в gearbox4-dev.svg в Inkscape)
  // левый верхний
  translate([-49+2, 4.9+2, wheels_half_height-0.1])
    box_column(height=0.1+gear_transmission_height+0.2);
  // левый нижний
  translate([-49+2, -19.1+2, wheels_half_height-0.1])
    box_column(height=0.1+gear_transmission_height+0.2);

  // правый верхний
  translate([49-2, 4.9+2, wheels_half_height-0.1])
    box_column(height=0.1+gear_transmission_height+0.2);
  // правый нижний
  translate([49-2, -19.1+2, wheels_half_height-0.1])
    box_column(height=0.1+gear_transmission_height+0.2);

  // винт по центру
  translate([0, -19+2, wheels_half_height-0.1])
    box_column(height=0.1+gear_transmission_height+0.2);


  // для шестеренок на моторах 
  // (см координаты в gearbox4-dev.svg в Inkscape)
  // слева
  translate([-33.5-1.5, -6.6+1.5, wheels_half_height-0.1])
    box_column(height=0.1+gear_transmission_height1+0.2);
  // справа
  translate([33.5+1.5, -6.6+1.5, wheels_half_height-0.1])
    box_column(height=0.1+gear_transmission_height1+0.2);
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
  }
}

/**
 * Стойки для коробки и шестеренок.
 * внутреннее отверстие для винта=4мм 
 * (+зазор 1мм для погрешности печати)
 */
module box_column(height=6, r1=3.5, r2=2.5) {
  difference(){
    cylinder(h=height, r=r1, $fn=100);
    translate([0,0,-1])
      cylinder(h=height+2, r=r2, $fn=100);
  }
}
