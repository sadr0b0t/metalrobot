
// мотор Pololu с лыской 
pololu_dshaft();

// ось 2мм 15см в длину
//generic_axis(r=1, length=150);

/** 
 * Просто круглая ось
 * @param length длина оси
 * @param radius радиус, по умолчанию 1мм 
 */
module generic_axis(length=22, radius=1) {
  translate([0,0,-1])
    cylinder(h=length, r=radius, $fn=100);
}


/** 
 * Ось с лыской.
 * Диаметр оси 3мм, срез с одного бока 1мм.
 * @param length длина оси
 */
module dshaft_axis(length=22) {
  // диаметр 3мм, срез с одного бока 1мм
  translate([0,0,-1])
  difference() {
    cylinder(h=length, r=1.5, $fn=100);
    translate([0.75, -1.5, 0]) 
      cube([2, 3, length]);
  }
}

/**
 * Мотор с редуктором Pololu (без вала)
 */
module pololu() {
  // бокс с мотором
  translate([2.5, 1.5, 0]) cube([20, 11, 20]);
  translate([1, 3.5, 0]) cube([23, 7, 20]);

  // "юбочка"
  translate([0, 0, 2]) cube([25, 14, 3]);
  
  // редуктор
  translate([2.5, 0, -28]) cube([20, 14, 30]);
  
  // вал
  translate([12.5, 0, -28]) rotate([270, 0, 0]) 
    cylinder(r=10, h=14);
}

/**
 * Мотор с редуктором Pololu, вал с лыской
 */
module pololu_dshaft() {
  pololu();

  // ось
  translate([12.5, 12, -28]) rotate([90, 0, 0]) 
    dshaft_axis();
}

