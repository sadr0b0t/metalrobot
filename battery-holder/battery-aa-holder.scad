
//holder(2, 0);
//holder(4, 3);
//holder(6, 6);
holder_aa(4);
//holder_aa(6);
//battery_aa_bed();
//rotate([0, 90, 0]) wire_jam();
//wire_jam();
//contact_gap();


/**
 * Отсек для батареек с контактами и отверстиями для креплений.
 * @param count - количество батареек (четное число)
 * @param holes1 - количество отверстий на рейке между контактами
 */
module holder(count=4, holes1=3) {
  difference() {
    union() {
      holder_aa(count);
      translate([0, 1, 12]) rotate([0, 90, -90]) wire_jam();
      translate([15*(count-1)+2, 1, 12]) rotate([0, 90, -90]) wire_jam();
    }
    translate([9, -3, 5]) cube([1, 6, 14]);
    translate([15*count-9, -3, 5]) cube([1, 6, 14]);
  }

  // рейка с отверстиями для крепления
  translate([14.5, 0, 0]) rotate([0,0,-90]) plank_with_holes(holes1);
  // "подклеить" рейку к корпусу (без этого не экспортнется в stl)
  translate([14.5, -1, 0]) cube([15*(count-2)+2, 2, 2]);

  translate([13, -10, 0]) cube([2, 11, 2]);
  translate([15*count-14, -10, 0]) cube([2, 11, 2]);

  // еще рейка с отверстиями
  translate([4.5, 70, 0]) rotate([0,0,-90]) plank_with_holes(holes1+2);
  // "подклеить" рейку к корпусу (без этого не экспортнется в stl)
  translate([4.5, 59, 0]) cube([15*count-8, 2, 2]);

  // скругленные уголки слева
  translate([3, 67, 0]) cylinder(h=2, r=3, $fn=100);
  translate([0, 56, 0]) cube([6, 11, 2]);
  translate([3, 59, 0]) cube([4, 11, 2]);

  // справа
  translate([15*count-2, 67, 0]) cylinder(h=2, r=3, $fn=100);
  translate([15*count-5, 56, 0]) cube([6, 11, 2]);
  translate([15*count-6, 59, 0]) cube([4, 11, 2]);
  
  
  // планка для проверки 
  //translate([16.5, -12, 1]) plank_with_holes(10);
}

/**
 * Отсек для батареек.
 * @param count - количество батареек (четное число)
 */
module holder_aa(count=4) {
  difference() {
    cube([15*count+1, 60, 14+2]);
    
    // сверху
    translate([-1, 2, 2+12]) 
      cube([15*count+3, 56, 4]);
    
    // ложа под батарейки
    for(i = [1 : count/2]) {
      translate([8+15*(i*2-2), 4, 2]) 
        battery_aa_bed();
      translate([8+15*(i*2-1), 52+4, 2]) 
        rotate([0,0,180]) battery_aa_bed();
    }

    // ячейки для контактов 
    // внизу
    for(i = [1 : count/2-1]) {
      translate([6+15+30*(i-1), 2, 2])
        contact_gap();
    }

    // наверху
    for(i = [1 : count/2]) {
      translate([6+30*(i-1), 58, 2]) 
        mirror([0, 1, 0]) contact_gap();
    }

    // одинокая пружинка
    translate([6, 2, 2])
      contact_plate_plus();

    // одинокая пипка
    translate([6+15*(count-1), 2, 2])
      contact_plate_minus();
  }
}

/**
 * Пружинка для минуса.
 */
module contact_plate_minus() {
  cube([4, 1, 15]);
  translate([0, 0, 11]) cube([4, 3, 4]);
  // для защелки
  translate([1, 0, 0]) cube([2, 3, 2]);
}

/**
 * Пипка для плюса.
 */
module contact_plate_plus() {
  cube([4, 1, 15]);
  translate([0, 0, 11]) cube([4, 3, 4]);
  // для защелки
  translate([1, 0, 0]) cube([2, 3, 2]);
}

/**
 * Щеля для контактов в стенке отсека.
 */
module contact_gap() {
  // внутри стенки
  cube([19, 1, 15]);

  // для пипки
  contact_plate_plus();

  // для пружинки
  translate([15, 0, 0]) contact_plate_minus();
}

/**
 * Батарейка AA цилиндр 50x14мм плюс 2 мм в длину.
 */
module battery_aa_bed() {
  difference() {
    union() {
      // 50мм длина батарейки минус 1мм на выступ под носик
      // плюс 2мм на пружину
      translate([0, 0, 7]) rotate([270, 0, 0]) 
        cylinder(h=50-1+2, r=7, $fn=100);
      translate([-7, 0, 7]) cube([14, 51, 7]);
      translate([-2.5, 50, 0]) cube([5, 2, 14]);
    }
  }
  
  // минус
  translate([-2, 6, -3]) cube([4, 2, 6]);

  // плюс
  translate([-2, 44, -3]) cube([4, 2, 6]);
  translate([-1, 43, -3]) cube([2, 4, 6]);
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
        import(file = "screw-nut-m3.dxf");
    }
    
    // нижняя шайба
    // шайба m4 (9мм, 10мм на печать)
    /*translate([0, 3, 6]) union() {
      translate([5, 4, 0]) cylinder(h=2, r=5, $fn=100);
      //translate([-1, -1, 0]) cube([5, 10, 2]);
    }*/
    // шайба m3 (7мм, 8мм на печать)
    translate([0, 3, 6]) union() {
      translate([5, 4, 0]) cylinder(h=2, r=4, $fn=100);
      // срезать "выход" для шайбы
      //translate([-1, 0, 0]) cube([6, 8, 2]);
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

  // ушки для проводов
  difference() {
    union() {
      translate([-4, 0, 0]) cube([5, 3, 9]);
      translate([-4, 11, 0]) cube([5, 3, 9]);
    }
    translate([-2, -1, 0]) cube([2, 16, 7]);
  }
}

/** 
 * Рейка с отверстиями.
 */
module plank_with_holes(holes=1) {
  // отверстие=4мм
  // расстояние между отверстиями=6мм
  // расстояние от отверстия до края=3мм
  // толщина=2мм

  difference() {
    // в длину по Y
    cube([3+4+3, 2+(6+4)*holes, 2]);

    // дырки по Z
    translate([5, 3, 2+3+2]) 
      rotate ([90, 0, 0]) cylinder(h=4, r=2, $fn=100);

    // дырки по Y
    for(hole=[1 : holes]) {
      translate([5, 2-3+(6+4)*hole-2, -1]) cylinder(h=4, r=2, $fn=100);
    }   
  }
}

