difference() {
  wheel();
  //generic_axis();
  //motor1_axis();
  //motor2_axis();
  //motor3_axis();
  motor4_axis();
}

module generic_axis(length=17) {
  // 1мм диаметр
  translate([0,0,-1])
    cylinder(h=length, r=0.5, $fn=20);
}
module motor1_axis(length=17) {
  // 1,5мм диаметр
  translate([0,0,-1])
    cylinder(h=length, r=0.75, $fn=20);
}
module motor2_axis(length=17) {
  // 5мм диаметр, 
  // срезы по бокам (3мм сердцевина)
  translate([0,0,-1])
  difference() {
    cylinder(h=length, r=2.5, $fn=20);
    translate([1.5, -2.5, 0]) 
      cube([2.5, 5, length]);
    translate([-2.5-1.5, -2.5, 0]) 
      cube([2.5, 5, length]);
  }
}
module motor3_axis(length=17) {
  // 1,5мм диаметр
  translate([0,0,-1])
    cylinder(h=length, r=0.75, $fn=20);
}
module motor4_axis(length=17) {
  // 3мм диаметр,
  // срез с одного бока 1мм
  translate([0,0,-1])
  difference() {
    cylinder(h=length, r=1.5, $fn=20);
    translate([0.75, -1.5, 0]) 
      cube([2, 3, length]);
  }
}

/* Колесо */
module wheel() {
  // внешний обод
  difference() {
    cylinder(h=15, r=30, $fn=100);
    translate([0,0,-1])
      cylinder(h=17, r=27, $fn=100);
  }

  // внутренний вал
  cylinder(h=15, r=5, $fn=100);

  // спицы
  for(angle = [0, 120, 240]) {
    rotate(a=angle) 
      cube([29, 3, 10]);
  }

}
