use <../breadboard/breadboard.scad>;


//holder(2, 0);
//holder(4, 3);
//holder(6, 6);
holder1(6, 6);
//holder_aa(4);
//holder_aa(6);
//battery_aa_bed();
//rotate([0, 90, 0]) wire_jam();
//wire_jam();
//wire_jam2();
//wire_jam_with_breadboard();
//contact_gap();


/**
 * Отсек для батареек с контактами и отверстиями для креплений
 * (крепления перпендикулярно батарейкам).
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
 * Отсек для батареек с контактами и отверстиями для креплений
 * (крепления параллельно батарейкам).
 * @param count - количество батареек (четное число)
 * @param holes1 - количество отверстий на рейке между контактами
 */
module holder1(count=4, holes1=3) {
  difference() {
    union() {
      difference() {
        holder_aa(count);
        
        // освободить место для зажимов слева
        translate([1, -10, 1])
          cube([14, 12, 19]);
        // освободить место для зажимов справа
        translate([15*(count-1)+1, -10, 1])
          cube([14, 12, 19]);
      }

      // обычные зажимы
      //translate([1, 2, 12]) 
      //  rotate([0, 90, -90]) wire_jam();
      //translate([15*(count-1)+2-1, 2, 12]) 
      //  rotate([0, 90, -90]) wire_jam();
     
      // зажимы с макетками
      translate([1, 2.1, 0])
        rotate([0, 0, -90]) wire_jam_with_breadboard();

      translate([15*count +1-1, 2.1, 0]) 
        mirror([1, 0, 0]) rotate([0, 0, -90]) 
          wire_jam_with_breadboard();
    }
    // путь до контактов слева
    // скоба
    //translate([9, -2, 5]) cube([1, 5, 14]);
    // винт
    translate([8, 3, 7]) 
      rotate([0, 90, -90]) cylinder(h=4, r=1.6, $fn=100);
    // большое окно
    //translate([6, -3, 13]) cube([4, 6, 4]);
    //translate([6, -2, 3]) cube([4, 5, 15]);

    // путь до контактов справа
    // скоба
    //translate([15*count-9, -2, 5]) cube([1, 5, 14]);
    // винт
    translate([15*(count-1)+8, 3, 7]) 
      rotate([0, 90, -90]) cylinder(h=4, r=1.6, $fn=100);
    // большое окно
    //translate([15*(count-1)+6, -3, 13]) cube([4, 6, 4]);
    //translate([6+15*(count-1), -2, 3]) cube([4, 5, 15]);
  }

  // рейка с отверстиями для крепления
  translate([-10, -5, 0]) plank_with_holes(6);
  // "подклеить" рейку к корпусу (без этого не экспортнется в stl)
  translate([-1, -5, 0]) cube([2, 62, 2]);

  // еще рейка с отверстиями
  translate([15*count, -5, 0]) plank_with_holes(6);
  
  // планка для проверки 
  //translate([-12, 7, -1]) rotate([0,0,-90])  plank_with_holes(14);
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
    if(count > 2) {
      for(i = [1 : count/2-1]) {
        translate([6+15+30*(i-1), 2, 2])
          contact_gap();
      }
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
  // дырка вбок
  translate([1, 0, 0]) cube([2, 3, 2]);
  // дырка вниз
  translate([1, 0, -3]) cube([2, 1, 4]);
  translate([1, 0, -3]) cube([2, 3, 2]);
}

/**
 * Пипка для плюса.
 */
module contact_plate_plus() {
  cube([4, 1, 15]);
  translate([0, 0, 11]) cube([4, 3, 4]);
  // для защелки
  // дырка вбок
  translate([1, 0, 0]) cube([2, 3, 2]);
  // дырка вниз
  translate([1, 0, -3]) cube([2, 1, 4]);
  translate([1, 0, -3]) cube([2, 3, 2]);
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
      // 50мм длина батарейки минус 2мм на выступ под носик
      // плюс 2мм на пружину
      translate([0, 0, 7]) rotate([270, 0, 0]) 
        cylinder(h=50-2+2, r=7, $fn=100);
      translate([-7, 0, 7]) cube([14, 50, 7]);
      translate([-2.5, 49, 0]) cube([5, 3, 14]);
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

  nut_width = 7;

