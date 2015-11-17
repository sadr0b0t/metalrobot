// погрешность для печати на 3д-принтере
print_error=0.2;

//breadboard_block(print_error=print_error);
//breadboard_half(lines=7, print_error=print_error);
//breadboard_half(lines=2, print_error=print_error);
//breadboard_half(lines=1, print_error=print_error);
breadboard(print_error=print_error);

/**
 * Элемент макетной платы - линия, соединенная контактами.
 * @param holes количество отверстий на линии
 * @param height высота всей макетки
 * @param print_error - погрешность печати 3д-принтера
 */
module breadboard_block(holes=5, height=8, print_error=0) {
  // базовая ширина блока:
  // по 1мм на стенки, 1.5мм паз между стенками; 
  // 1мм - ширина (диаметр) отверстия
  block_base_width = 3.5;
    
  difference() {
    // учитываем погрешность печати для толщины всей линии,
    // чтобы при выстраивании ряда толстые стенки не залезали
    // внутрь соседних линий
    cube([block_base_width-print_error*2, 1.5+1+2*holes+0.5*(holes-1)+1+1.5, height]);

    // 1.5мм - ширина отсека для контакта + print_error погрешность для печати
    translate([1-print_error*2, 2.2, -0.1])
      cube([1.5+print_error*2, 0.3+2*holes+0.5*(holes-1)+0.3, height-1+0.1]);
    // внутренние ступеньки 1.2мм
    translate([1-print_error*2, 1, -0.1])
      cube([1.5+print_error*2, 1.5+2*holes+0.5*(holes-1)+1.5, 1.2+0.1]);
    
    for(hole=[1 : holes]) {
      // отверстие для штыря
      translate([1-print_error+0.25, 1.5+1+0.5+2.5*(hole-1), height-2]) cube([1, 1, 3]);
      // воронка (на билдере получается хрень, а не воронка)
      //translate([1-print_error+0.75, 2+1+0.5+2.5*(hole-1), height-1.1]) 
      //  cylinder(r1=0.5, r2=0.75, h=1.2, $fn=10);
    }
  }
}

/**
 * Половина макетной платы - ряд линий.
 * @param lines количество линий
 * @param holes количество отверстий на каждой линии
 * @param height высота всей макетки
 * @param wall толщина боковых стенок (>=1)
 * @param print_error - погрешность печати 3д-принтера
 */
module breadboard_half(lines=17, holes=5, height=8, wall=1, print_error=0) {
  // ширина блока макетки (если располагать впритирку):
  // по 0.5мм на стенки, 1.5мм паз между стенками; 
  // 1мм - ширина (диаметр) отверстия
  block_width = 2.5;
    
  // добавить толщины по бокам
  cube([wall-print_error, 1.5+1+2*holes+0.5*(holes-1)+1+1.5, height]);
  translate([(wall-1) + block_width*lines+print_error, 0, 0])
    cube([wall-print_error, 1.5+1+2*holes+0.5*(holes-1)+1+1.5, height]);

  for(line=[1 : lines]) {
    // (wall-1): 1 - базовая толщина изначальной стенки блока
    translate([(wall-1)+print_error+block_width*(line-1), 0, 0]) 
      breadboard_block(holes=holes, height=height, print_error=print_error);
  }
}

/**
 * Простая макетная плата из двух половинок.
 * @param lines количество линий
 * @param holes количество отверстий на каждой линии
 * @param height высота всей макетки
 * @param wall толщина боковых стенок (>=1)
 * @param print_error - погрешность печати 3д-принтера
 */
module breadboard(lines=17, holes=5, height=8, wall=1, print_error=0) {
  difference() {
    union() {
      breadboard_half(lines=lines, holes=holes, height=height, wall=wall, print_error=print_error);
      mirror([0, 1, 0]) 
        breadboard_half(lines=lines, holes=holes, height=height, wall=wall, print_error=print_error);
    }
    translate([4, -2, 5]) cube([2.5*(lines-3), 4, 4]);
  }
}
