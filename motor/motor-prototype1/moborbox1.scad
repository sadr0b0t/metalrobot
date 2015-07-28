print_error = 0.2;

//box(print_error=print_error);
lid(print_error=print_error);

module box(core_radius=7, rod_radius=1, print_error=0) {
  difference() {
    union() {
      difference() {
        union() {
          // главный обод - стенка толщиной 3мм
          cylinder(r=core_radius+3, h=10, $fn=100);

          // выступающий обод, чтобы одеть крышку
          translate([0,0,-5]) cylinder(r=core_radius+2, h=20, $fn=100);
        }
        // вычесть внутренний цилиндр под сердечник мотора
        translate([0,0,-3]) cylinder(r=core_radius+print_error, h=19, $fn=100);
        // дырка под вал мотора в нижней стенке
        translate([0,0,-6]) cylinder(r=rod_radius+print_error, h=4, $fn=100);
      }

      translate([-6,8,0]) difference() {
       cube([12, 8, 10]);
       translate([2, 2, 2]) cube([12-4, 8-2+1, 10-4]);
      }


      mirror([0, -1, 0]) translate([-6,8,0]) difference() {
       cube([12, 8, 10]);
       translate([2, 2, 2]) cube([12-4, 8-2+1, 10-4]);
      }
    }

    translate([-6,6,0])
     translate([2, 2, 2]) cube([12-4, 8-2+1, 10-4]);

    mirror([0, -1, 0]) translate([-6,6,0])
      translate([2, 2, 2]) cube([12-4, 8-2+1, 10-4]);

    translate([-2, -11, 2]) cube([4, 22, 6]);
  }
}

/**
 * Крышка с щетками.
 */
module lid(core_radius=7, rod_radius=1, print_error=0) {
  difference() {
    cylinder(r=10, h=12, $fn=100);

    // одевается на выступающий обод
    translate([0, 0, 2]) 
      cylinder(r=core_radius+2/*+print_error*/, h=12, $fn=100);

    // отверстие под вал мотора
    translate([0, 0, -1]) 
      cylinder(r=rod_radius+print_error, h=4, $fn=100);
  }
}



