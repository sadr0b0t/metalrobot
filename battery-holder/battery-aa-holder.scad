use <../breadboard/breadboard.scad>;

// выставить в настройках Edit>Preferences>Advanced: 
// Turn off rendering at=10000 (2000 не хватает)

//print_error = 0;
//print_error = 0.1;
print_error = 0.2;
//print_error = 0.4;
//print_error = 0.6;

// батарейки AA
//holder(count=2, holes=6, print_error=print_error);
//holder(count=4, holes=6, print_error=print_error);
//holder(count=6, holes=6, print_error=print_error);

holder(count=4, holes=6, spring_length=5, print_error=print_error);

// 
//holder(count=4, holes=6, body_width=14, body_length=49, noze_length=1.5, spring_length=4, print_error=print_error);
//holder(count=6, holes=6, body_width=14, body_length=49, noze_length=1.5, spring_length=4, print_error=print_error);

// отладка
//holder_aa(count=2, print_error=print_error);
//holder_aa(count=4, print_error=print_error);
//holder_aa(count=6, print_error=print_error);


//holder_aa(count=2, spring_length=6, print_error=print_error);

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
 * @param holes - количество отверстий на рейке
 * @param body_width - 7*2мм - батарейка AA
 * @param body_length - длина батарейки без носика (взять максимум)
 * @param noze_length - длина выступающего носика на плюсе (взять минимум)
 * @param spring_length - длина пружинки
 */
