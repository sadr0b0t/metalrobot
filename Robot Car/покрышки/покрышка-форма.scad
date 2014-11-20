
//outer_box_half1();
//outer_box_half2();
inner_surface();

/**
 * Внутренняя поверхность покрышки, должна совпадать 
 * с рельефом колеса
 */
module inner_surface() {
  difference() {
    // рельеф колеса
    translate([0, 0, 10]) {
      linear_extrude(height=10, twist=10) 
          import(file = "покрышка-внутр.dxf");
      mirror([0, 0, -1]) 
        linear_extrude(height=10, twist=10) 
          import(file = "покрышка-внутр.dxf");
    }
    // вычтем изнутри цилиндр для экономии пластика
    translate([0, 0, -1])
      cylinder(h=22, r=20, $fn=100);
  }

  // выступающий вниз обод для фиксации на площадке
  difference() {
    translate([0, 0, -2])
      cylinder(h=10, r=21, $fn=100);

    translate([0, 0, -3])
      cylinder(h=12, r=18, $fn=100);
  }
}

/**
 * Первая половина внешней коробки.
 */
module outer_box_half1() {
  difference() {
    outer_box();

    translate([0, -32, -5])
        cube([32, 64, 26]);
  }
}

/**
 * Вторая половина внешней коробки.
 */
module outer_box_half2() {
  difference() {
    outer_box();

    translate([-32, -32, -5])
        cube([32, 64, 26]);
  }
}

/**
 * Внешняя коробка с рельефом протектора.
 */
module outer_box() {
  difference() {
    // матрица для рисунка протектора
    difference() {
      translate([0, 0, -4])
        cylinder(h=24, r=31, $fn=100);
    
      // рельефный протектор
      tyre_pattern();
    }

    // паз для выступающего вниз обода
    difference() {
      translate([0, 0, -2])
        cylinder(h=10, r=21, $fn=100);

      translate([0, 0, -3])
        cylinder(h=12, r=18, $fn=100);
    }
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
