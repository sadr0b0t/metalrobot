print_error = 0.1;
//print_error = 0.2;

// шестерня на вал мотора
//gear_motor(print_error=print_error);

//gear_transmission1(print_error=print_error);

rack(print_error=print_error);

/** 
 * Шестеренка на вал мотора.
 */
module gear_motor(print_error=0) {
    difference() {
        union() {
            // шестеренка
            linear_extrude(height=5) import(file="gear-pa20-cp1.5-t18.dxf");
        }

        // ось
        //generic_axis(radius=2.5, print_error=print_error);
        d_shaft_axis(radius=2.5, d_radius=2, print_error=print_error);
    }
}

module gear_transmission1(print_error=0) {
    difference() {
        union() {
            // шестеренка
            linear_extrude(height=5) import(file="gear-pa20-cp1.5-t36.dxf");
            
            // подсадка, чтобы не расплывались зубья
            translate([0, 0, -0.3]) cylinder(h=1, r=8.1, $fn=100);
        }

        // ось
        generic_axis(radius=2.5, print_error=print_error);
    }
}

module rack(print_error=0) {
    difference() {
        union() {
            // шестеренка
            linear_extrude(height=5+0.3+1.5) import(file="rack-pa20-cp1.5-l160.dxf");
            
            // подсадка, чтобы не расплывались зубья
            //translate([0, 2, -0.3]) cube([160, 3, 1]);
            //translate([0, 0, -0.3]) cube([4.5, 14, 1]);
            //translate([155, 0, -0.3]) cube([5, 5, 1]);
            
            // рейка "металлический конструктор"
            //translate([0, -10, 0]) cube([160, 11, 1.5]);
            translate([10, -10, 0]) cube([140, 12, 1.5]);
        }
        
        // отверстия под винты
        translate([2.5, 2.5, -0.1]) cylinder(r=1.5 + print_error, h = 5+0.3+1.5+0.2, $fn=100);
        translate([157.5, 2.5, -0.1]) cylinder(r=1.5 + print_error, h = 5+0.3+1.5+0.2, $fn=100);
        
        // ряд отверстий "металлический конструктор"
        //for(cx=[0:10:160]) {
        //    translate([6+cx, -5, -0.1]) cylinder(r=2+print_error, h=1.5+0.2, $fn=100);
        //}
        for(cx=[0:10:130]) {
            translate([15+cx, -5, -0.1]) cylinder(r=2+print_error, h=1.5+0.2, $fn=100);
        }
    }
}

/**
 * Просто круглая ось, по умолчанию диаметр 3мм.
 */
module generic_axis(length=20+0.2, radius=2.5, print_error=0) {
    translate([0, 0, -1])
        cylinder(h=length, r=radius+print_error, $fn=100);
}

/** 
 * Ось с лыской
* @param d_radius - "радиус" лыски (d-shaft) - расстояние от центральной
*     точки площадки лыски до центра окружости.
 */
module d_shaft_axis(length=22, radius=1.5, d_radius=0.9, print_error=0) {
    // диаметр 3мм, срез с одного бока 0.3мм
    translate([0,0,-1])
        difference() {
            cylinder(h=length, r=radius+print_error, $fn=100);
            
            // 1.5 мм "вниз" по y (совместить куб с цилиндром), 
            // 0.9 мм "вправо" по x (срезать справа, d_radius=0.9мм)
            translate([d_radius+print_error, -1.5, 0])
                cube([2, 3, length]);
        }
}

