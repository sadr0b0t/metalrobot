
sonar();
//ir_line_sensor();

/**
 * Плата Arduino Uno (ChipKIT Uno32)
 */
module sonar() {
  // плата
  translate([0, 2, 1]) cube([26, 14, 2], center=true);
  
  translate([-7, 0, 2]) cylinder(r=5, h=6, $fn=100);
  translate([7, 0, 2]) cylinder(r=5, h=6, $fn=100);
  
  // штыри
  translate([0, 10, 2.5]) cube([8, 6, 3], center=true);
}

/**
 * Инфракрасный датчик линии
 */
module ir_line_sensor() {
  module ir() {
    cylinder(r=1, h=6, $fn=100);
    translate([0, 0, 6]) sphere(r=1, $fn=100);
  }
    
  // плата
  translate([0, 0, 1]) cube([6, 12, 2], center=true);
  
  // настроечный резистор
  translate([0, -2, 3]) cube([3, 3, 2], center=true);
  
  // штыри
  translate([0, -6, 2]) cube([3, 4, 2], center=true);
  
  // лампочки
  translate([1.5, 3, 2.5]) rotate([-90, 0, 0]) ir();
  translate([-1.5, 3, 2.5]) rotate([-90, 0, 0]) ir();
}
