
holder();
//holder_aa();
//battery_aa_bed();
//rotate([0, 90, 0]) wire_jam();
//contact_gap();


module holder() {
  difference() {
    union() {
      holder_aa();
      translate([0, 1, 12]) rotate([0, 90, -90]) wire_jam();
      translate([47, 1, 12]) rotate([0, 90, -90]) wire_jam();
    }
    translate([9, -3, 5]) cube([1, 6, 14]);
    translate([51, -3, 5]) cube([1, 6, 14]);
  }
}

module holder_aa() {
  difference() {
    cube([61, 60, 14+2]);
    
    // сверху
    translate([-1, 2, 2+12]) 
      cube([63, 56, 4]);
    
    // ложа под батарейки
    translate([8, 4, 2]) battery_aa_bed();
    translate([8+15, 52+4, 2]) rotate([0,0,180]) battery_aa_bed();
    translate([8+15+15, 4, 2]) battery_aa_bed();
    translate([8+15+15+15, 52+4, 2]) rotate([0,0,180]) battery_aa_bed();
    
    // ячейки для контактов 
    translate([6+15, 2, 2])
      contact_gap();
    translate([6, 58, 2]) 
      mirror([0, 1, 0]) contact_gap();
    translate([6+30, 58, 2]) 
      mirror([0, 1, 0]) contact_gap();

    // одинокая пружинка
    translate([6, 2, 2])
      union() {
        cube([4, 1, 15]);
        translate([0, 0, 11]) cube([4, 3, 4]);
      };

    // одинокая пипка
    translate([6+45, 2, 2])
      union() {
        cube([4, 1, 15]);
        translate([0, 0, 11]) cube([4, 3, 4]);
      };
  }
}

module contact_gap() {
  // внутри стенки
  cube([19, 1, 15]);
  // для пипки
  translate([0, 0, 11]) cube([4, 3, 4]);
  // для пружинки
  translate([15, 0, 11]) cube([4, 3, 4]);
}

/**
 * Батарейка AA цилиндр 50x14мм плюс 2 мм в длину.
 */
module battery_aa_bed() {
  // 50мм длина батарейки минус 1мм на выступ под носик
  // плюс 2мм на пружину
  translate([0, 0, 7]) rotate([270, 0, 0]) cylinder(h=50-1+2, r=7, $fn=100);
  translate([-7, 0, 7]) cube([14, 51, 7]);
  translate([-2.5, 50, 0]) cube([5, 2, 14]);
}

/**
 * Зажим для проводов.
 */
module wire_jam() {
  // высота гайки m3 6мм, ширина 7мм, толщина 2мм,
  // диаметр отверстия - 3мм
  // головка винта:
  // потайная (на скос) - 2мм
  // обычная крестовая - 2мм

  difference() {
    cube([12, 14, 9]);
    
    // гайка
    translate([0, 4, 2]) union() {
      translate([-2, 0, 0]) cube([8, 6, 3]);
      translate([2, 0, 0]) linear_extrude(height=3) 
        import(file = "гайка-m3.dxf");
    }
    
    // нижняя шайба
    // шайба m4 (9мм, 10мм на печать)
    /*translate([0, 3, 6]) union() {
      //translate([-1, -1, 0]) cube([5, 10, 2]);
      translate([5, 4, 0]) cylinder(h=2, r=5, $fn=100);
    }*/
    // шайба m3 (7мм, 8мм на печать)
    translate([0, 3, 6]) union() {
      translate([-1, 0, 0]) cube([6, 8, 2]);
      translate([5, 4, 0]) cylinder(h=2, r=4, $fn=100);
    }

    // верхняя шайба
    // шайба m3 (7мм, 8мм на печать)
    translate([0, 3, 7]) union() {
      translate([-1, 0, 0]) cube([6, 8, 3]);
      translate([5, 4, 0]) cylinder(h=3, r=4, $fn=100);
    }
    //шайба m4 (9мм, 10мм на печать)
    /*translate([0, 3, 7]) union() {
      translate([-1, -1, 0]) cube([5, 10, 3]);
      translate([5, 4, 0]) cylinder(h=3, r=5.5, $fn=100);
    }*/

    // винт
    translate([5, 7, -1]) cylinder(h=9, r=1.6, $fn=100);
  }
}

