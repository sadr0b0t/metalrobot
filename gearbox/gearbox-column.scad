
//box_column();
//gear_shim();
motor_fix();

/**
 * Стойки для коробки: 
 * высота=6мм
 * внутреннее отверстие для винта=4мм
 */
module box_column() {
  difference(){
    cylinder(h=6, r=5, $fn=100);
    translate([0,0,-1])
      cylinder(h=8, r=2.2, $fn=100);
  }
}

/**
 * Прокладка для шестеренки:
 * высота=1мм
 * 
 */
module gear_shim() {
  difference(){
    cylinder(h=1, r=4, $fn=100);
    translate([0,0,-1])
      cylinder(h=3, r=1.2, $fn=100);
  }
}

module motor_fix() {
  // блок для мотора
  difference() {
    translate([-12, 0, 0]) cube([24, 17, 20]);

    translate([-10, 0, -1])
      linear_extrude(height=22)
        import(file="motor_face.dxf");
  }

  // крепления
  difference() {
    translate([-18-11, 0, 0]) cube([18, 8, 2]);
    
    translate([-25, 4, -1]) cylinder(h=4, r=2, $fn=100);
  }

  difference() {
    translate([11, 0, 0]) cube([18, 8, 2]);
    
    translate([25, 4, -1]) cylinder(h=4, r=2, $fn=100);
  }

  difference() {
    translate([-4, 16, 0]) cube([8, 12, 2]);
    
    translate([0, 24, -1]) cylinder(h=4, r=2, $fn=100);
  }
}

