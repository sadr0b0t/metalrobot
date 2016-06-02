//chipkit_uno32();
arduino_uno_china();

//power_socket();
//GPIO_socket();
//socket_usb_b();
//socket_mini_usb();
//button();

/**
 * Плата ChipKIT Uno32, безымянный китайский клон
 * с чипом AVR в корпусе SMD
 */
module arduino_uno_china() {
  size_x = 55;
  size_y = 70;
  
  // плата
  difference() {
    cube([size_x, size_y, 2]);
      
    // отверстия для винтов
    translate([8.5, 2.5, -0.1]) cylinder(r=1.5, h=2+0.2, $fn=100);
    translate([37, 2.5, -0.1]) cylinder(r=1.5, h=2+0.2, $fn=100);
    translate([2.5, 55, -0.1]) cylinder(r=1.5, h=2+0.2, $fn=100);
    translate([size_x-2.5, 53, -0.1]) cylinder(r=1.5, h=2+0.2, $fn=100);
  }
  
  
  // Analog In
  translate([2, 3, 2]) GPIO_socket(count_x=1, count_y=6); 
  
  // Power
  translate([2, 3+2.5*6+2, 2]) GPIO_socket(count_x=1, count_y=8); 
    
  // GPIO
  translate([size_x-2.5-2, 3, 2]) GPIO_socket(count_x=1, count_y=8);
  // GPIO
  translate([size_x-2.5-2, 3+2.5*8+.5, 2]) GPIO_socket(count_x=1, count_y=10);
    
  // чип AVR
  translate([25, 25, 2]) chip_smd(len_x=6, len_y=6, pins_x=8, pins_y=8);
    
  // питание
  translate([3, 58, 2]) power_socket();
    
  // порт USB-B
  translate([32, 61, 2-0.1]) socket_usb_b();
  
  // кнопка Reset
  translate([47, 60, 2]) button();
}

/**
 * Плата ChipKIT Uno32
 */
module chipkit_uno32() {
  size_x = 55;
  size_y = 70;
  
  // плата
  difference() {
    cube([size_x, size_y, 2]);
      
    // отверстия для винтов
    translate([8.5, 2.5, -0.1]) cylinder(r=1.5, h=2+0.2, $fn=100);
    translate([37, 2.5, -0.1]) cylinder(r=1.5, h=2+0.2, $fn=100);
    translate([2.5, 55, -0.1]) cylinder(r=1.5, h=2+0.2, $fn=100);
    translate([size_x-2.5, 53, -0.1]) cylinder(r=1.5, h=2+0.2, $fn=100);
  }
  
  
  // J7 (Analog)
  translate([2, 3, 2]) GPIO_socket(count_x=2, count_y=6); 
  
  // J2 (питание)
  translate([2, 3+2.5*6+2, 2]) GPIO_socket(count_x=1, count_y=6); 
    
  // J6 (GPIO)
  translate([size_x-2.5*2-2, 3, 2]) GPIO_socket(count_x=2, count_y=8);
  // J5 (GPIO)
  translate([size_x-2.5*2-2, 3+2.5*8+.5, 2]) GPIO_socket(count_x=2, count_y=8);
    
  // чип PIC32
  translate([22, 27, 2]) chip_smd(len_x=10, len_y=10, pins_x=15, pins_y=15);
    
  // питание
  translate([3, 58, 2]) power_socket();
    
  // порт mini-USB
  translate([35, 61, 2-0.1]) socket_mini_usb();
  
  // кнопка Reset
  translate([47, 60, 2]) button();
}

/**
 * Гнездо для питания
 */
module power_socket(draw_bottom_contacts=true) {
  difference() { 
    union() {
      translate([0, 1, 0]) cube([8, 15, 7]);
      translate([4, 1, 4+3]) rotate([-90, 0, 0]) cylinder(r=4, h=15, $fn=100);
      translate([0, 1+15-4, 0]) cube([8, 4, 12]);
        
      // сзади пара хвостиков
      cube([2, 2, 3]);
      translate([6, 0, 0]) cube([2, 2, 3]);
    }
    
    // дырка для штекера
    translate([4, 3+0.1, 4+3]) rotate([-90, 0, 0]) cylinder(r=3, h=13, $fn=100);
  }
  
  // штырь внутри гнезда
  translate([4, 0.5, 4+3]) rotate([-90, 0, 0]) cylinder(r=1, h=13.5, $fn=100);
  translate([4, 14, 4+3]) sphere(r=1, $fn=100);
  
  // контакты снизу
  if(draw_bottom_contacts) {
    // земля сбоку
    translate([-0.5, 3, -3]) cube([0.5, 2, 7]);
    translate([0, 4, -3]) rotate([0, -90, 0]) cylinder(r=1, h=0.5, $fn=100);
      
    // плюс сзади
    translate([3, 0.5, -3]) cube([2, 0.5, 10]);
    translate([4, 1, -3]) rotate([90, 0, 0]) cylinder(r=1, h=0.5, $fn=100);
      
    // и еще земля внизу посередине
    translate([3, 7.5, -3]) cube([2, 0.5, 4]);
    translate([4, 8, -3]) rotate([90, 0, 0]) cylinder(r=1, h=0.5, $fn=100);
  }
}