module holder(count=6, holes=6, 
        body_width=14, body_length=49, noze_length=1.5, spring_length=4, 
        print_error=0) {
  // 7*2мм - батарейка + 1мм - на боковые стенки по 1/2мм
  bed_width = body_width+1;
    
  difference() {
    union() {
      difference() {
        // собственно, батарейки
        holder_aa(count=count,
          body_width=body_width, body_length=body_length, 
          noze_length=noze_length, spring_length=spring_length, 
          print_error=print_error);
        
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
    //translate([2, 15, -1])
    //  linear_extrude(height=2) import(file="credits-43d.dxf");
  }

  // рейка с отверстиями для крепления
  // 1) прижмем конец к задней стенке, чтобы при креплении отсека
  // на большое полотно с отверстиями оставалась возможность
  // разместить другие элементы впритык к отсеку на следующем ряду;
  // стенка с макеточной частью все равно будет выпирать со своей
  // стороны поэтому стыковаться вплотную к ней не так важно
  // 2) для отсека 4АА левую рейку нужно сдвинуть по X на (-10+1), 
  // а правую на (bed_width*count+1), тогда отверстия на обеих рейках
  // будут равно отстоять от стенок отсека
  translate([-10+1, 2.5, 0]) 
    plank_with_holes(holes=holes, corner_radius=[2,0,2,0], print_error=print_error);
  // дотянуться до блока контактного зажима
  //translate([0, -2, 0]) cube([2, 3, 2]);

  // еще рейка с отверстиями
  translate([bed_width*count+1, 2.5, 0]) 
    plank_with_holes(holes=holes, corner_radius=[0,2,0,2], print_error=print_error);
  // дотянуться до блока контактного зажима
  //translate([bed_width*count-1, -2, 0]) cube([2, 3, 2]);
  
  // планка для проверки совпадения дырок на обоих конца отсека
  //translate([-10+1, 12.5, -1]) rotate([0,0,-90])  plank_with_holes(holes=14, print_error=print_error);
}

/**
 * Основа отсека для батареек AA.
 * 
 * @param count - количество батареек (четное число)
 * @param body_width - 7*2мм - батарейка AA
 * @param body_length - длина батарейки без носика (взять максимум)
 * @param noze_length - длина выступающего носика на плюсе (взять минимум)
 * @param spring_length - длина пружинки
 */
module holder_aa(count=4,
        body_width=14, body_length=49, noze_length=1.5, spring_length=4,
        print_error=0) {
  // 7*2мм - батарейка + 1мм - на боковые стенки по 1/2мм
  bed_width = body_width+1;
    
  // полная длина ложа: пружинка плюс длина батарейки плюс носик 
  bed_length = body_length+noze_length+spring_length;
    
  difference() {
    // толщина боковых стенок и стенок между батарейками
    // 1/2 мм без учета погрешности
    cube([bed_width*count+2, bed_length+7, body_width+2]);
    
    // срезать сверху
    translate([-1, 1.5, body_width]) cube([bed_width*count+4, bed_length+4, 4]);
    
    
    // ложа под батарейки
    for(i = [1 : count/2]) {
      translate([1+bed_width/2+bed_width*(i*2-2), 3.5, 2]) 
        battery_aa_bed(body_width=body_width, body_length=body_length, 
          noze_length=noze_length, spring_length=spring_length,
          print_error=print_error);
      translate([1+bed_width/2+bed_width*(i*2-1), bed_length+3.5, 2]) rotate([0,0,180]) 
        battery_aa_bed(body_width=body_width, body_length=body_length, 
          noze_length=noze_length, spring_length=spring_length,
          print_error=print_error);
    }
    
    // срезать сверху внутренние стенки между батарейками
    // ровненько
    //translate([2, 4 + noze_length, body_width/2]) 
    //  cube([bed_width*count-3, spring_length+body_length-noze_length, body_width/2+1]);
    // с учетом ячейки для пружинки
    translate([2, 4 + noze_length, body_width/2]) 
      cube([bed_width*count-3, spring_length+body_length-noze_length-1, body_width/2+1]);
    
    
    // выемки по бокам
    translate([-3, 30, 20]) rotate([0, 90, 0]) 
      cylinder(h=bed_width*(count+1), r=15, $fn=100);

    // ячейки для контактов 
    // внизу
    if(count > 2) {
      for(i = [1 : count/2-1]) {
        translate([body_width/2-0.5+bed_width+30*(i-1), 1.5, -1]) 
          contact_gap(body_width=body_width, print_error=print_error);
      }
    }

    // наверху
    for(i = [1 : count/2]) {
      translate([body_width/2-0.5+bed_width*2*(i-1), bed_length+5.5, -1]) mirror([0, 1, 0])
        contact_gap(body_width=body_width, print_error=print_error);
    }

    // одинокая пружинка
    translate([body_width/2-0.5, 1.5, -1])
      contact_plate_minus(body_width=body_width, print_error=print_error);

    // одинокая пипка
    translate([body_width/2-0.5+bed_width*(count-1), 1.5, -1])
      contact_plate_plus(body_width=body_width, print_error=print_error);
  }
}


/**
 * Батарейка AA: цилиндр плюс пипка плюс место под пружинку.
 *
 * @param body_width - 7*2мм - батарейка AA
 * @param body_length - длина батарейки без носика (взять максимум)
 * @param noze_length - длина выступающего носика на плюсе (взять минимум)
 * @param spring_length - длина пружинки
 */
module battery_aa_bed(body_width=14, body_length=49, noze_length=1.5, spring_length=4, 
        print_error=0) {
  difference() {
    union() {
      translate([0, 0, body_width/2]) rotate([270, 0, 0]) 
        cylinder(h=spring_length+body_length, r=body_width/2+print_error, $fn=100);
  
      // вход сверху
      translate([-body_width/2-print_error, 0, body_width/2]) 
        cube([body_width+print_error*2, spring_length+body_length, body_width/2]);
      
      // выемка под носик (притопим на 0.1мм)
      translate([-2.5, spring_length+body_length-0.1, 0]) 
        cube([5, noze_length+0.1, body_width]);
    }

    // "пружинистый" выступ на минусе
    //translate([-2, -6, body_width/2]) rotate([0, 90, 0]) 
    //  cylinder(h=4, r=7, $fn=100);
    // крепление для пружинки на минусе
    translate([body_width/2-4, 1, 0]) cube([5, 1, body_width+0.1]);
    translate([-body_width/2-1, 1, 0]) cube([5, 1, body_width+0.1]);
    
    translate([-body_width/2-1, -0.1, -1]) cube([2, 1+0.2, body_width+2]);
    translate([body_width/2-1, -0.1, -1]) cube([2, 1+0.2, body_width+2]);
    
    // "пружинистый" выступ на плюсе (0.5мм внутри выемки под носик)
    translate([-2, spring_length+body_length+7+(noze_length-0.5), body_width/2]) 
      rotate([0, 90, 0]) cylinder(h=4, r=7, $fn=100);
  }
  
  // крепление для пружинки на минусе (заглубиться вниз)
  translate([-body_width/2+1, 0, -0.5]) cube([body_width-2, 1, body_width+0.5]);
  
  // метка минус
  translate([-2, 6, -3]) cube([4, 2, 6]);

  // метка плюс
  translate([-2, spring_length+body_length-8, -3]) cube([4, 2, 6]);
  translate([-1, spring_length+body_length-9, -3]) cube([2, 4, 6]);
}

/**
 * Пружинка для минуса.
 * 
 * @param body_width - 7*2мм - батарейка AA
 */
module contact_plate_minus(body_width=14, print_error=0) {
  // в толще стенки
  translate([-print_error, 0, 0]) cube([4+print_error*2, 1, body_width+1]);
    
  // щелка сверху
  translate([-print_error, 0, body_width]) cube([4+print_error*2, 3, 4]);
    
  // расчистить путь для канавки под гайкой
  translate([-1-print_error, -3, 0]) cube([4+2+print_error*2, 3.5, 2]);
  // +дополнительная выемка снизу, чтобы щель не заплывала
  // при печати
  translate([-1-print_error, .5, 0.5]) rotate([0, 90, 0]) 
    cylinder(h=4+2+print_error*2, r=1.5, $fn=100);
  //translate([-1-print_error, -3, 0]) cube([4+2+print_error*2, 5, 2]);
}

/**
 * Пипка для плюса.
 * 
 * @param body_width - 7*2мм - батарейка AA
 *
 */
module contact_plate_plus(body_width=14, print_error=0) {
  // в толще стенки
  translate([-print_error, 0, 0]) cube([4+print_error*2, 1, body_width+1]);
    
  // щелка сверху
  translate([-print_error, 0, body_width]) cube([4+print_error*2, 3, 4]);
    
  // расчистить путь для канавки под гайкой
  translate([-1-print_error, -3, 0]) cube([4+2+print_error*2, 3.5, 2]);
  // +дополнительная выемка снизу, чтобы щель не заплывала
  // при печати
  translate([-1-print_error, .5, 0.5]) rotate([0, 90, 0]) 
    cylinder(h=4+2+print_error*2, r=1.5, $fn=100);
  //translate([-1-print_error, -3, 0]) cube([4+2+print_error*2, 5, 2]);
}

/**
 * Щель для контактов в стенке отсека.
 * @param body_width - 7*2мм - батарейка AA
 */
module contact_gap(body_width=14, print_error=0) {
  // 7*2мм - батарейка + 1мм - на боковые стенки по 1/2мм
  bed_width = body_width+1;
    
  // внутри стенки
  translate([-print_error, 0, 0]) cube([bed_width+4+print_error*2, 1, body_width]);

  // для пружинки (минус)
  translate([-print_error, 0, body_width-0.1]) cube([4+print_error*2, 3, 4]);

  // для пипки (плюс)
  translate([bed_width-print_error, 0, body_width-0.1]) cube([4+print_error*2, 3, 4]);
    
  // дополнительная выемка снизу, чтобы щель не заплывала
  // при печати
  //translate([-1-print_error, -1, 0]) cube([bed_width+4+2+print_error, 3, 2]);
  translate([-1-print_error, 0.5, 0]) rotate([0, 90, 0]) 
    cylinder(h=bed_width+4+2+print_error, r=1.5, $fn=100);
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
      
      // щель за гайкой для внутреннего контакта
      translate([0, nut_shift_y-10/2, 2]) cube([13, 10, 1]);
        
      // канавка под гайкой для согнутого внутреннего контакта
      translate([11, nut_shift_y-(4+print_error*2)/2, -1]) cube([2, 4+print_error*2, 4]);
    }
    
    // площадка для внешнего контакта
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
      // дырки в макетке будут гулять вперед-назад (не влево-вправо) вместе с print_error
      //translate([1+print_error, 12, 0]) breadboard_half(lines=1, height=10, print_error=print_error);
      translate([1+print_error, 12, 0]) breadboard_half(lines=1, height=11, print_error=print_error);
  
      // стенка спереди потолще
      translate([4.5, 13, 0]) cube([1.5, 16, 8]);
    }
    
    // путь до контактов макетки
    translate([2, 10, -0.1]) cube([1, 5, 10+0.1]);
    
    // немного срежем снизу, чтобы пластик не заливал дырку
    //translate([1.5, 12.2, -0.1]) cube([3, 13.8, 1]);
    //translate([1, 2, -0.1]) cube([3, 9, 1]);
    
    // и еще срежем внутри слева
    //translate([2, 13.2, -0.1]) cube([1.9, 2, 10.1]);
    //translate([2, 12.2, -0.1]) cube([1.9, 2, 4.3]);
    
    // и еще срежем внутри слева и справа
    // расстояние между левой и правой стенками должно
    // быть не меньше, чем ... мм - это диагональ сложенного
    // контакта макеточной части; длина макеточной части ...мм,
    // но нужна именно диагональ, т.к. мы вставляем контакт в
    // корпус сначала одиним углом вперед, чтобы он сел на
    // небольшую подставку и не выпадал при втыкании провода
    //translate([2, 12.2, -0.1]) cube([1.9, 16, 10+0.1]);
    
    // щель для правой защелки
    translate([2, 26-0.2, -0.1]) cube([5, 1, 8+0.1]);
    translate([5, 23-0.2, 6]) cube([1+0.1, 3+0.1, 2+0.1]);
  }
  
  // "полочка" для края макетки, чтобы не выпадала вниз
  //translate([1.5, 26, 0]) cube([3, 3, 1]);
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
