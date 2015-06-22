//breadboard_line();
breadboard_half();

/**
 * Элемент макетной платы.
 */
module breadboard_line(holes=5) {
  difference() {
    cube([3.5, 1+1+2*holes+0.5*(holes-1)+1+1, 8]);

    translate([1, 1, -1]) cube([1.5, 1+2*holes+0.5*(holes-1)+1, 7+1]);
    
    for(hole=[1 : holes]) {
      // ротверстие для штыря
      translate([1+0.25, 1+1+0.5+2.5*(hole-1), 6]) cube([1, 1, 3]);
      // воронка
      translate([1+0.75, 1+1+1+2.5*(hole-1), 6.9]) 
        cylinder(r1=0.5, r2=0.75, h=1.2, $fn=10);
    }
  }
}

module breadboard_half(lines=10, holes=5) {
  for(hole=[1 : lines]) {
    translate([2.5*(hole-1), 0, 0]) breadboard_line(holes);
  }
}
