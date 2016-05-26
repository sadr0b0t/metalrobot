use <3pty/ISOThread.scad>

// Используем библиотеку ISOThread.scad
// http://www.thingiverse.com/thing:311031/
// с небольшими дополнениями для отрисовки 
// скругленной крестовой головки, код кинул разработчику в коменты
// http://www.thingiverse.com/thing:311031/#comments

// винты M3
// crosshead_screw(diam, height);
//crosshead_screw(3,4);
//crosshead_screw(3,6);
//crosshead_screw(3,8);
crosshead_screw(3,10);
//crosshead_screw(3,12);
//crosshead_screw(3,14);
//crosshead_screw(3,16);
//crosshead_screw(3,18);
//crosshead_screw(3,20);
//crosshead_screw(3,22);
//crosshead_screw(3,24);
//crosshead_screw(3,26);
//crosshead_screw(3,28);
//crosshead_screw(3,30);

// винты M4
// crosshead_screw(diam, height);
//crosshead_screw(4,4);
//crosshead_screw(4,6);
//crosshead_screw(4,8);
//crosshead_screw(4,10);
//crosshead_screw(4,12);
//crosshead_screw(4,14);
//crosshead_screw(4,16);
//crosshead_screw(4,18);
//crosshead_screw(4,20);
//crosshead_screw(4,22);
//crosshead_screw(4,24);
//crosshead_screw(4,26);
//crosshead_screw(4,28);
//crosshead_screw(4,30);
//crosshead_screw(4,32);
//crosshead_screw(4,34);
//crosshead_screw(4,36);
//crosshead_screw(4,38);
//crosshead_screw(4,40);

// установочный винт M3
// mounting_screw(diam, height);
//mounting_screw(3, 4);
//mounting_screw(3, 6);
//mounting_screw(3, 8);
//mounting_screw(3, 10);

// гайка M3
//hex_nut(3);

// гайка M4
//hex_nut(4);

/**
 * Винт с резьбой, скругленной головкой и крестообразным шлицем для 
 * крестовой отвертки.
 * 
 * В качестве основы - код модуля
 * module rolson_hex_bolt(dia,hi) из ISOThread.scad 
 * (заменить шестигранную головку на круглую)
 *
 * @param dia диаметр (3=M3, 4=M4 и т.п.)
 * @param hi длина нарезной части
 */
module crosshead_screw(dia, hi) {
    
    // версия для круглой головки
    // высота головки
    hhi = rolson_hex_bolt_hi(dia);
    hr = rolson_hex_bolt_dia(dia)/2;
    round_radius = hhi/3;
    
    // скругленная головка
    difference() {
      union() {
	    translate([0, 0, round_radius])cylinder(r = hr,h = hhi-round_radius, $fn=100);
        translate([0, 0, round_radius]) rotate_extrude($fn=100) 
          translate([hr-round_radius, 0, 0]) circle(r=round_radius, $fn=100);
        cylinder(r = hr-round_radius,h = round_radius, $fn=100);
      }
      // крестовой вырез 
      // используем радиус головки hr, чтобы считать пропорции канавок
      translate([0, 0, (hhi-1)/2-0.1]) cube([hr/4, hr*2-hr*3/4, hhi-1], center=true);
      translate([0, 0, (hhi-1)/2-0.1]) cube([hr*2-hr*3/4, hr/4, hhi-1], center=true);
    }
    // резьба
	translate([0,0,hhi-0.1])	thread_out(dia,hi+0.1);
	translate([0,0,hhi-0.1])	thread_out_centre(dia,hi+0.1);
}

/**
 * Установочный винт: 
 * винт с острым концом без головки, шлиц прорезан в небольшом выступе
* из главного стержня.
 * 
 * Длина винта - общая длина, включая длину выступающего острого конца
 * и выступающей задней части с шлицем.
 *
 * например:
 * http://www.master-krepezh.ru/vinty_44.html
 */

module mounting_screw(dia, hi) {
    // радиус внутреннего стержня (под резьбой),
    // формула из модулей ISOThread: thread_out_centre, thread_out_centre_pitch
    p = get_coarse_pitch(dia);
    h = (cos(30)*p)/8;
	Rmin = (dia/2) - (5*h);	// as wiki Dmin    
    
    // радиус головки - радиус внутреннего стержня винта
    hr = Rmin;    
    // высота головки
    hhi = hr/2;
    
    // общая длина винта включает длину острый конца и выступ с прорезью,
    // поэтому сам стержень с резьбой немного укоротим
    thread_height = hi;// - hr - hhi;
    
    difference() {
      union() {
        // острый наконечник (высота наконечника равна радиусу его основания)
        translate([0, 0, hhi+thread_height+0.1]) cylinder(r1=hr, r2=0, h=hr, $fn=100);
          
        // головка: выступ - обрезанный цилиндр с прорезью (шлицом)
        cylinder(r1=hhi, r2=hr, h=hhi, $fn=100);
          
        // винт с резьбой
	    translate([0,0,hhi])	thread_out(dia,thread_height+0.1);
	    translate([0,0,hhi])	thread_out_centre(dia,thread_height+0.1);
      }
      
      // прорезь для отвертки
      // используем радиус головки hr, чтобы считать пропорции канавки
      translate([0, 0, (hhi*5/3)/2-0.1]) cube([hr/4, dia+0.2, hhi*5/3], center=true);
    }
}

/**
 * Шпилька - винт с резьбой без головки.
 * 
 * В качестве основы - код модуля
 * module rolson_hex_bolt(dia,hi) из ISOThread.scad
 *
 * @param dia диаметр (3=M3, 4=M4 и т.п.)
 * @param hi длина нарезной части
 */
module nohead_screw(dia, hi) {
    hr = rolson_hex_bolt_dia(dia)/2;
    
	thread_out(dia,hi+0.1);
	thread_out_centre(dia,hi+0.1);
}