  difference() {
    cube([12, 14, 8]);
    
    // гайка
    translate([0, 3, 0]) union() {
      translate([-3, -nut_width/2+4, -1]) cube([8, nut_width, 5]);
      translate([5, 4, -1]) rotate([0, 0, 90]) linear_extrude(height=5) 
        import(file = "screw-nut-m3.dxf");
    }
    
    // нижняя шайба
    // шайба m4 (9мм, 10мм на печать)
    /*translate([0, 3, 5]) union() {
      translate([5, 4, 0]) cylinder(h=2, r=5, $fn=100);
      //translate([-1, -1, 0]) cube([5, 10, 2]);
    }*/
    // шайба m3 (7мм, 8мм на печать)
    translate([0, 3, 5]) union() {
      translate([5, 4, 0]) cylinder(h=2, r=4, $fn=100);
      //translate([-1, 0, 0]) cube([6, 8, 2]);
    }

    // верхняя шайба
    // шайба m3 (7мм, 8мм на печать)
    translate([0, 3, 6]) union() {
      translate([5, 4, 0]) cylinder(h=3, r=4, $fn=100);
      // срезать "выход" для шайбы
      translate([-1, 0, 0]) cube([6, 8, 3]);
    }
    //шайба m4 (9мм, 10мм на печать)
    /*translate([0, 3, 6]) union() {
      translate([5, 4, 0]) cylinder(h=3, r=5.5, $fn=100);
      translate([-1, -1, 0]) cube([5, 10, 3]);
    }*/

    // винт
    translate([5, 7, -2]) cylinder(h=9, r=1.6, $fn=100);
  }

  // ушки для проводов
  difference() {
    union() {
      translate([-4, 0, 0]) cube([5, 3, 8]);
      translate([-4, 11, 0]) cube([5, 3, 8]);
    }
    //translate([-2, -1, -1]) cube([2, 16, 8]);
  }
}

/**
 * Зажим для проводов.
 */
module wire_jam2() {
  // высота гайки m3 6мм, ширина 7мм, толщина 2мм,
  // диаметр отверстия - 3мм
  // головка винта:
  // потайная (на скос) - 2мм
  // обычная крестовая - 2мм

  //nut_width = 7;
  nut_width = 6;

  difference() {
    cube([12, 14, 8]);
    
    // гайка
    translate([0, 3, 0]) union() {
      translate([-3, -nut_width/2+4, -1]) cube([8, nut_width, 5]);
      translate([5, 4, -1]) /*rotate([0, 0, 90])*/ linear_extrude(height=5) 
        import(file = "screw-nut-m3.dxf");
      
      // 
      translate([-1, 0, 3]) cube([10, 8, 1]);
    }
    
    // внутренняя площадка для контакта
    translate([0, 3, 5]) union() {
      translate([5, 4, 0]) rotate([0, 0, 270]) linear_extrude(height=2) 
        import(file = "wire-plate1.dxf");
      //translate([5-9/2, 4-8/2, 0]) cube([9, 8, 2]);
      // срезать "выход" для шайбы
      //translate([-1, 0, 0]) cube([6, 8, 2]);
    }

    // внешняя площадка для контакта
    translate([0, 3, 6]) union() {
      translate([5, 4, 0]) rotate([0, 0, 270]) linear_extrude(height=3) 
        import(file = "wire-plate1.dxf");

      // срезать "выход"
      translate([-1, 0, 0]) cube([6, 8, 3]);

      //translate([5, 4, 0]) cylinder(h=3, r=4, $fn=100);
      //translate([5-9/2, 4-8/2, 0]) cube([9, 8, 3]);
    }

    // винт
    translate([5, 7, -2]) cylinder(h=9, r=1.6, $fn=100);
  }

  // ушки для проводов
  difference() {
    union() {
      translate([-4, 0, 0]) cube([5, 3, 8]);
      translate([-4, 11, 0]) cube([5, 3, 8]);
    }
    //translate([-2, -1, -1]) cube([2, 16, 8]);
  }
}

/**
 * Зажим для проводов с блоком макетной платы.
 */
module wire_jam_with_breadboard() {
  difference() {
    union() {
      translate([0, 0, 12]) rotate([0, 90, 0]) wire_jam2();
      translate([2, 13, 1]) breadboard_half(lines=2);
  
      // стенки по бокам потолще
      translate([0, 13, 0]) cube([1, 17, 8]);
      translate([8, 13, 0]) cube([1, 17, 8]);
    }
    
    // путь до контактов макетки
    translate([2.5, 10, -1]) cube([1.5, 5, 18]);
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
      translate([5, 2-3+(6+4)*hole-2, -1]) 
        cylinder(h=4, r=2, $fn=100);
    }   
  }
}

