module fillet(r, h) {
	translate([r / 2, r / 2, 0])

		difference() {
			cube([r + 0.01, r + 0.01, h], center = true);

			translate([r/2, r/2, 0])
				cylinder(r = r, h = h + 1, center = true);

		}
}

digilent_l = 84;
digilent_w = 68.2;
digilent_h = 20.6;

adapter_l = 60.2;
adapter_w = 59.5;
adapter_h = 24.5;

wall_thickness = 2;

radius = 3;

module discovery(l, w, h, thickness, radius) {
		difference(){
			cube([(l + radius*2 + thickness),
				(w + radius*2 + thickness),
				(h + thickness)], true);
			translate([0,0,thickness])minkowski() {
				cube([l, w, h], true);
				cylinder(r=radius, h=26);
			}
		}
}

module adapter(l, w, h1, h2, thickness) {
	bnc_spread = 21.5/2;
	bnc_height=19;
	bnc_radius=6;
	peg_x_offset=7;
	peg_y_offset=7;
	difference(){
		cube([(l + thickness),
			(w + thickness),
			(h1 + thickness)], true);

		translate([0,0,thickness]) {
			cube([l, w, h1], true);
		}

		// Holes for BNC connectors
		hull(){
			translate([bnc_spread, w/2, bnc_radius]){
				rotate([90,0,0])cylinder(r=bnc_radius, h=thickness+1, center=true);
			}
			translate([bnc_spread, w/2, bnc_radius*2]) {
				   rotate([90,0,0])cylinder(r=bnc_radius, h=thickness+1, center=true);
			}
		}
		hull(){
			translate([-bnc_spread, w/2, bnc_radius]){
				rotate([90,0,0])cylinder(r=bnc_radius, h=thickness+1, center=true);
			}
			translate([-bnc_spread, w/2, bnc_radius*2]){
				rotate([90,0,0])cylinder(r=bnc_radius, h=thickness+1, center=true);
			}
		}
		hull(){
			translate([bnc_spread, -w/2, bnc_radius]){
				rotate([90,0,0])cylinder(r=bnc_radius, h=thickness+1, center=true);
			}
			translate([bnc_spread, -w/2, bnc_radius*2]){
				rotate([90,0,0])cylinder(r=bnc_radius, h=thickness+1, center=true);
			}
		}
		hull(){
			translate([-bnc_spread, -w/2, bnc_radius]){
				rotate([90,0,0])cylinder(r=bnc_radius, h=thickness+1, center=true);
			}
			translate([-bnc_spread, -w/2, bnc_radius*2]){
				rotate([90,0,0])cylinder(r=bnc_radius, h=thickness+1, center=true);
			}
		}
	}
	// Pegs to replace the headers originally on the adapter for placement
	translate([(adapter_l/2 - peg_x_offset),(adapter_w/2 - peg_y_offset), -digilent_h/2]) {
		cylinder(r=1.25, h=adapter_h/2);
		cylinder(r=2, h=(adapter_h/2 - 2));
	}
	translate([-(adapter_l/2 - peg_x_offset),(adapter_w/2 - peg_y_offset), -digilent_h/2]) {
		cylinder(r=1.25, h=adapter_h/2);
		cylinder(r=2, h=(adapter_h/2 - 2));
	}
	translate([(adapter_l/2 - peg_x_offset),-(adapter_w/2 - peg_y_offset), -digilent_h/2]) {
		cylinder(r=1.25, h=adapter_h/2);
		cylinder(r=2, h=(adapter_h/2 - 2));
	}
	translate([-(adapter_l/2 - peg_x_offset),-(adapter_w/2 - peg_y_offset), -digilent_h/2]) {
		cylinder(r=1.25, h=adapter_h/2);
		cylinder(r=2, h=(adapter_h/2 - 2));
	}
}

//Remove wall between both sections of the case.
difference(){
	union(){
		translate([(adapter_l + radius + wall_thickness)/2, 0, 0]) {
			discovery(digilent_l, digilent_w, digilent_h, wall_thickness, radius);
		}

		translate([-(digilent_l + radius)/2, 0,0]) {
			adapter(adapter_l, adapter_w, digilent_h, adapter_h, wall_thickness);
		}
	}
	translate([(adapter_l-digilent_l)/2, 0, wall_thickness*2]) {
		cube([wall_thickness*2, adapter_l-radius+wall_thickness, adapter_h], true);
	}
}
