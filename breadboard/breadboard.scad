//breadboard_line();
//breadboard_half(lines=7);
breadboard_half(lines=2);

/**
 * Элемент макетной платы - линия, соединенная контактами.
 * @param holes количество отверстий на линии
 */
module breadboard_line(holes=5) {
  difference() {
    translate ([.2, 0, 0]) 
      cube([3.5-0.4, 1.5+1+2*holes+0.5*(holes-1)+1+1.5, 8]);

    // 1.5мм - ширина отсека для контакта + 0.4м для печати 
    translate([1-0.2, 1, -1])
      cube([1.5+.4, 1.5+2*holes+0.5*(holes-1)+1.5, 7+1]);
    
    for(hole=[1 : holes]) {
      // отверстие для штыря
      translate([1+0.25, 1.5+1+0.5+2.5*(hole-1), 6]) cube([1, 1, 3]);
      // воронка (на билдере получается хрень, а не воронка)
      //translate([1+0.75, 1+1+1+2.5*(hole-1), 6.9]) 
      //  cylinder(r1=0.5, r2=0.75, h=1.2, $fn=10);
    }
  }

  // добавим ножки снизу
  for(hole=[1 : holes+2]) {
      translate([0.2, 1.5+1+0.5+2.5*(hole-2), -1]) cube([.6, 1, 1]);
      translate([2.7, 1.5+1+0.5+2.5*(hole-2), -1]) cube([.6, 1, 1]);
  }
}

/**
 * Половина макетной платы - ряд линий.
 * @param lines количество линий
 * @param holes количество отверстий на каждой линии
 */
module breadboard_half(lines=10, holes=5) {
  // добавить толщины по бокам
  cube([.4, 1.5+1+2*holes+0.5*(holes-1)+1+1.5, 8]);
  translate([.2 + 2.5*(lines-1) + 3.3, 0, 0])
    cube([.4, 1.5+1+2*holes+0.5*(holes-1)+1+1.5, 8]);

  for(line=[1 : lines]) {
    translate([.2 + 2.5*(line-1), 0, 0]) 
      breadboard_line(holes);
  }
}
