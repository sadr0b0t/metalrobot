use <3pty/ISOThread-mod1.scad>

// параметры для отрисовки винтов, можно задавать внешним скриптом

// диаметр винта
dia=4;
// длина винта
hi=14;
// качество отрисовки резьбы
thr = 30;
// качество отрисовки цилиндра-сердечника
cq = 100;

// если не использовать параметры thr и cq напрямую,
// нужно задать глобальный $fn (общее качество для резьбы и сердечника), 
// иначе резьба не отрисуется
//$fn=20;


// для внешних скриптов export-crosshead-xxx.sh
crosshead_screw(dia, hi, thr, cq);

// для внешних скриптов export-crosshead-xxx.sh
//mounting_screw(dia, hi, thr, cq);

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
//crosshead_screw(3,10);
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

// пружинная шайба M3
//mirror([0,-1,0]) spring_washer(3,3/5+0.1,100);

// пружинная шайба M4
//mirror([0,-1,0]) spring_washer(4,4/5+0.1,100);

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
module crosshead_screw(dia, hi, thr=$fn, cq=$fn) {
    
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
	translate([0,0,hhi-0.1])	thread_out(dia,hi+0.1, thr);
	translate([0,0,hhi-0.1])	thread_out_centre(dia,hi+0.1, cq);
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

module mounting_screw(dia, hi, thr=$fn, cq=$fn) {
    // радиус внутреннего стержня (под резьбой),
    // формула из модулей ISOThread: thread_out_centre, thread_out_centre_pitch
    p = get_coarse_pitch(dia);
    h = (cos(30)*p)/8;
	//Rmin = (dia/2) - (5*h);	// as wiki Dmin
    Rmin = (dia/2) - (3*h);	// as wiki Dmin
    
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
	    translate([0,0,hhi])	thread_out_centre(dia,thread_height+0.1, cq);
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
module nohead_screw(dia, hi, thr=$fn, cq=$fn) {
    hr = rolson_hex_bolt_dia(dia)/2;
    
	thread_out(dia,hi+0.1, thr);
	thread_out_centre(dia,hi+0.1, cq);
}

/**
 *  Пружинная шайба
 */
module spring_washer(dia,p,thr=$fn)
// spring washer with single turn
//  dia=diameter, 6=M6 etc
//  p=pitch
//  thr=thread quality, 10=make a thread with 10 segments per turn
{
    
    // washer ring width would be dia/3
    rw = dia/3;
    // washer thikness (ring height) would be
    h = dia/5;
    
	s = 360/thr;
	for(sg=[0:thr-1])
		washer_pt(dia/2,s,sg,thr,rw,h,p/thr);
}

/**
 * Один сегмент пружинной шайбы
 */
module washer_pt(rt,s,sg,thr,rw,h,sh)
// make a part of spring washer thread (single segment)
//  rt = inner radius of washer thread (nearest centre)
//  p = pitch
//  s = segment length (degrees)
//  sg = segment number
//  thr = segments in circumference
//  rw = washer ringh width
//  h = ISO h of washer plate
//  sh = segment height (z)
{
	as = (sg % thr) * s;			// angle to start of seg
	ae = as + s  - (s/100);		// angle to end of seg (with overlap)
	z = sh*sg;
    
	//   1,5__________2,6
	//   |               |
 	//   |               |
	//   |___________|
	//   0,4             3,7
	//  view from front (x & z) extruded in y by sg
	//  
	//echo(str("as=",as,", ae=",ae," z=",z));
    
	polyhedron(
		points = [
			[cos(as)*rt,sin(as)*rt,z],                  // 0
			[cos(as)*rt,sin(as)*rt,z+h],               // 1
			[cos(as)*(rt+rw),sin(as)*(rt+rw),z+h],    // 2
			[cos(as)*(rt+rw),sin(as)*(rt+rw),z],       // 3
    
			[cos(ae)*rt,sin(ae)*rt,z+sh],              // 4
			[cos(ae)*rt,sin(ae)*rt,z+h+sh],            // 5
			[cos(ae)*(rt+rw),sin(ae)*(rt+rw),z+h+sh], // 6
			[cos(ae)*(rt+rw),sin(ae)*(rt+rw),z+sh]],   // 7
		faces = [
			[0,1,2,3],    // near face
			[4,7,6,5],    // far face
			[0,4,5,1],	 // left face
			[6,7,3,2],    // right face
			[0,3,7,4],    // bottom face
			[1,5,6,2] ]);	 // top face
}
