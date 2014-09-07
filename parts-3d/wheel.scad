wheel_with_axis();

/** Колесо с отверстием под ось */
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

/** Колесо */
module wheel() {

  // внешний обод
  difference() {
    // лысая резина
    //cylinder(h=20, r=25, $fn=100);
    // рельефный протектор
    translate([0, 0, 10]) {
      linear_extrude(height=10, twist=10) 
          import(file = "протектор.dxf");
      mirror([0, 0, -1]) 
        linear_extrude(height=10, twist=10) 
          import(file = "протектор.dxf");
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

/**
 * Просто круглая ось, по умолчанию 
 * диаметр 1,5мм 
 */
module generic_axis(length=22, radius=0.75) {
  translate([0,0,-1])
    cylinder(h=length, r=radius, $fn=20);
}

/** 
 * Ось для для мотора 1:
 * GM7 - Gear Motor 7 - Baby GM3 (прямой, белый)
 * www.robotshop.com/en/solarbotics-gm7-gear-motor-7.html
 *
 * Диаметр оси мотора 2мм, сделаем модель 1,5мм.
 */
module motor1_axis(length=22) {
  // 1,5мм диаметр
  generic_axis(length, 0.75);
}

/** 
 * Ось для для мотора 2:
 * Pololu 4.5V, 80rpm Right Angle (прямой, желтый)
 * www.robotshop.com/en/solarbotics-gm7-gear-motor-7.html
 *
 * Диаметр оси мотора 3мм, срез с одного бока 0,5мм.
 */
module motor2_axis(length=22) {
  // диаметр 3мм, срез с одного бока 0,5мм
  translate([0,0,-1])
  difference() {
    cylinder(h=length, r=1.5, $fn=20);
    // 1,5 мм "вниз" по y (совместить куб с цилиндром), 
    // 1 "вправо" по x (срезать справа 0,5мм: 1,5-0,5=1)
    translate([1, -1.5, 0]) 
      cube([2, 3, length]);
  }
}

/** 
 * Ось для для мотора 3:
 * GM2 - Gear Motor 2 Offset Shaft (угловой, белый)
 * http://www.robotshop.com/en/solarbotics-gm2-gear-motor-2-offset.html
 *
 * Диаметр оси мотора 2мм, сделаем модель 1,5мм.
 */
module motor3_axis(length=22) {
  // 1,5мм диаметр
  translate([0,0,-1])
    cylinder(h=length, r=0.75, $fn=20);
}

/** 
 * Ось для для мотора 4:
 * DFRobot 6V,180rpm Micro DC Geared (угловой, желтый)
 * www.robotshop.com/en/dfrobot-6v-180-rpm-micro-dc-geared-motor-with-back-shaft.html
 *
 * Диаметр оси мотора 5мм, срезы по бокам 
 * (3мм сердцевина).
 */
module motor4_axis(length=22) {
  // 5мм диаметр, 
  // срезы по бокам (3мм сердцевина)
  translate([0,0,-1])
  difference() {
    cylinder(h=length, r=2.5, $fn=22);
    translate([1.5, -2.5, 0]) 
      cube([2.5, 5, length]);
    translate([-2.5-1.5, -2.5, 0]) 
      cube([2.5, 5, length]);
  }
}
