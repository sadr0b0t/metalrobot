// провода, кабели, шлейфы

wire1_1core_pin_pin();
//bus_3pin_female_male();
//wire_power_cable();
//wire_usb_a_b();

// разъемы и штекеры
//head_pin();
//socket_bls(count=3);
//power_plug_jack();
//u_shape_terminal();
//plug_usb_a();
//plug_usb_b();

/**
 * Китайский провод 1мм из набора пучок 65 проводов за 100руб папа-папа
 */
module wire1_1core_pin_pin() {
  // так вообще все повиснет вплоть до операционки
  //$fn = 100;
    // тормоза
//  minkowski() {
//    linear_extrude(height=1) import(file="wire1-43d.dxf");
//    sphere(r=0.5);
//  }
    
    // провод
    linear_extrude(height=1) import(file="wire1-1core-d1mm-43d.dxf");
    
    // штыри на головках
    translate([0.7, 105, 0.5]) rotate([-90,0,0]) head_pin();
    translate([55.6, 125, 0.5]) rotate([-90,0,15]) head_pin();
}

/** 
 * Провод питания 2 жилы 2мм, штекер и U-образные клемыы 
 */
module wire_power_cable() {
    // провод
    linear_extrude(height=2) import(file="wire2-core1-d2mm-43d.dxf");
    translate([0,0,2]) 
      linear_extrude(height=2) import(file="wire2-core2-d2mm-43d.dxf");
    
    // штекер питания
    translate([0.9, 105, 2]) rotate([-90,0,0]) power_plug_jack();
    
    // U-образные клеммы
    translate([51, 107, 1]) rotate([-90,0,-10]) u_shape_terminal();
    translate([77, 105, 3]) rotate([-90,0,-10]) u_shape_terminal();
}

/** 
 * Кабель USB A-B
 */
module wire_usb_a_b() {
    // провод
    linear_extrude(height=4.5) import(file="wire4-1core-d5mm-43d.dxf");
    
    // штекер питания
    translate([2.5, 95, 2.25]) rotate([-90,0,0]) rotate([0,0,180]) plug_usb_a();
    
    // U-образные клеммы
    translate([59.7, 120, 2.25]) rotate([-90,0,15]) rotate([0,0,180]) plug_usb_b();
}

/** 
 * Шлейф 3 жилы: розетка-штепсель (мама-папа)
 */
module bus_3pin_female_male() {
    // провод
    translate([0, 0, .5]) 
      linear_extrude(height=1) import(file="wire3-core1-d1mm-43d.dxf");
    translate([0, 0, 3.5]) 
      linear_extrude(height=1) import(file="wire3-core2-d1mm-43d.dxf");
    translate([0, 0, 6.5]) 
      linear_extrude(height=1) import(file="wire3-core3-d1mm-43d.dxf");
    
    // 3 гнезда
    translate([1.5, 103, 8+0.1 /* чтобы объект был цельным */]) 
      rotate([0,90,90]) socket_bls(count=3);
    
    // штыри на головках
    translate([50.2, 107, .5]) rotate([-90,0,-10]) head_pin();
    translate([75.5, 106, 3.5]) rotate([-90,0,-35]) head_pin();
    translate([106.2, 97.2, 6.5]) rotate([-90,0,-80]) head_pin();
}

/**
 * Металлический штырь внутри силиконовой головки
 */
module head_pin() {
  // силиконовая головка
  cylinder(r=1.5, h=10, $fn=100);
  sphere(r=1.5, $fn=100);
  translate([0,0,10]) sphere(r=1.5, $fn=100);
  
  // штырь
  cylinder(r=0.5, h=19, $fn=100);
}

/**
 * Гнездо BLS
 */
module socket_bls(count=1) {
  module single_bls() {
    difference() {
      cube([2, 2, 13]);
      
      // дырка внутри
      translate([0.5, 0.5, -0.1]) cube([1, 1, 13+0.2]);
        
      // небольшой паз сбоку
      translate([-0.1, -0.1, 5]) cube([2+0.2, .2+0.1, 5]);
        
      // окошко сбоку
      translate([0.2, -0.1, 5+3+0.2]) cube([1.6,1.5+0.1,1.6]);
    }
    
