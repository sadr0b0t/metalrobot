//angle1(1);
angle1(2);
//angle1(3);

module angle1(holes=1) {
  // отверстие=4мм
  // расстояние между отверстиями=6мм
  // расстояние от отверстия до края=3мм
  // толщина стенки=2мм

  difference() {
    union() {
      // в высоту по Z
      cube([3+4+3, 2, 2+3+4+3]);
      // в длину по Y
      cube([3+4+3, 2+(6+4)*holes, 2]);
    }
    // дырки по Z
    translate([5, 3, 2+3+2]) rotate ([90, 0, 0]) cylinder(h=4, r=2, $fn=100);

    // дырки по Y
    for(hole=[1 : holes]) {
      translate([5, 2-3+(6+4)*hole-2, -1]) cylinder(h=4, r=2, $fn=100);
    }   
  }
}
