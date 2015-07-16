3dp_error = 0.2;
//3dp_error = 0.3;
//3dp_error = 0.4;

// Печатать с макс скоростью (по крайней мере мелкие t8 и t9),
// 100% заполнение, 
// тонкая настройка качества печати: обрамление детали=Нет

// gears1:
// t27: dmotor2, d3, d2.8, d2.6
// t8-d2.4 - не ОК
// t9-d2.6 - не ОК
//
//gears2:
// t8-d2.2 - ОК, но не влезает на вал
// t9-d2.4, d2.2
// t27-motor2-e0.3, e0.4: ch1.2, 
// t27-motor2-e0.4: ch1.1
//
// gears3
// t63-d2.2-h0.2, t63-d2.4-h0.4
// 
// gears4
// t63-d2.2-h0.5-supg
// t63-motor2-e0.3-ch1-h0.5
// t27-motor2-e0.3-ch1-h0.5
// t8-d2.2 - ОК, но не влезает на вал
// t9-d2.4 - ОК и налезает (и крутится)
// t9-d2.2 - не ОК (расползается после печати)
// волшебным образом (при генерации слайсером) t9-d2.4 печатается
// нормально, т.к. принтер отрисовывает внутреннее кольцо, а t9-d2.2
// сразу расползается на отдельные зубья (хотя диаметр кольца меньше и 
// по логике дожно быть наоборот)
//
// gears5 (Builder)
// t9-d2.2 - развалились (нужно было t9-d2.4!)
// gears-cp1.5-t27-d2.2-h0.3
// gears-cp1.5-t27-motor2-e0.2-ch1-h0.3
// gears-cp1.5-t43-d2.2-h0.3

// gears5
// t9-d2.4 9шт

difference() {
  union() {
    // шестеренка
    //linear_extrude(height=3) import(file="gear-cp1.5-t8.dxf");
    //linear_extrude(height=3) import(file="gear-cp1.5-t9.dxf");
    linear_extrude(height=3) import(file="gear-cp1.5-t27.dxf");
    //linear_extrude(height=3) import(file="gear-cp1.5-t43.dxf");
    //linear_extrude(height=3) import(file="gear-cp1.5-t63.dxf");

    // подсадка, чтобы не расплывались зубья
    // для 27
    translate([0, 0, -0.3]) cylinder(h=1, r=5.7, $fn=100);

    // для 43
    //translate([0, 0, -0.3]) cylinder(h=1, r=9.6, $fn=100);
   
    // для 63
    //translate([0, 0, -0.3]) cylinder(h=1, r=14, $fn=100);
    //translate([0, 0, -0.5]) 
    //  linear_extrude(height=1) import(file="gear-cp1.5-t63-support.dxf");
  
    // второй уровень
    //translate([0, 0, 2]) 
    //  linear_extrude(height=4) import(file="gear-cp1.5-t27.dxf");
  }
   
  // t8-d2.0 - ОК
  // t8-d2.4 - не ОК
  // t9-d2.6 - не ОК

  // ось
  //generic_axis(radius=1+3dp_error); // diam=3  
  //motor2_axis(radius=1.5+3dp_error, cut_h=1.2+3dp_error);
  //motor2_axis(radius=1.5+3dp_error, cut_h=1.1+3dp_error);
  //motor2_axis(radius=1.5+3dp_error, cut_h=1+3dp_error);
  motor2_axis(radius=1.5+3dp_error, cut_h=0.9+3dp_error);

  //generic_axis(radius=1.5); // diam=3
  //generic_axis(radius=1.4); // diam=2.8
  //generic_axis(radius=1.3); // diam=2.6
  //generic_axis(radius=1.2); // diam=2.4
  generic_axis(radius=1.1); // diam=2.2
  //motor2_axis();
}


/**
 * Просто круглая ось, по умолчанию диаметр 3мм.
 */
module generic_axis(length=22, radius=1.5) {
  translate([0,0,-1])
    cylinder(h=length, r=radius, $fn=20);
}


/** 
 * Ось для для мотора 2:
 * Pololu 4.5V, 80rpm Right Angle (прямой, желтый)
 * www.robotshop.com/en/solarbotics-gm7-gear-motor-7.html
 *
 * Диаметр оси мотора 3мм, расстояние от центра до среза 
 * с одного бока cut=0.9мм.
 */
module motor2_axis(length=22, radius=1.5, cut_radius=0.9) {
  // диаметр 3мм, срез с одного бока 0.3мм
  translate([0,0,-1])
  difference() {
    cylinder(h=length, r=radius, $fn=20);
    // 1.5 мм "вниз" по y (совместить куб с цилиндром), 
    // 1.1 "вправо" по x (срезать справа, для cut=0.3мм: 1.5-0.3=1.2)
    translate([cut_h, -1.5, 0]) 
      cube([2, 3, length]);
  }
}
