
print_error=0.2;

$fn=100;

//helix(print_error=print_error);
//base(print_error=print_error);
top(print_error=print_error);

//spring_bender();

/**
 * В сборке.
 */
module spring_bender() {
  helix_height=20;
    
  translate([0, 0, 7]) helix(print_error=print_error);
  base(print_error=print_error);
  //translate([0, 0, helix_height + 11]) rotate([180, 0, 0]) top(print_error=print_error);
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
      linear_extrude(height=20, twist=-360*5, center=false, scale=.65) 
        translate([2.5, 0, 0]) circle(r=3);//scale([1, 3, 1]) circle(r=1);
    }
    
    // дырка сверху
    //translate([0, 0, helix_height-4]) cylinder(h=5+5+0.2, r=1);
    translate([-1, -1, helix_height-6]) cube([2, 2, 10]);
    
    // дырка сбоку для проволоки
    translate([0, -1, helix_height]) rotate([-90, 0, 0]) cylinder(h=6, r=0.5+print_error);
    
    // еще дырка сверху для поворотного ключа
    translate([0, -5, helix_height+5]) rotate([-90, 0, 0]) cylinder(h=10, r=0.5+print_error);
    
    // и еще дырка сверху для поворотного ключа
    translate([0, -5, helix_height+8]) rotate([-90, 0, 0]) cylinder(h=10, r=0.5+print_error);
  }
  
  // спиралька
  //linear_extrude(height=20, twist=-360*5, center=false, scale=.65) 
  //  translate([2.5, 0, 0]) circle(r=3);//scale([1, 3, 1]) circle(r=1);
  
  
  // углы для квадратной основы пружины,
  translate([0, 0, -3]) difference() { 
    // 10мм внешний периметр
    translate([-5, -5, 0]) cube([10, 10, 3]);
      
    // пазы по периметру
    // сверху (x,y)
    translate([-5-0.1, 4, 1]) cube([10.2, 1.1, 2.1]);
    // снизу (x,y)
    translate([-5-0.1, -5-0.1, 1]) cube([10.2, 1.1, 2.1]);
    // слева (x,y)
    translate([-5-0.1, -5-0.1, 1]) cube([1.1, 10.2, 2.1]);
    // справа (x,y)
    translate([4, -5-0.1, 1]) cube([1.1, 10.2, 2.1]);
      
    // вход для проволоки
    translate([-2, -5-0.1, 2-0.1]) cube([4, 1.1, 1.2]);
  }
  
  // Вал снизу
  translate([0, 0, -3-2]) cylinder(h=2, r=7);
}

module base(print_error=0) {
  key_width=2;
  key_length=15;
    
  // берем по 4мм на каждый виток: 2 на проволоку+2 на спираль,
  // 5 витков: 4*5=20мм
  helix_height=20;
   
  difference() {
    translate([-17, -10, 0]) cube([34, 20, 3]);
    
    // отверстие
    translate([0, 0, 1]) cylinder(r=7+print_error, h=2+0.1);
  }
  
  // щель для проволоки
  difference() {
    translate([12, -8, 0]) cube([3, 16, 8+helix_height]);
    translate([11, 1, 0]) rotate([5, 0, 0]) cube([5, 2, 10+helix_height+0.1]);
  }
  
  // вторая стенка
  translate([-15, -8, 0]) cube([3, 16, 8+helix_height]);
}

module top(print_error=0) {
    
  // берем по 4мм на каждый виток: 2 на проволоку+2 на спираль,
  // 5 витков: 4*5=20мм
  helix_height=20;
    
  //
    
  difference() {
    union() {
      translate([-17, -10, 0]) cube([34, 20, 3]);
      
      // под стенку с щелками держать
      translate([11, -9, 0]) cube([5, 18, 7]);
        
      // под вторую стенку
      translate([-16, -9, 0]) cube([5, 18, 7]);
    }
    
    // срезать выступающие "коробки" под уголки
    translate([-17, -4, 3]) cube([34, 8, 4.1]);
    
      
    // под цилиндр вращать спираль
    translate([0, 0, -0.1]) cylinder(h=3+0.2, r=2+print_error);
      
    // под стенку с щелками держать
    translate([12-print_error, -8-print_error, 1]) cube([3+print_error*2, 16+print_error*2, 6.1]);
      
    // под вторую стенку
    translate([-15-print_error, -8-print_error, 1]) cube([3+print_error*2, 16+print_error*2, 6.1]);
  }
  
  // внешний цилиндр - стенки для конуса:
  translate([0, 0, 3]) difference() {
    cylinder(h=helix_height, r=6+1);
    
    // большой диаметр конуса вместе со спиралью - 10мм
    // малый диаметр конуса вместе со спиралькой - 8мм
    translate([0, 0, -0.1]) cylinder(h=helix_height+0.2, r1=3+1, r2=5+1);
      
    // щель для проволоки
    translate([3, -2.5, -0.1]) rotate([5, 0, 0]) cube([4, 4.5, helix_height+0.2]);
  }
}



