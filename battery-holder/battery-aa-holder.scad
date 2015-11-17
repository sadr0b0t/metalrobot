use <../breadboard/breadboard.scad>;

// выставить в настройках Edit>Preferences>Advanced: 
// Turn off rendering at=10000 (2000 не хватает)

//print_error = 0;
print_error = 0.2;
//print_error = 0.4;
//print_error = 0.6;

//holder(2, 2, print_error);
holder(4, 4, print_error);
//holder(6, 6, print_error);
//holder_aa(2, print_error);
//holder_aa(4, print_error);
//holder_aa(6, print_error);
//battery_aa_bed();
//rotate([0, 90, 0]) wire_jam();
//wire_jam(print_error=print_error);
//wire_jam_with_breadboard(print_error=print_error);
//contact_gap(print_error=print_error);
//contact_plate_plus();


/**
 * Отсек для батареек с контактами и отверстиями для креплений
 * (крепления параллельно батарейкам).
 * @param count - количество батареек (четное число)
 * @param holes1 - количество отверстий на рейке между контактами
 */
module holder(count=6, holes1=3, print_error=0) {
  // 7*2мм - батарейка + 1мм - на боковые стенки по 1/2мм
  bed_width = 15;
    
  difference() {
    union() {
      difference() {
        // собственно, батарейки
        holder_aa(count=count, print_error=print_error);
        
        // освободить место для контактных зажимов слева
        translate([5.5, -3, 1]) cube([6, 3+2, 19]);
        // дополнительно под макетку
        translate([15, -11.5, -0.1]) cube([16, 12, 20+0.1]);

        // освободить место для контактных зажимов справа
        translate([bed_width*(count-1)+5.5, -10, 1]) cube([6, 12, 19]);
        // дополнительно под макетку
        translate([bed_width*(count-1)-14, -11.5, -0.1]) cube([16, 12, 20+0.1]);
      }

      // обычные контактные зажимы без макеток
      //translate([1, 2, 12]) rotate([0, 90, -90]) 
      //  wire_jam();
      //translate([bed_width*(count-1)+2-1, 2, 12]) rotate([0, 90, -90]) 
      //  wire_jam();
     
      // контактные зажимы с макетками
      // слева
      // (0.01: немного утопим в отсеке, чтобы экспортнулось в stl)
      translate([2, 2+0.01, 0]) rotate([0, 0, -90]) 
        wire_jam_with_breadboard(print_error=print_error);

      // справа
      translate([bed_width*count, 2+0.01, 0]) mirror([1, 0, 0]) rotate([0, 0, -90]) 
        wire_jam_with_breadboard(print_error=print_error);
    }
    
    // логотип и ссылки на нижней стороне
    translate([2, 15, -1])
      linear_extrude(height=2) import(file="credits-43d.dxf");
  }

  // рейка с отверстиями для крепления
  translate([-10+0.5, -2, 0]) 
    plank_with_holes(holes=6, corner_radius=[2,0,2,0], print_error=print_error);
  // дотянуться до блока контактного зажима
  translate([0, -2, 0]) cube([2, 3, 2]);

  // еще рейка с отверстиями
  translate([bed_width*count+0.5, -2, 0]) 
    plank_with_holes(holes=6, corner_radius=[0,2,0,2], print_error=print_error);
  // дотянуться до блока контактного зажима
  translate([bed_width*count-1, -2, 0]) cube([2, 3, 2]);
  
  // планка для проверки 
  //translate([-12, 7, -1]) rotate([0,0,-90])  plank_with_holes(14);
}

/**
 * Основа отсека для батареек AA.
 * @param count - количество батареек (четное число)
 */
module holder_aa(count=4, print_error=0) {
  // 7*2мм - батарейка + 1мм - на боковые стенки по 1/2мм
  bed_width = 15;
    
  difference() {
    // толщина боковых стенок и стенок между батарейками
    // 1/2 мм без учета погрешности
    cube([bed_width*count+2, 60, 14+2]);
    
    // срезать сверху
    translate([-1, 2, 2+12]) cube([bed_width*count+4, 56, 4]);
      
    
    // ложа под батарейки
    for(i = [1 : count/2]) {
      translate([1+bed_width/2+bed_width*(i*2-2), 4, 2]) 
        battery_aa_bed(print_error=print_error);
      translate([1+bed_width/2+bed_width*(i*2-1), 52+4, 2]) 
        rotate([0,0,180]) battery_aa_bed(print_error=print_error);
    }
    
    // срезать сверху внутренние стенки между батарейками
    translate([2, 6, 2+5]) cube([bed_width*count-3, 48, 20]);

    // выемки по бокам
    translate([-3, 30, 20]) rotate([0, 90, 0]) 
      cylinder(h=15*(count+1), r=15, $fn=100);

    // ячейки для контактов 
    // внизу
    if(count > 2) {
      for(i = [1 : count/2-1]) {
        translate([6.5+15+30*(i-1), 2, -1])
          contact_gap(print_error=print_error);
      }
    }

    // наверху
    for(i = [1 : count/2]) {
      translate([6.5+30*(i-1), 58, -1]) 
        mirror([0, 1, 0]) contact_gap(print_error=print_error);
    }

    // одинокая пружинка
    translate([6.5, 2, -1])
      contact_plate_minus(print_error=print_error);

    // одинокая пипка
    translate([6.5+15*(count-1), 2, -1])
      contact_plate_plus(print_error=print_error);
  }
}


