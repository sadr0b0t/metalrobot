$fn=100;

rover();

module rover() {
  difference() {
    hull() {
      
      // бампер
      translate([-10, 20, 0]) sphere(5);
      translate([10, 20, 0]) sphere(5);
      
      translate([-10, 22, 15]) sphere(10);
      translate([10, 22, 15]) sphere(10);
      
      // крыша
      translate([-10, 0, 20]) sphere(5);
      translate([10, 0, 20]) sphere(5);
      
      // задний бампер
      translate([-10, -30, 10]) sphere(5);
      translate([10, -30, 10]) sphere(5);
    
      translate([-10, -30, 0]) sphere(5);
      translate([10, -30, 0]) sphere(5);
    }
    
    translate([-21, -20, -10]) cube([42, 40, 20]);
  }
}
