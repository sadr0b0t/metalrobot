//print_error=0;
print_error=0.2;
//print_error=0.4;

$fn=100;

//helix(print_error=print_error);
helix_fix(print_error=print_error);
//base(print_error=print_error);
//top(print_error=print_error);
//helix_key(print_error=print_error);

//spring_bender();

/**
 * В сборке.
 */
module spring_bender() {
  helix_height=20;
    
  translate([0, 0, 5]) helix(print_error=print_error);
  base(print_error=print_error);
  translate([0, 0, helix_height + 8]) rotate([180, 0, 0]) top(print_error=print_error);
}

module helix(print_error=0) {
  key_width=2;
  key_length=15;
    
  // берем по 4мм на каждый виток: 2 на проволоку+2 на спираль,
  // 5 витков: 4*5=20мм
  helix_height=20;
    
  difference() {
    union() {
      // главный вал
      cylinder(h=helix_height, r1=4, r2=2);
          
      // вал сверху
      //translate([0, 0, helix_height]) cylinder(h=10, r=2);
        
      // спиралька
      linear_extrude(height=20-4, twist=-360*4, center=false, scale=.65) 
        translate([2.5, 0, 0]) circle(r=3);//scale([1, 3, 1]) circle(r=1);
        
      
      // углы для квадратной основы пружины, 8мм периметр
      translate([-8/2, -8/2, -4]) cube([8, 8, 4]);
      translate([-14/2+print_error, -14/2+print_error, -4-4]) 
        cube([14-print_error*2, 14-print_error*2, 4]);
      //translate([-8/2, -8/2, -3-2-1]) cube([8, 8, 1]);
  
      // вал снизу
      difference() {
        translate([0, 0, -3-2-1-3]) cylinder(h=3, r=14);
          
        // пазы в нижнем валу под фиксатор проволоки
        translate([-18/2-print_error, -18/2-print_error, -4-4]) 
          cube([18+print_error*2, 18+print_error*2, 2+0.1]);
      }
    }
    
    // срез на макушке 
    translate([-6, -3, helix_height-4]) cube([6, 6, 10]);
    
    // дырка сбоку для проволоки сверху
    //translate([0, -1, helix_height-1.5]) rotate([-90, 0, 0]) cylinder(h=6, r=0.5+print_error);
    //translate([-0.5-print_error, -1, helix_height-1.5]) cube([1+print_error*2, 6, 3]);
    
    // дырка сбоку для проволоки снизу
    //translate([-3, -7, -4-0.1]) cube([1, 10, 3+0.1]);
    
    // квадратная дырка снизу под ключ
    translate([-2, -2, -9-0.1]) cube([4, 4, 10+0.1]);
    // арка на конце дырки, чтобы пластик не обваливался
    // при печати без поддержки
    translate([0, 2, -8+10]) rotate([90, 0, 0]) cylinder(h=4, r=2);
  }
  
  // спиралька
  //linear_extrude(height=20, twist=-360*5, center=false, scale=.65) 
  //  translate([2.5, 0, 0]) circle(r=3);//scale([1, 3, 1]) circle(r=1);
}

module helix_fix(print_error=0) {
  // центрируем все объекты
  difference() {
    translate([-18/2+print_error, -18/2+print_error, 0])
      cube([18-print_error*2, 18-print_error*2, 6]);
      
    // выкусываем изнутри внешний периметр
    translate([-14/2-print_error, -14/2-print_error, -0.1]) 
      cube([14+print_error*2, 17, 3+0.1]);
    // выкусываем изнутри периметр по проволоке 
    // (даём проволоке щелку в миллиметр)
    translate([-10/2-print_error, -10/2-print_error, -0.1]) 
      cube([10+print_error*2, 17, 4+0.1]);
    // выкусываем изнутри верхний периметр
    // двойная компенсация погрешности печати,
    // т.к. на спирали на этом блоке погрешность не компенсируем
    translate([-8/2-print_error*2, -8/2-print_error*2, -0.1]) 
      cube([8+print_error*4, 17, 6+0.2]);
      
    // справа выступ покороче
    translate([-18/2-0.1, 4, -0.1]) cube([18/2, 6, 6+0.2]);
  }
  // зафиксировать проволоку сверху
  //translate([12+4-(4-print_error), 0, 6-2]) cube([4-print_error, 12+4, 2]);
  // еще прижать проволоку по бокам 
  //translate([12+4-(3-print_error), 0, 6-3]) cube([3-print_error, 12+4, 1]);
  // защелочка снизу
  //translate([12+4-(3-print_error), 0, 0]) cube([3-print_error, 12+4, 1-print_error]);
}