    // защелка в боковом пазу
    translate([0.4, 0, 5]) cube([1.2, .2, 3]);
  }
  
  bls_width = 2;
  for(i = [0 : count-1]) {
    translate([(bls_width+1)*i, 0, 0]) single_bls();
    if(i != count-1) {
      translate([(bls_width+1)*(i+1) - 1, 0, 0]) cube([1, 2, 13]);
    }
  }
}

module u_shape_terminal() {
  // термоусадка
  translate([-1.5,0,0]) cylinder(r=1, h=8, $fn=100);
  translate([-1.5,0,0]) sphere(r=1, $fn=100);
  
  translate([1.5,0,0]) cylinder(r=1, h=8, $fn=100);
  translate([1.5,0,0]) sphere(r=1, $fn=100);
    
  translate([-1.5,-1,0]) cube([3, 2, 8]);
  translate([-1.5,0,0]) rotate([0,90,0]) cylinder(h=3, r=1, $fn=100);
  
  // клемма
  translate([-3,0.5,0]) rotate([90,0,0]) 
    linear_extrude(height=1) import(file="u-shaped-terminal-43d.dxf");
}

/**
 * Штекер питания Arduino
 */
module power_plug_jack() {
  // "жгутик"
  difference() {
    cylinder(r=3, h=13, $fn=100);
    translate([0,0,-0.1]) cylinder(r=2.5, h=13+0.2, $fn=100);
  }
    
  // корпус
  translate([0,0,13]) cylinder(r=5, h=20, $fn=8);
  translate([0,0,11]) cylinder(r=4.5, h=2, $fn=100);
    
  // штекер
  translate([0,0,13+20]) difference() {
    union() {
      cylinder(r=2.5, h=12, $fn=100);
      translate([0, 0, 12]) sphere(r=2.5, $fn=100);
    }
    
    // срезать макушку
    translate([0, 0, 12+1.5]) cylinder(r=3, h=3);
    
    // дырка внутри
    cylinder(r=1, h=15, $fn=100);
  }
}

/**
 * Штекер USB-A
 */
module plug_usb_a() {
  // "жгутик"
  difference() {
    cylinder(r=7/2, h=11, $fn=100);
    translate([0, 0, -0.1]) cylinder(r=2.5, h=13+0.2, $fn=100);
  }
    
  // корпус
  translate([0, 0, 11+20/2]) cube([17, 7, 20], center=true);
    
  // штекер
  translate([0, 0, 11+20]) union() {
    difference() {
      translate([0, 0, 15/2]) cube([12, 4, 15], center=true);
    
      // всё внутри
      translate([0, 0, 15/2]) cube([12-0.4, 4-0.4, 15+0.2], center=true);
    
      // еще две пары квадратных дырок сверхи и снизу для антуражу
      translate([3, 0, 7+2/2]) cube([2.5, 14+0.2, 2], center=true);
      translate([-3, 0, 7+2/2]) cube([2.5, 14+0.2, 2], center=true);
    }
    // пластмасска внутри
    translate([0, -4/2+0.2+1.5/2, 15/2-0.2]) cube([12-0.4, 1.5, 15-0.2], center=true);
  }
}

/**
 * Штекер USB-B
 */
module plug_usb_b() {
  // "жгутик"
  difference() {
    cylinder(r=7/2, h=11, $fn=100);
    translate([0, 0, -0.1]) cylinder(r=2.5, h=13+0.2, $fn=100);
  }
    
  // корпус
  translate([0, 0, 11+20/2]) cube([11, 10, 20], center=true);
    
  // штекер
  translate([0, 0, 11+20]) union() {
    difference() {
      // translate([0, 0, 15/2]) cube([8, 7, 15], center=true);
      linear_extrude(height=15) 
        polygon([ 
          [-8/2,-7/2], [-8/2, -7/2+5], [-8/2+2, -7/2+5+2],
          [8/2-2, -7/2+5+2], [8/2, -7/2+5], [8/2,-7/2]
        ]);
    
      // всё внутри
      translate([0, 0, 15/2]) cube([6, 3, 15+0.2], center=true);
    }
  }
}
