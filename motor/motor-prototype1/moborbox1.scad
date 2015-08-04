print_error = 0.2;


magnet_width = 10;
magnet_height = 10;
magnet_thickness = 1;

box(print_error=print_error);
//lid(print_error=print_error);
//collector(print_error=print_error);
//brush_box();

module box(core_radius=7, rod_radius=1, print_error=0) {
  difference() {
    union() {
      difference() {
        union() {
          // главный обод - стенка толщиной 3мм
          cylinder(r=core_radius+3, h=10, $fn=100);

          // выступающий обод, чтобы одеть крышку
          translate([0,0,-5]) cylinder(r=core_radius+2, h=21+4, $fn=100);
        }
        // вычесть внутренний цилиндр под сердечник мотора
        translate([0,0,-3]) cylinder(r=core_radius+print_error, h=24, $fn=100);
        // дырка под вал мотора в нижней стенке
        translate([0,0,-6]) cylinder(r=rod_radius+print_error, h=4, $fn=100);
      }

      // блок для магнита 1
      /*translate([-6,8,0]) difference() {
       cube([12, 8, 10]);
       translate([2, 2, 2]) cube([12-4, 8-2+1, 10-4]);
      }*/
      // блок для магнита 2
      /*mirror([0, -1, 0]) translate([-6,8,0]) difference() {
       cube([12, 8, 10]);
       translate([2, 2, 2]) cube([12-4, 8-2+1, 10-4]);
      } */

      // ребилд из старых моторов 
      /*translate([-8,7.3,0]) difference() {
       cube([16, 7, 10]);
       translate([1, 1, 1]) cube([14, 5, 10]);
      }*/
      // ребилд из старых моторов 
      /*mirror([0, -1, 0]) translate([-8,7.3,0]) difference() {
       cube([16, 7, 10]);
       translate([1, 1, 1]) cube([14, 5, 10]);
      }*/

      // магниты параллелепипеды 10x10x1
      // магнит 1
      translate([-6, 8.9, -1]) difference() {
       cube([12, 6, 12]);
       
       // магнит
       translate([1-print_error, 1+print_error, 1]) 
         cube([10+print_error*2, 3+print_error*2, 12]);

       // небольшой паз для крышки
       translate([1-print_error, 0, 11]) 
         cube([10+print_error*2, 2, 3]);
      }
 
      // магнит 2
      mirror([0, -1, 0]) 
         translate([-6, 8.9, -1]) difference() {
       cube([12, 6, 12]);
       
       // магнит
       translate([1-print_error, 1+print_error, 1]) 
         cube([10+print_error*2, 3+print_error*2, 12]);

       // небольшой паз для крышки
       translate([1-print_error, 0, 11]) 
         cube([10+print_error*2, 2, 3]);
      }
      
    }

    // окошки для магнитов
    translate([-4, -11, 1]) cube([8, 22, 8]);


    // место блока для щеток и контактных скоб
    translate([5, -5-print_error, 21-5]) cube([5, 10+print_error*2, 5]);
    mirror([-1, 0, 0]) translate([5, -5-print_error, 21-5]) cube([5, 10+print_error*2, 5]);
  }
}

/**
 * Крышка с щетками.
 */
module lid(core_radius=7, rod_radius=1, print_error=0) {
  difference() {
    union() {
      // главный цилиндр
      cylinder(r=10, h=12, $fn=100);

      // закрывашки для магнитов
      translate([-(magnet_width-print_error*2)/2, -23/2, 10]) 
        cube([magnet_width-print_error*2, 23, 2]);
    }

    // крышка одевается на выступающий обод (нижняя стенка 2мм)
    translate([0, 0, 2]) 
      cylinder(r=core_radius+2+0.1+print_error, h=12, $fn=100);

    // отверстие под вал мотора
    translate([0, 0, -1]) 
      cylinder(r=rod_radius+print_error, h=4, $fn=100);
 
    // освободить место для щеток и скоб
    translate([4, -5, 2]) cube([6, 10, 12]);
    mirror([-1, 0, 0]) 
      translate([4, -5, 2]) cube([6, 10, 12]);
  }


  // блок для щеток и контактных скоб
  translate([4, 0, 0]) brush_box();
  mirror([-1, 0, 0]) 
    translate([4, 0, 0]) brush_box();
}

/**
 * Блок для крепления щеток.
 */
module brush_box() {
  difference() {
    // блок для щеток и контактных скоб
    translate([0, -5, 0]) cube([6, 10, 6]);

    translate([-0.2, 2, 1]) brush_path();
    mirror([0, -1, 0]) 
      translate([-0.2, 2, 1]) brush_path();
  }
}

/**
 * Путь для щетки.
 */
module brush_path(height=10) {
  rotate([0, 0, -10]) cube([5.5, 0.5, height]);
  translate([5, -0.5, 0]) cube([0.5, 3, height]);
  translate([5, 2, 0]) cube([3, 0.5, height]);
}

/**
 * Коллектор.
 */
module collector(print_error=0) {
  difference() {
    union() {
      cylinder(r=2, h=9, $fn=100);

      translate([0, 0, 4]) cylinder(r=3, h=5, $fn=100);
      translate([0, 0, 2]) cylinder(r=4, h=3, $fn=100);

    }

    translate([0, 0, -1]) cylinder(r=1+print_error, h=11, $fn=100);

    for(a=[0, 120, 240]) {
      rotate([0, 0, a]) translate([-1.5, 2, 4]) cube([3, 5, 6]);
    }
  }
}
