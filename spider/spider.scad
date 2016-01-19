//servo_with_2holders();
//leg_with_servo();
//servo_holder1();
//servo_holder1_1();
//servo_holder();

//2servo_holders_for_printing();
//2servo_holders1_for_printing();
//2servo_holders1_1_for_printing();
//2legs_for_printing();

//4servo_holders_for_printing();
//4servo_holders1_for_printing();

//scale(v=[.3,.3,.3]) full_model();
body();
translate([0,40,0]) mirror([0,1,0]) body();


module full_leg() {
    translate ([80, 0, 0]) rotate(a=180, v=[0,0,1]) {
        rotate(a=45, v=[0,1,0]) 2servo_holders_for_printing();
        translate([-20, 8, 50]) rotate(a=120, v=[0,1,0]) leg_with_servo();
        translate([0, 6, -25]) servo_with_holder1();
        translate([81, 12, -32]) rotate(a=90, v=[1,0,0]) rotate(a=180, v=[0,1,0]) servo_with_holder1();    
    }
}

module full_model() {
    module right_half() {
        translate([10,-50, -40]) rotate (a=90, v=[0,0,1]) body();
        translate([10,130, 0]) rotate (a=180, v=[0,1,0]) rotate (a=270, v=[0,0,1]) body();
        // 3 legs
        translate([-10, 0, 0]) rotate (a=-30, v=[0,0,1]) full_leg();
        translate([0, 60, 0]) full_leg(); 
        translate([-20, 120, 0]) rotate (a=30, v=[0,0,1]) full_leg();
    }

    right_half();
    translate([-60,0,0]) mirror([1,0,0]) right_half();
}

module 4servo_holders_for_printing() {
    2servo_holders_for_printing();
    translate ([0, 42, 0]) 2servo_holders_for_printing();
}

module 4servo_holders1_for_printing() {
    2servo_holders1_for_printing();
    translate ([0, 32, 0]) 2servo_holders1_for_printing();
}

module 2servo_holders_for_printing() {
    // 2 servo holders for printing
    translate ([0, 0, 14]) rotate(a=90, v=[0,1,0]) servo_holder();
    rotate(a=270, v=[0,1,0]) servo_holder();
}

module 2servo_holders1_for_printing() {
    // 2 servo holders for printing
    translate ([-42, 0, 0]) servo_holder1();
    servo_holder1();
}

module 2servo_holders1_1_for_printing() {
    // 2 servo holders for printing
    translate ([-42, 0, 0]) servo_holder1_1();
    servo_holder1_1();

    translate([-1, 0, 0]) cube([4, 0.5, 14]);
}

module 2legs_for_printing() {
    // 2 legs for printing
    translate ([0, 0, 3]) rotate (a= 90, v=[1,0,0]) leg();
    translate ([0, 4, 0]) rotate (a= 270, v=[1,0,0]) leg();

    cube([0.5, 4, 3]);
}


module leg_with_servo() {
    leg();

    translate ([24, 8, 12]) 
        rotate (a=180, v=[0, 1, 0]) 
        rotate (a=90, v=[1, 0, 0]) 9g_motor();
}

module body() {
    linear_extrude (height = 2)
        polygon(points=[[0,0], [60,-20], [120,-20],[180,0], 
                                   [170,18], [120,00], [60,0], [10,18]], 
                                  paths=[[0,1,2,3,4,5,6,7]]);
    
    //translate([75, -20, 0]) cube([30, 80, 2]);

    translate([60, -20, 0]) cube([3, 20, 25]);
    translate([120, -20, 0]) cube([3, 20, 25]);
}

module leg() {

    difference() {
        //minkowski($fn=20) {
            rotate (a= 90, v = [1, 0, 0]) linear_extrude (height = 3) {
                polygon(points=[[0,0],[0,20],[40,20],[148,30], [150,27],[40,0]], 
                             paths=[[0,1,2,3,4,5]]);
                translate([150, 30, 0]) circle(r = 3);
            }
            // rounded corners
            sphere(1);
        //}
        translate ([11, -5, 6]) cube ([23, 6, 16]);
    }
}

module servo_with_2holders() {
    servo_holder();
    translate ([15, 6, 4]) rotate (a=270, v=[0, 1, 0])  servo_with_holder1();
}

module servo_with_holder1() {
    translate ([20.5, 10, 8]) rotate (a=90, v=[1, 0, 0]) 9g_motor();
    servo_holder1();
//    servo_holder1_1();
}

module servo_holder1() {
    // дно
    cube ([41, 16+9, 2]);

    // боковина напротив держалок
    translate([9, 16+7, 0]) cube ([23, 2, 12 + 2]);
    
    // боковина перепендикулярно держалкам
    translate ([39, 7, 0]) cube ([2, 14, 12 + 2]);

    // держалки
    cube ([9, 4, 12 + 2]);
    translate([41-9, 0, 0]) cube ([9, 4, 12 + 2]);
}

module servo_holder1_1() {
    // дно
    cube ([41, 16+9, 2]);

    // боковина напротив держалок
    translate([9, 16+7, 0]) cube ([23, 2, 12 + 2]);
    
    // боковина перепендикулярно держалкам
    translate ([39, 7, 0]) cube ([2, 14, 12 + 2]);

    // держалки - сплошная плоскость - дырку для мотора можно выпилить
    cube ([41, 2, 12 + 2]);
}

module servo_holder() {
    union() {
        // дно
        cube ([14, 36, 2]);

        // повернуть скругленную доску на 90 градусов
        rotate (a=90, v=[1, 0, 0]) rounded_plane();
        // повернуть доску на 90 градусов и сдвинуть в бок
        translate ([0, 36, 0]) rotate (a=90, v=[1, 0, 0]) rounded_plane();
    }

    // скругленная плоскость - доска + цилиндр
    module rounded_plane() {
        union() {
            cube([14, 20 + 2 + 10, 2]);
            translate([7, 20 + 2 + 10, 0]) cylinder(h=2, r=7);
        }
    }
}

module 9g_motor(){
	difference(){			
		union(){
			cube([23,12.5,22], center=true);
			translate([0,0,5]) cube([32,12,2], center=true);
			translate([5.5,0,2.75]) cylinder(r=6, h=25.75, $fn=20, center=true);
			translate([-.5,0,2.75]) cylinder(r=1, h=25.75, $fn=20, center=true);
			translate([-1,0,2.75]) cube([5,5.6,24.5], center=true);		
			translate([5.5,0,3.65]) cylinder(r=2.35, h=29.25, $fn=20, center=true);				
		}
		translate([10,0,-11]) rotate([0,-30,0]) cube([8,13,4], center=true);
		for ( hole = [14,-14] ){
			translate([hole,0,5]) cylinder(r=2.2, h=4, $fn=20, center=true);
		}	
	}
}