module button(draw_bottom_contacts=true) {
  difference() {
    cube([6, 6, 4]);
    
    translate([3, 3, 2]) cylinder(r=2.2, h=2+0.1, $fn=100);
  }
  
  // кнопка
  translate([3, 3, 0]) cylinder(r=2, h=5, $fn=100);
  
  // выступающие крепления по углам
  translate([.8, .8, 0]) cylinder(r=.5, h=4.5, $fn=100);
  translate([6-.8, .8, 0]) cylinder(r=.5, h=4.5, $fn=100);
  translate([.8, 6-.8, 0]) cylinder(r=.5, h=4.5, $fn=100);
  translate([6-.8, 6-.8, 0]) cylinder(r=.5, h=4.5, $fn=100);
  
  // контакты снизу
  if(draw_bottom_contacts) {
      translate([0.5, -0.5, -3]) cube([1, .5, 4]);
      translate([6-1-0.5, -0.5, -3]) cube([1, .5, 4]);
      
      translate([0.5, 6, -3]) cube([1, .5, 4]);
      translate([6-1-0.5, 6, -3]) cube([1, .5, 4]);
    }
}

/**
 * Гнездо GPIO
 */
module GPIO_socket(count_x=8, count_y=2, draw_bottom_contacts=true) {
  module GPIO_single_socket() {
    difference() {
      cube([2.5, 2.5, 8]);
      
      // дырка внутри
      translate([(2.5-1)/2, (2.5-1)/2, 1]) cube([1, 1, 7+0.1]);
    }
    
    if(draw_bottom_contacts) {
      // штырик снизу
      translate([(2.5-.5)/2, (2.5-.5)/2, -3]) cube([.5, .5, 3+.1]);
    }
  }
  
  socket_width = 2.5;
  for(i = [0 : count_x-1]) {
    for(j = [0 : count_y-1]) {
      translate([socket_width*i, socket_width*j, 0]) GPIO_single_socket();
    }
  }
}

/**
 * Гнездо USB-B
 */
module socket_usb_b(draw_bottom_contacts=true) {
  //cube([12, 16, 10]);
  rotate([-90, 0, 0]) mirror([0, -1, 0]) union() {  
    difference() {
      cube([12, 10, 16]);
        
      translate([1, 1, 6]) linear_extrude(height=10+0.1)
        polygon([
          [0, 0], [0, 6], [2, 8],
          [10-2, 8], [10, 6], [10, 0]
        ]);
    }
    // язычок внутри
    translate([3, 4, 0]) cube([6, 3, 15]);
    
    
    // контакты снизу
    if(draw_bottom_contacts) {
      translate([-0.5, -3, 4]) cube([0.5, 4, 2]);
      translate([12, -3, 4]) cube([0.5, 4, 2]);
    }
  }
}

/**
 * Гнездо mini-USB
 */
module socket_mini_usb() {
  //cube([8, 10, 4]);
  translate([0, 0, 4]) rotate([-90,0,0]) union() {  
    difference() {
      linear_extrude(height=10)
        polygon([
          [0, 0], [0, 3], [1, 4],
          [10-1, 4], [10, 3], [10, 0]
        ]);
      translate([0, 0, 1]) linear_extrude(height=10)
        polygon([
          [0.5, 0.5], [0.5, 3-0.5], [1+0.5, 4-0.5],
          [10-1-0.5, 4-0.5], [10-0.5, 3-0.5], [10-0.5, 0.5]
        ]);
    }
    // язычок внутри
    translate([2, 1.5, 0]) cube([6, 1.5, 9]);
    
    // контактные уши
    cube([0.5, 4, 2]);
    translate([0, 0, 6]) cube([0.5, 4, 2]);
    
    translate([9.5, 0, 0]) cube([0.5, 4, 2]);
    translate([9.5, 0, 6]) cube([0.5, 4, 2]);
  }
}

/**
 * Чип в корпусе SMD
 */
module chip_smd(len_x=10, len_y=10, pins_x=15, pins_y=15) {
  module pin() {
    translate([0, -0.5, 0]) cube([0.3, 0.5, 1]);
    translate([0, -2, 0]) cube([0.3, 2, 0.1]);
  }
    
  // чип  
  cube([len_x, len_y, 2]);
  
  // ножки по X
  if(pins_x > 0) for(i = [0:pins_x-1]) {
    translate([1+(0.3+0.25)*i, 0, 0]) pin();
    translate([1+(0.3+0.25)*i, len_y, 0]) mirror([0, -1, 0]) pin();  
  }
  
  // ножки по Y
  if(pins_y > 0) for(i = [0:pins_y-1]) {
    translate([0, 1+(0.3+0.25)*i, 0]) 
      translate([0, 0.3, 0]) rotate([0, 0, -90]) pin();
    translate([len_x, 1+(0.3+0.25)*i, 0]) mirror([-1, 0, 0]) 
      translate([0, 0.3, 0]) rotate([0, 0, -90]) pin();
  }
}
