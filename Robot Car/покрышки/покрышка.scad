// покрышка подойдет на любое колесо
tyre();


/** Покрышка на колесо */
module tyre() {

  // рельефный протектор
  translate([0, 0, 10]) {
    linear_extrude(height=10, twist=10) 
        import(file = "покрышка.dxf");
    mirror([0, 0, -1]) 
      linear_extrude(height=10, twist=10) 
        import(file = "покрышка.dxf");
  }
}
