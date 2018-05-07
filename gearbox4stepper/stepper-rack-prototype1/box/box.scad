use <../gears/gears.scad>;

//print_error=0;
print_error=0.1;
//print_error=0.2;
//print_error=0.3;

$fn=100;

// в сборке
gearbox(print_error=print_error);

//motor_fase(print_error=print_error);
//motor_cover(print_error=print_error);
//gear_motor(print_error=print_error);
//gear_transmission1(print_error=print_error);
//mirror([0,0,-1]) rack(print_error=print_error);

gear_transmission1_x=11.2;
gear_transmission1_y=-6.4;
gear_transmission1_r=12;

face_height = 4;
gap_height = 7+0.4;
cover_height = 4;


/**
 * Редуктор в сборке.
 */
module gearbox(print_error=0) {
    motor_fase(print_error=print_error);
    
    translate([0, 0, cover_height+face_height+gap_height]) rotate([0, 180, 0]) 
        motor_cover(print_error=print_error);
    
    translate([0, 0, face_height+1+0.1]) gear_motor();
    
    translate([gear_transmission1_x, gear_transmission1_y, face_height+1+0.3]) 
        gear_transmission1(print_error=print_error);
    translate([-gear_transmission1_x, gear_transmission1_y, face_height+1+0.3]) 
        gear_transmission1(print_error=print_error);
    
    // рейка
    translate([-28.3, -20.5, 4+0.2 + (5+1.5+.3)]) mirror([0, 0, -1]) rack(print_error=print_error);
}

module motor_fase(print_error=0) {
    difference() {
        union() {
            linear_extrude(height=4) import(file="motor_face.dxf");
            
            // подставка под шестеренкой мотора
            translate([0, 0, 4-0.1]) cylinder(r=3.5, h=1+0.1);
            
            // стенка
            translate([-16.5, -21.15, 0]) cube([33, 2-print_error*2-0.2, 9]);
            
            // стойки между этажами
            // винты мотора, вдали от стенки
            translate([-15.5, 15.5, 0])
                cylinder(r=3.5-print_error, h=face_height+gap_height+2);
            translate([15.5, 15.5, 0])
                cylinder(r=3.5-print_error, h=face_height+gap_height+2);
            
            // винты по центру по краям
            translate([-17.5, 3, 0]) cylinder(r=3.5-print_error, h=face_height+gap_height+2);
            translate([17.5, 3, 0]) cylinder(r=3.5-print_error, h=face_height+gap_height+2);
        }
        
        // большой выступ внизу по центру
        translate([0, 0, -0.1]) cylinder(r=11+print_error, h=2.5+0.1);
        
        // вал мотора
        translate([0, 0, -0.1]) cylinder(r=2.5+print_error, h=face_height+1+0.2);
        
        // винты к мотору
        // у стенки (паз под головку винта)
        translate([-15.5, -15.5, -0.1]) cylinder(r=1.5+print_error, h=face_height+0.2);
        translate([-15.5, -15.5, 1.5]) cylinder(r=3.5+print_error, h=face_height);
        
        translate([15.5, -15.5, -0.1]) cylinder(r=1.5+print_error, h=face_height+0.2);
        translate([15.5, -15.5, 1.5]) cylinder(r=3.5+print_error, h=face_height);
        
        // вдали от стенки (внутри стоек)
        translate([-15.5, 15.5, -0.1])
            cylinder(r=1.5+print_error, h=face_height+gap_height+2+0.2);
        
        translate([15.5, 15.5, -0.1])
            cylinder(r=1.5+print_error, h=face_height+gap_height+2+0.2);
        
        // винты между этажами по центру по краям
        translate([-17.5, 3, -0.1])
            cylinder(r=1.5+print_error, h=face_height+gap_height+2+0.2);
        //translate([-17.5, 3, -0.1]) cylinder(r=3.5+print_error, h=2.5+0.1);
        // закладная гайка
        translate([-17.5, 3, -0.1]) cylinder(r=3.3+print_error, h=2.5+0.1, $fn=6);
        
        translate([17.5, 3, -0.1])
            cylinder(r=1.5+print_error, h=face_height+gap_height+2+0.2);
        //translate([17.5, 3, -0.1]) cylinder(r=3.5+print_error, h=2.5+0.1);
        // закладная гайка
        translate([17.5, 3, -0.1]) cylinder(r=3.3+print_error, h=2.5+0.1, $fn=6);
        
        // окружность шестеренок
        translate([-gear_transmission1_x, gear_transmission1_y, face_height])
            cylinder(r=9.7, h=gap_height+2+0.1, $fn=100);
        translate([gear_transmission1_x, gear_transmission1_y, face_height])
            cylinder(r=9.7, h=gap_height+2+0.1, $fn=100);
    }
            
