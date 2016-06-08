print_error = 0.2;

//angle_1xX(holes=1, print_error=print_error);
//angle_1xX(holes=2, print_error=print_error);
angle_1xX(holes=3, print_error=print_error);
//angle_1xX(holes=4, print_error=print_error);

/**
 * Уголок: одно отверстие в высоту, произвольное количество 
 * отверстий в длину.
 *
 * Диаметр отверстия 4мм, расстояние между краями отверстий 6мм.
 * 
 * @param holes количество отверстий
 * @param print_error погрешность при печати
 */
module angle_1xX(holes=1, print_error=print_error) {
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
    translate([5, 3, 2+3+2]) rotate ([90, 0, 0]) 
      cylinder(h=4, r=2+print_error, $fn=100);

    // дырки по Y
    for(hole=[1 : holes]) {
      translate([5, 2-3+(6+4)*hole-2, -1]) 
        cylinder(h=4, r=2+print_error, $fn=100);
    }   
  }
}
