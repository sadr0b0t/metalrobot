
//sonar();
ir_line_sensor();

//pin_bended(count=4);
//trimming_resistor(val=15);

/**
 * Плата Arduino Uno (ChipKIT Uno32)
 */
module sonar() {
  // плата
  translate([0, 2, 1]) cube([26, 14, 2], center=true);
  
  translate([-7, 0, 2]) cylinder(r=5, h=6, $fn=100);
  translate([7, 0, 2]) cylinder(r=5, h=6, $fn=100);
  
  // штыри
  translate([0, 10, 2.5]) cube([8, 6, 3], center=true);
}

/**
 * Инфракрасный датчик линии
 */
module ir_line_sensor() {
  
    
  // плата
  difference() {
    translate([-7, 0, 0]) cube([14, 31, 2]);
    
    translate([0, 7, -0.1]) cylinder(r=1.5, h=2+0.2, $fn=100);
  }
  
  // подстроечный резистор
  translate([0, 12, 2]) trimming_resistor();
  
  // штыри
  translate([-2.5, 2.5/2, 5.7]) pin_bended(count=3);
  
  // лампочки
  translate([3.5, 31.5, 2.5]) rotate([-90, 0, 0]) led_head();
  translate([-3.5, 31.5, 2.5]) rotate([-90, 0, 0]) led_head();
}

/**
 * Головка светодиода с точащими снизу 2мя ножками
 * (она же может быть головкой инфракрасного излучателя,
 * приемника и любой другой лампочки такой же формы)
 */
module led_head() {
  cylinder(r=3, h=1, $fn=100);
  cylinder(r=2.5, h=7, $fn=100);
  translate([0, 0, 7]) sphere(r=2.5, $fn=100);
      
  // ножки
  // слева
  translate([-1.5, 0, -1.5]) cube([.5, .5, 3], center=true);
  translate([-1.5, 1.5, -3]) cube([.5, 3, .5], center=true);
  translate([-1.5, 0, -3]) 
    rotate([0, 90, 0]) cylinder(r=0.5/2, h=0.5, $fn=100, center=true);
      
   // справа
  translate([1.5, 0, -1.5]) cube([.5, .5, 3], center=true);
  translate([1.5, 1.5, -3]) cube([.5, 3, .5], center=true);
  translate([1.5, 0, -3]) 
    rotate([0, 90, 0]) cylinder(r=0.5/2, h=0.5, $fn=100, center=true);
}

/**
 * Подстроечный резистор.
 * @param val угол поворота подстроечной ручки
 */
module trimming_resistor(val=15) {
  difference() {
    cube([7, 7, 5]);
    translate([7/2, 7/2, 2]) cylinder(r=1.5+0.1, h=3+0.1, $fn=100);
  }
  
  // ручка настройки
  translate([7/2, 7/2, 2]) rotate([0, 0, val]) difference() {
    cylinder(r=1.5, h=3, $fn=100);
      
    // пазы
    translate([0, 0, 3-1/2]) cube([0.5, 3+0.1, 1+.1], center=true);
    translate([0, 0, 3-1/2]) cube([3+0.1, 0.5, 1+.1], center=true);
  }
  
  // ножки снизу
  translate([7/2-0.5/2, 7-1, -3]) cube([0.5, 0.5, 3]);
  translate([7/2-0.5/2, .5, -3]) cube([0.5, 0.5, 3]);
  translate([0.5, 7/2-0.5/2, -3]) cube([0.5, 0.5, 3]);
}

/**
 * Гребенка пинов, согнутых на 90 градусов, шаг 2.5мм.
 */
module pin_bended(count=2) {
  // один пин
  module single_pin() {
    translate([0, 0, -7/2]) cube([0.7, 0.7, 7], center=true);
    translate([0, -7/2, 0]) cube([0.7, 7, 0.7], center=true);
    rotate([0, 90, 0]) cylinder(r=0.7/2, h=0.7, $fn=100, center=true);
      
    // опора
    translate([0, 0, -2.5]) cube([2.5, 2, 2.5], center=true);
    translate([0, 0, -2.5]) cube([2, 2.5, 2.5], center=true);
  }
  
  // размножить нужно количество пинов с шагом 2.5мм
  if(count > 0) for(i = [0 : count-1]) {
    translate([2.5*i, 0, 0]) single_pin();
  }
}