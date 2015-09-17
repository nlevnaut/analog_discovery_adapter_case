digilent_l = 84;
digilent_w = 68.2;
digilent_h = 20.6;

adapter_l = 60.2;
adapter_w = 59.5;
adapter_h = 24.5;

wall_thickness = 2;

radius = 3;

module vent() {
	rotate([0,90,0]) {
		hull() {
			cylinder(r=1.1, h=wall_thickness*2 + 1, center=true);
			translate([10, 0, 0]) cylinder(r=1.1, h=wall_thickness*2 + 1, center=true);
		}
	}
}

module discovery(l, w, h, thickness, radius) {
		difference(){
			cube([(l + radius*2 + thickness),
				(w + radius*2 + thickness),
				(h + thickness)], true);
			translate([0,0,thickness])minkowski() {
				cube([l, w, h], true);
				cylinder(r=radius, h=26);
			}
			// Hole for USB
			translate([(digilent_l/2 + thickness/2 + radius),-19,-1.25]) {
				cube([thickness*2 + 1,12.5, 7.5], true);
			}
			// Hole for 3.5mm jack
			translate([(digilent_l/2 + thickness/2 + radius),20,0]) {
				rotate([0,90,0]) cylinder(r=3.5, h=(thickness*2 + 1), center=true);
			}
			// Holes for vents
			translate([(digilent_l/2 + thickness/2 + radius),-10, 5]) vent();
			translate([(digilent_l/2 + thickness/2 + radius),-6, 5]) vent();
			translate([(digilent_l/2 + thickness/2 + radius), -2, 5]) vent();
			translate([(digilent_l/2 + thickness/2 + radius), 2, 5]) vent();
			translate([(digilent_l/2 + thickness/2 + radius), 6, 5]) vent();
			translate([(digilent_l/2 + thickness/2 + radius), 10, 5]) vent();
			translate([(digilent_l/2 + thickness/2 + radius), 14, 5]) vent();
		}
}

module adapter(l, w, h1, h2, thickness) {
	bnc_spread = 21.5/2;
	bnc_height=19;
	bnc_radius=6;
	peg_x_offset=25;
	peg_y_offset=25;
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

		// Hole for header
		translate([-(adapter_l/2),0,1.5]) {
			cube([10,39,5], true);
		}
	}
	// Pegs to replace the headers originally on the adapter for placement
	translate([(peg_x_offset),(peg_y_offset), -digilent_h/2]) {
		cylinder(r=1.5, h=adapter_h/2);
		cylinder(r=2, h=(adapter_h/2 - 3));
	}
	translate([-(peg_x_offset),(peg_y_offset), -digilent_h/2]) {
		cylinder(r=1.5, h=adapter_h/2);
		cylinder(r=2, h=(adapter_h/2 - 3));
	}
	translate([(peg_x_offset),-(peg_y_offset), -digilent_h/2]) {
		cylinder(r=1.5, h=adapter_h/2);
		cylinder(r=2, h=(adapter_h/2 - 3));
	}
	translate([-(peg_x_offset),-(peg_y_offset), -digilent_h/2]) {
		cylinder(r=1.5, h=adapter_h/2);
		cylinder(r=2, h=(adapter_h/2 - 3));
	}
}

// Remove wall between both sections of the case.
difference(){
	// Main compartments of the case.
	union(){
		translate([(adapter_l + radius + wall_thickness)/2, 0, 0]) {
			discovery(digilent_l, digilent_w, digilent_h, wall_thickness, radius);
		}

		translate([-(digilent_l + radius)/2, 0,0]) {
			adapter(adapter_l, adapter_w, digilent_h, adapter_h, wall_thickness);
		}
	}

	// Wall segment to remove
	translate([(adapter_l-digilent_l)/2, 0, wall_thickness*2]) {
		cube([wall_thickness*2, adapter_l-radius+wall_thickness, adapter_h], true);
	}
}