/**
 * Батарейка AA цилиндр 50x14мм плюс 2 мм в длину.
 */
module battery_aa_bed(print_error=0) {
  // длина выступающего носика на плюсе
  noze_length = 2;
  // 51мм длина батарейки минус 2мм на выступ под носик
  // плюс 1мм на пружину
  body_length = 51-noze_length+1;
  
  difference() {
    union() {
      translate([0, 0, 7]) rotate([270, 0, 0]) 
        cylinder(h=body_length, r=7+print_error, $fn=100);
  
      // вход сверху
      translate([-7-print_error, 0, 7]) cube([14+print_error*2, 50, 7]);
      
      // выемка под носик 2мм (0.1мм для связности модели)
      translate([-2.5, body_length-0.1, 0]) cube([5, noze_length+0.1, 14]);
    }

    // "пружинистый" выступ на минусе
    translate([-2, -5.5, 6]) rotate([0, 90, 0]) 
      cylinder(h=4, r=7, $fn=100);

    // "пружинистый" выступ на плюсе
    translate([-2, 58.5, 6]) rotate([0, 90, 0]) 
      cylinder(h=4, r=7, $fn=100);
  }
  
  // метка минус
  translate([-2, 6, -3]) cube([4, 2, 6]);

  // метка плюс
  translate([-2, 44, -3]) cube([4, 2, 6]);
  translate([-1, 43, -3]) cube([2, 4, 6]);
}

/**
 * Пружинка для минуса.
 */
module contact_plate_minus(print_error=0) {
  // в толще стенки
  translate([-print_error, 0, 0]) cube([4+print_error*2, 1, 15]);
    
  // щелка сверху
  translate([-print_error, 0, 14]) cube([4+print_error*2, 3, 4]);
    
  // расчистить путь для канавки под гайкой +
  // дополнительная выемка снизу, чтобы щель не заплывала
  // при печати
  translate([-print_error, -3, 0]) cube([4+print_error*2, 5, 2]);
}

/**
 * Пипка для плюса.
 */
module contact_plate_plus(print_error=0) {
  // в толще стенки
  translate([-print_error, 0, 0]) cube([4+print_error*2, 1, 15]);
    
  // щелка сверху
  translate([-print_error, 0, 14]) cube([4+print_error*2, 3, 4]);
    
  // расчистить путь для канавки под гайкой +
  // дополнительная выемка снизу, чтобы щель не заплывала
  // при печати
  translate([-print_error, -3, 0]) cube([4+print_error*2, 5, 2]);
}

/**
 * Щель для контактов в стенке отсека.
 */
module contact_gap(print_error=0) {
  // внутри стенки
  translate([-print_error, 0, 0]) cube([19+print_error*2, 1, 14]);

  // для пружинки (минус)
  translate([-print_error, 0, 13.9]) cube([4+print_error*2, 3, 4]);

  // для пипки (плюс)
  translate([15-print_error, 0, 13.9]) cube([4+print_error*2, 3, 4]);
    
  // дополнительная выемка снизу, чтобы щель не заплывала
  // при печати
  translate([-1-print_error, -1, 0]) cube([19+2, 3, 2]); 
}

/**
 * Зажим для проводов.
 */
module wire_jam(print_error=0) {
  // высота гайки m3 6мм, ширина 7мм, толщина 2мм,
  // диаметр отверстия - 3мм
  // головка винта:
  // потайная (на скос) - 2мм
  // обычная крестовая - 2мм

  //nut_width = 7;
  nut_width = 6;
  // сдвиг гайки по оси y внутри конструкции
  nut_shift_y = 3;