    // валы шестеренки
    translate([-gear_transmission1_x, gear_transmission1_y, face_height-0.1])
        cylinder(r=2.5-print_error, h=gap_height+2+0.1);
    // подставка под шестеренку
    translate([-gear_transmission1_x, gear_transmission1_y, face_height-0.1])
        cylinder(r=4, h=1+0.1);
    
    translate([gear_transmission1_x, gear_transmission1_y, face_height-0.1])
        cylinder(r=2.5-print_error, h=gap_height+2+0.1);
    // подставка под шестеренку
    translate([gear_transmission1_x, gear_transmission1_y, face_height-0.1])
        cylinder(r=4, h=1+0.1);
}

module motor_cover(print_error=0) {
    difference() {
        union() {
            linear_extrude(height=cover_height) import(file="motor_face.dxf");
            
            // подставка под шестеренкой мотора
            translate([0, 0, 4-0.1]) cylinder(r=3.5, h=1+0.1);
        }
        
        // вал мотора
        translate([0, 0, -0.1]) cylinder(r=2.5+print_error, h=cover_height+1+0.2);
    
        // пазы и винты для стоек между этажами
        // винты мотора, вдали от стенки
        translate([-15.5, 15.5, -0.1]) cylinder(r=1.5+print_error, h=cover_height+0.2);
        translate([-15.5, 15.5, 2]) cylinder(r=3.5+print_error, h=cover_height);
        
        translate([15.5, 15.5, -0.1]) cylinder(r=1.5+print_error, h=cover_height+0.2);
        translate([15.5, 15.5, 2]) cylinder(r=3.5+print_error, h=cover_height);
        
        // винты по центру по краям
        translate([-17.5, 3, -0.1]) cylinder(r=1.5+print_error, h=cover_height+0.2);
        translate([-17.5, 3, 2]) cylinder(r=3.5+print_error, h=cover_height);
        
        translate([17.5, 3, -0.1]) cylinder(r=1.5+print_error, h=cover_height+0.2);
        translate([17.5, 3, 2]) cylinder(r=3.5+print_error, h=cover_height);
        
        // валы шестеренки
        translate([-gear_transmission1_x, gear_transmission1_y, 2])
            cylinder(r=2.5+print_error, h=cover_height);
        translate([gear_transmission1_x, gear_transmission1_y, 2])
            cylinder(r=2.5+print_error, h=cover_height);
            
        // окружность шестеренок
        translate([-gear_transmission1_x, gear_transmission1_y, cover_height])
            cylinder(r=9.7, h=2+0.1, $fn=100);
        translate([gear_transmission1_x, gear_transmission1_y, cover_height])
            cylinder(r=9.7, h=2+0.1, $fn=100);
    }
    
    // подставки под шестеренки
    difference() {
        translate([-gear_transmission1_x, gear_transmission1_y, cover_height-0.1])
            cylinder(r=4, h=1+0.1);
        translate([-gear_transmission1_x, gear_transmission1_y, 2])
            cylinder(r=2.5+print_error, h=cover_height);
    }
    difference() {
        translate([gear_transmission1_x, gear_transmission1_y, cover_height-0.1])
            cylinder(r=4, h=1+0.1);
        translate([gear_transmission1_x, gear_transmission1_y, 2])
            cylinder(r=2.5+print_error, h=cover_height);
    }
}