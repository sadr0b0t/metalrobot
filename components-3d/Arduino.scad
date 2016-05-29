
arduino();

/**
 * Плата Arduino Uno (ChipKIT Uno32)
 */
module arduino() {
  cube([50,60,2]);
  
  // аналоговые пины
  translate([0, 0, 2]) cube([4, 15, 10]);
  // питание
  translate([0, 20, 2]) cube([4, 20, 10]);
  // GPIO
  translate([50-4, 0, 2]) cube([4, 40, 10]);
    
  // чип
  translate([20, 10, 2]) cube([15, 15, 2]);
    
  // питание
  translate([0, 52, 2]) cube([8, 8, 4]);
  translate([4, 52, 5]) rotate([-90, 0, 0]) cylinder(r=4, h=10, $fn=100);
    
  // USB
  translate([40, 48, 2]) cube([8, 12, 8]);
}