module helix_key(print_error=0) {
  difference() {
    union() {  
      // брусок, вставить внутрь спирали
      translate([-2+print_error, -2+print_error, 0]) cube([4-print_error*2, 4-print_error*2, 5]);
        
      // вал сверху
      translate([0, 0, 5]) cylinder(h=10, r=3-print_error);
    }
  }
  
  // ручки ключика
  translate([-3/2, -7, 10]) cube([3, 14, 5]);
}

module base(print_error=0) {
  key_width=2;
  key_length=15;
    
  // берем по 4мм на каждый виток: 2 на проволоку+2 на спираль,
  // 5 витков: 4*5=20мм
  helix_height=20;
   
  difference() {
    translate([-17, -10, 0]) cube([34, 20, 3]);
    
    // углубление для большого цилиндра
    translate([0, 0, 1]) cylinder(r=7+print_error, h=2+0.1);
      
    // сквозное отверстие
    translate([0, 0, -0.1]) cylinder(r=3+print_error, h=3+0.2);
  }
  
  // щель для проволоки
  difference() {
    translate([12, -8, 0]) cube([3, 16, 7+helix_height]);
    // вдоль правой стороны
    //translate([11, 2, 0.1]) rotate([5, 0, 0]) translate([0, -1, 0]) cube([5, 2, 7+helix_height+0.1]);
    // вдоль левой стороны
    translate([11, -2, 0.1]) rotate([-5, 0, 0]) translate([0, -1, 0]) cube([5, 2, 7+helix_height+0.1]);
  }
  
  // вторая стенка
  translate([-15, -8, 0]) cube([3, 16, 7+helix_height]);
}

module top(print_error=0) {
    
  // берем по 4мм на каждый виток: 2 на проволоку+2 на спираль,
  // 5 витков: 4*5=20мм
  helix_height=20;
    
  //
    
  difference() {
    union() {
      translate([-17, -10, 0]) cube([34, 20, 3]);
      
      // выступающие стенки под стенку с щелками
      translate([11, -9, 0]) cube([5, 18, 7]);
        
      // выступающие стенки под вторую стенку
      translate([-16, -9, 0]) cube([5, 18, 7]);
    }
    
    // срезать выступающие стенки под уголки
    translate([-17, -4, 3]) cube([34, 8, 4.1]);
    
      
    // паз под стенку с щелками 
    translate([12-print_error, -8-print_error, 1]) cube([3+print_error*2, 16+print_error*2, 6.1]);
      
    // паз под вторую стенку
    translate([-15-print_error, -8-print_error, 1]) cube([3+print_error*2, 16+print_error*2, 6.1]);
    
    // длинная щель для проволоки
    translate([2.5, -2, -0.1]) cube([17, 4, 3+0.2]);
  }
  
  // внешний цилиндр - стенки для конуса:
  translate([0, 0, 3]) difference() {
    cylinder(h=helix_height, r=6+1);
    
    // большой диаметр конуса вместе со спиралью - 10мм
    // малый диаметр конуса вместе со спиралькой - 8мм
    translate([0, 0, -0.1]) cylinder(h=helix_height+0.2, r1=3+1, r2=5.5+1);
      
    // щель для проволоки
    // вдоль правой стороны
    //rotate([5, 0, 0]) translate([2, -2, -1]) cube([5, 4.5, helix_height+2]);
    // вдоль левой стороны
    rotate([-5, 0, 0]) translate([2, -2.5, -1]) cube([5, 4.5, helix_height+2]);
  }
}

