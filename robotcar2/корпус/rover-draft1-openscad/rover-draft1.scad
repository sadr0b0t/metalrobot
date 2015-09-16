use <../../gearbox/gearbox-prototype5/box/box.scad>;
use <../chasis-43d/wheel.scad>;

print_error=0.2;


hull();
//frame();


/**
 * Корпус
 */
module hull() {
  difference() {
    // внешняя скорлупка
    translate([55, 55, -15]) rotate([90,0,0])
      linear_extrude(height=110) 
      polygon([ [0,0], [-110,0], [-130,20], 
        [-130,45], [-110,65], [-50,60], [0,35] ]);

    // внутренняя поверхность - оставить толщину ~2мм
    translate([55, 53, -15]) rotate([90,0,0])
      linear_extrude(height=106) 
      polygon([ [-2,0], [-108,0], [-128,20], 
        [-128,45], [-110,63], [-50,58], [-2,35] ]);

    // боковые дырки под редуктор
    translate([-106/2, -112/2, -18]) cube([106, 112, 32]);
  }
}

/**
 * Корпус - черновик
 */
module hull_druft() {
  translate([-55, -55, -18]) cube([110, 110, 2]);
  translate([-55, -55, 15]) cube([110, 110, 2]);

  // сверху
  //translate([-80, -55, 30]) cube([90, 110, 2]);

  //бампер
  //translate([-80, -55, -12]) cube([2, 110, 40]);

  // по бокам
  //translate([-80, -50, -15]) cube([130, 2, 45]);

  // корпус1 (ок)
  /*translate([55, 55, 0]) rotate([90,0,0])
    linear_extrude(height=110) 
    polygon([ [0,0], [-110,0], [-130,20], 
      [-130,40], [-110,50], [-50,45], [0,20] ]);*/

  // корпус2 (ок)
  translate([55, 55, -15]) rotate([90,0,0])
    linear_extrude(height=110) 
    polygon([ [0,0], [-110,0], [-130,20], 
      [-130,45], [-110,65], [-50,60], [0,35] ]);

}

/**
 * Рама (два редуктора и колеса)
 */
module frame() {
  // в сборке
  translate([0, 50, 0]) rotate([90, 0, 0]) gearbox();
  translate([0, -50, 0]) mirror([0, -1, 0])  rotate([90,0,0]) gearbox();

  // колеса слева
  translate([35, -53, -5]) rotate([90, 0, 0]) wheel();
  translate([-35, -53, -5]) rotate([90, 0, 0]) wheel();

  // колеса справа
  mirror([0, -1, 0]) 
    translate([35, -53, -5]) rotate([90, 0, 0]) wheel();
  mirror([0, -1, 0]) 
    translate([-35, -53, -5]) rotate([90, 0, 0]) wheel();
}
