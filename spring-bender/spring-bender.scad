
print_error=0.2;

$fn=100;

translate([0, 0, 6]) helix(print_error=print_error);
//base(print_error=print_error);
//top(print_error=print_error);

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
      translate([0, 0, helix_height]) cylinder(h=2, r=5);
        
      // спиралька
      linear_extrude(height=20, twist=-360*5, center=false, scale=.65) 
        translate([2.5, 0, 0]) circle(r=3);//scale([1, 3, 1]) circle(r=1);
    }
    
    // дырка сверху
    //translate([0, 0, -0.1]) cylinder(h=5+5+0.2, r=1);
    
    // дырка сбоку
    translate([0, 1, helix_height]) rotate([90, 0, 0]) cylinder(h=6, r=0.5+print_error);
  }
  
  // спиралька
  //linear_extrude(height=20, twist=-360*5, center=false, scale=.65) 
  //  translate([2.5, 0, 0]) circle(r=3);//scale([1, 3, 1]) circle(r=1);
  
  
  // углы для квадратной основы пружины, 
  // 10мм внешний периметр
  translate([-5, -5, -3]) cube([10, 10, 3]);
  
  // ножка
  translate([0, 0, -3-4-5]) cylinder(r=2-print_error, h=4+5);
  
  // ручка "ключика"
  difference() {
    translate([-key_width/2, -key_length/2, -3-4-5]) cube([key_width, key_length, 5]);
      
    translate([-2, -9, -3-8]) rotate([30, 0, 0]) cube([4, 8, 4]);
    mirror([0, 1, 0]) translate([-2, -9, -3-8]) rotate([30, 0, 0]) cube([4, 8, 4]);
  }
}

module base(print_error=0) {
  key_width=2;
  key_length=15;
    
  // берем по 4мм на каждый виток: 2 на проволоку+2 на спираль,
  // 5 витков: 4*5=20мм
  helix_height=20;
   
  difference() {
    translate([-12, -10, 0]) cube([27, 20, 3]);
    
    // отверстие
    translate([0, 0, -0.1]) cylinder(r=2+print_error, h=3+0.2);
    
    // щель для "ключика"
    translate([-key_width/2-print_error, -key_length/2-print_error, -0.1]) 
      cube([key_width+print_error*2, key_length+print_error*2, 3+0.2]);
  }
  
  // щель для проволоки
  difference() {
    translate([10, -8, 0]) cube([3, 16, 9+helix_height]);
    translate([9, -1, 0]) cube([5, 2, 9+helix_height+0.1]);
  }
  
  // вторая стенка
  translate([-10, -8, 0]) cube([3, 16, 9+helix_height]);
}

module top(print_error=0) {
  difference() {
    translate([-12, -10, 0]) cube([27, 20, 3]);
      
    // под цилиндр вращать спираль
    translate([0, 0, 1]) cylinder(h=3, r=5+print_error);
      
    // под стенку с щелками держать
    translate([-10-print_error, -8-print_error, 1]) cube([3+print_error*2, 16+print_error*2, 3]);
      
    // под вторую стенку
    translate([10-print_error, -8-print_error, 1]) cube([3+print_error*2, 16+print_error*2, 3]);
  }
}
    


