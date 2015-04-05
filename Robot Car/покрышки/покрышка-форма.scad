
// увеличим ширину фиксирующего обода для внешней формы по сравнению
// с пазом под обод на внутренней форме, чтобы учесть
// погрешность при печати на FDM-принтере
outer_box_half1(4);
//outer_box_half2(4);

//inner_surface(2);

/**
 * Внутренняя поверхность покрышки, должна совпадать 
 * с рельефом колеса.
 * @param hoop_width - ширина обода, выступающего вниз для
 * для фиксации на площадке внешней части формы.
 */
module inner_surface(hoop_width=2) {
  difference() {
    union() {
      // рельеф колеса
      rotate([0, 0, 9]) translate([0, 0, 10]) {
        linear_extrude(height=10, twist=10) 
            import(file = "покрышка-внутр.dxf");
        mirror([0, 0, -1]) 
          linear_extrude(height=10, twist=10) 
            import(file = "покрышка-внутр.dxf");
      }
      // выступаящая вверх стенка, чтобы не разливался силикон
      cylinder(h=23, r=21, $fn=100);
    }


    // вычтем изнутри цилиндр для экономии пластика
    translate([0, 0, -1])
      cylinder(h=25, r=20, $fn=100);
  }

  // выступающий вниз обод для фиксации на площадке
  difference() {
    translate([0, 0, -5])
      cylinder(h=10, r=20+hoop_width/2, $fn=100);

    translate([0, 0, -6])
      cylinder(h=12, r=20-hoop_width/2, $fn=100);
  }

  // фиксторы вращения
  translate([14.5, -1.5, -5])
    cube([6, 3, 6]);
  translate([-20.5, -1.5, -5])
    cube([6, 3, 6]);
}

/**
 * Первая половина внешней коробки.
 * @param hoop_width - ширина обода, выступающего вниз для
 * для фиксации на площадке внешней части формы.
 */
module outer_box_half1(hoop_width=2) {
  difference() {
    outer_box(hoop_width);

    translate([0, -34, -8])
        cube([34, 68, 32]);
  }
}

/**
 * Вторая половина внешней коробки.
 * @param hoop_width - ширина обода, выступающего вниз для
 * для фиксации на площадке внешней части формы.
 */
module outer_box_half2(hoop_width=2) {
  difference() {
    outer_box(hoop_width);

    translate([-34, -34, -8])
        cube([34, 68, 32]);
  }
}

/**
 * Внешняя коробка с рельефом протектора.
 * @param hoop_width - ширина обода, выступающего вниз для
 * для фиксации на площадке внешней части формы.
 */
module outer_box(hoop_width=2) {
  difference() {
    // матрица для рисунка протектора
    translate([0, 0, -7])
      cylinder(h=30, r=33, $fn=100);
    
    // рельефный протектор
    rotate([0, 0, 9]) tyre_pattern();

    // стенка наверху, чтобы не разливался силикон
    translate([0, 0, 19])
      cylinder(h=5, r=32, $fn=100);

    // паз для выступающего вниз обода
    difference() {
      translate([0, 0, -5.5])
        cylinder(h=10, r=20+hoop_width/2, $fn=100);

      translate([0, 0, -6])
        cylinder(h=12, r=20-hoop_width/2, $fn=100);
    }
      
    // пазы для фиксаторов
    translate([14, -2, -5.5])
      cube([6, 4, 6]);
    translate([-20, -2, -5.5])
      cube([6, 4, 6]);

    // внутренняя дырка для экономии пластика
    translate([0, 0, -10])
      cylinder(h=20, r=13, $fn=100);
  }
}

/** Рисунок проектора */
module tyre_pattern() {
  // рельефный протектор
  translate([0, 0, 10]) {
    linear_extrude(height=10, twist=10) 
        import(file = "покрышка-внешн.dxf");
    mirror([0, 0, -1]) 
      linear_extrude(height=10, twist=10) 
        import(file = "покрышка-внешн.dxf");
  }
}
