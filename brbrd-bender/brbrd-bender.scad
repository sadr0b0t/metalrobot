print_error=0.2;

rail_width=1;

brbrd_bender_socket(print_error=print_error);
//brbrd_bender_plug(print_error=print_error);

module brbrd_bender_socket(print_error=0) {
  translate([0, 0, 3])
    linear_extrude(height=15) import(file="brbrd-bender-socket-43d.dxf");
  
  difference() {
    cube([22, 12+10, 4]);
    
    // паз для рельса
    translate([22/2-rail_width/2-print_error, 4, 2.1]) cube([rail_width+print_error*2, 24, 2]);
  }
}

module brbrd_bender_plug(print_error=0) {
  translate([0, 0, 2])
    linear_extrude(height=15) import(file="brbrd-bender-plug-43d.dxf");
    
  // рельс
  //translate([3.5/2-rail_width/2+print_error, 0, 0]) cube([rail_width-print_error*2, 9, 2]);
  translate([15/2-rail_width/2, 2, 0]) cube([rail_width, 10, 2]);
}