  difference() {
    translate([1, 0, 0]) union() cube([11, 13, 6]);
    
    // гайка
    translate([0, 3.5, 0]) union() {
      // путь к гайке
      translate([0, nut_shift_y-nut_width/2, -1]) cube([5, nut_width, 4]);
      // гайка
      translate([5, nut_shift_y, -1]) /*rotate([0, 0, 90])*/ linear_extrude(height=4) 
        import(file = "screw-nut-m3.dxf");
      
      // еще щелка над гайкой
      translate([0, nut_shift_y-8/2, 2]) cube([13, 8, 1]);
        
      // канавка за гайкой
      translate([11, nut_shift_y-(4+print_error*2)/2, -1]) cube([2, 4+print_error*2, 4]);
    }
    
    // площадка для контакта
    translate([0, nut_shift_y-0.5, 4]) union() {
      translate([5, 4, 0]) rotate([0, 0, 270]) linear_extrude(height=3) 
        import(file = "wire-plate1-43d.dxf");
    }

    // винт
    translate([5, nut_shift_y+3.5, -2]) cylinder(h=9, r=1.6, $fn=100);
  }
}

/**
 * Зажим для проводов с блоком макетной платы.
 */
module wire_jam_with_breadboard(print_error=0) {
  difference() {
    union() {
      translate([0, 0, 12]) rotate([0, 90, 0]) 
        wire_jam(print_error=print_error);

      // 6.5 мм от центра винта до левого края макетки
      // дырки в макетке будут гулять вместе с print_error
      translate([1+print_error, 12, 0]) breadboard_half(lines=1, height=10, print_error=print_error);
  
      // стенка спереди потолще
      translate([4.5, 13, 0]) cube([1.5, 16, 8]);
    }
    
    // путь до контактов макетки
    translate([2, 10, -0.1]) cube([1, 5, 9+0.1]);
  }
}

/** 
 * Рейка с отверстиями.
 * @param holes - количество отверстий
 * @param corner_radius - радиусы скругления углов:
 *   corner_radius[0] - левый нижний угол
 *   corner_radius[1] - правый нижний угол
 *   corner_radius[2] - левый верхний угол
 *   corner_radius[3] - правый нижний угол
 * @param print_error - погрешность печати 3д-принтера
 */
module plank_with_holes(holes=1, corner_radius=[2,2,2,2], print_error=0) {
  // отверстие=4мм
  // расстояние между отверстиями=6мм
  // расстояние от отверстия до края=3мм
  // толщина=2мм

  x_len = 3+4+3;
  y_len = 3+(6+4)*holes-3;

  corner_left_max = corner_radius[0]>corner_radius[2] ? corner_radius[0]:corner_radius[2];
  corner_right_max = corner_radius[1]>corner_radius[3] ? corner_radius[1]:corner_radius[3];
  corner_down_max = corner_radius[0]>corner_radius[1] ? corner_radius[0]:corner_radius[1];
  corner_up_max = corner_radius[2]>corner_radius[3] ? corner_radius[2]:corner_radius[3];

  difference() {
    // в длину по Y
    union() {
      // оставим место для скругленных углов
      translate([corner_left_max, corner_down_max, 0])
        cube([x_len-corner_left_max-corner_right_max, 
              y_len-corner_down_max-corner_up_max, 2]);

      // скруглим углы
      // левый нижний
      translate([corner_radius[0], corner_radius[0], 0])
        cylinder(h=2, r=corner_radius[0], $fn=100);
      // правый нижний
      translate([x_len-corner_radius[1], corner_radius[1], 0])
        cylinder(h=2, r=corner_radius[1], $fn=100);
      // левый верхний
      translate([corner_radius[2], y_len-corner_radius[2], 0])
        cylinder(h=2, r=corner_radius[2], $fn=100);
      // правый верхний
      translate([x_len-corner_radius[3], y_len-corner_radius[3], 0])
        cylinder(h=2, r=corner_radius[3], $fn=100);

      // добьем рейками по периметру
      // слева
      translate([0, corner_radius[0], 0])
        cube([corner_left_max, y_len-corner_radius[0]-corner_radius[2], 2]);
      // справа
      translate([x_len-corner_right_max, corner_radius[1], 0])
        cube([corner_right_max, y_len-corner_radius[1]-corner_radius[3], 2]);
      // снизу
      translate([corner_radius[0], 0, 0])
        cube([x_len-corner_radius[0]-corner_radius[1], corner_down_max, 2]);
      // сверху
      translate([corner_radius[2], y_len-corner_up_max, 0])
        cube([x_len-corner_radius[2]-corner_radius[3], corner_up_max, 2]);
    }

    // дырки по Y
    for(hole=[1 : holes]) {
      // -2 - сдвинуть центр цилиндра
      // -3=6/2 - половина расстояния между отверстиями
      translate([5, (6+4)*hole-3-2, -1]) 
        cylinder(h=4, r=2+print_error, $fn=100);
    }   
  }
}
