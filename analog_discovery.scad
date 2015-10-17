$fn = 20;
digilent_l = 79;
digilent_w = 63.2;
digilent_h = 20.6;

adapter_l = 60.1;
adapter_w = 60.5;
adapter_h = 24.5;

wall_thickness = 3;

radius = 3;

module vent() {
	rotate([0,90,0]) {
		hull() {
			cylinder(r=1.1, h=wall_thickness*2 + 1, center=true);
			translate([10, 0, 0]) cylinder(r=1.1, h=wall_thickness*2 + 1, center=true);
		}
	}
}

// Trapezoid for usb connector support
module trapezoid(width_base, width_top,height,thickness) {
  linear_extrude(height = thickness) polygon(points=[[0,0],[width_base,0],[width_base-(width_base-width_top)/2,height],[(width_base-width_top)/2,height]], paths=[[0,1,2,3]]); 
}

module lid(l1, l2, w1, w2, h1, h2, t, r) {
	difference() {
		union() {
			translate([(digilent_l/2 - wall_thickness - radius),0,0]) {
				difference(){
					cube([(l1 + r*2 + t*2 + 1),
						(w1 + r*2 + t*2 + 1),
						(h1/3 + 1)], true);
					translate([0,0,t-6]) {
						cube([l1+r*2+t+1, w1+r*2+t+1, h1/3], true);
					}
				}
			}
			translate([-(digilent_l+radius)/2,0, 0]) {
				difference(){
					cube([(l2 + t*2 + 1),
						(w2 + t*2 + 1),
						(h1/3 + 1)], true);
					translate([0,0,t-6]) {
						cube([l2+t+1, w2+t+1, h1/3], true);
					}
				}
			}
		}
		translate([(l2-l1)/2+t/2-0.05, 0, -t+0.43]) {
			cube([t*2, w2+r+t*2, 2*t], true);
		}
		translate([(l2-l1)/2+t/2-3, 0, -t+0.43]) {
			cube([t*2, w2 + t + 1, 2*t], true);
		}
	}
}

module discovery(l, w, h, thickness, radius) {
	difference(){
		cube([(l + radius*2 + thickness),
			(w + radius*2 + thickness),
			(h + thickness)], true);
		translate([0,0,thickness-3])minkowski() {
			cube([l, w, h], true);
			cylinder(r=radius, h=26);
		}
		// Hole for USB
		translate([(digilent_l/2 + thickness/2 + radius),-19,0]) {
			cube([thickness*2 + 1,13, 9], true);
		}
		// Hole for 3.5mm jack
		translate([(digilent_l/2 + thickness/2 + radius),22,1]) {
			rotate([0,90,0]) cylinder(r=4, h=(thickness*2 + 1), center=true);
		}
		// Holes for vents
		translate([(digilent_l/2 + thickness/2 + radius), -5, 5]) vent();
		translate([(digilent_l/2 + thickness/2 + radius), 0, 5]) vent();
		translate([(digilent_l/2 + thickness/2 + radius), 5, 5]) vent();
		translate([(digilent_l/2 + thickness/2 + radius), 10, 5]) vent();
		translate([(digilent_l/2 + thickness/2 + radius), 15, 5]) vent();
	}

	// USB connector support
	translate([(digilent_l/2 + thickness/2 + radius), -8, -10]) rotate([0,0,-90]) trapezoid(22, 15, 20, 5);

	// Hooks for lid
	translate([(digilent_l/2 + thickness + radius + 2), -28.5, -8.5]) {
		rotate([75,0,9.9]) {
			linear_extrude(height=1) square([10,3], center=true);
		}
	}
	translate([(digilent_l/2 + thickness + radius + 2), -9.5, -8.5]) {
		rotate([-75,0,-9.9]) {
			linear_extrude(height=1) square([10,3], center=true);
		}
	}
}

module adapter(l, w, h1, h2, thickness) {
	bnc_spread = 21.5/2;
	bnc_height=19;
	bnc_radius=6.8;
	peg_x_offset=25.5;
	peg_y_offset=25.5;
	difference(){
		cube([(l + thickness),
			(w + thickness),
			(h1 + thickness)], true);

		// thickness-2 is used because prints were too thick on the bottom.
		translate([0,0,thickness-2]) {
			cube([l, w, h1+2], true);
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
		translate([-(adapter_l/2),0,6.3]) {
			cube([10,39,15], true);
		}
	}
	// Pegs to replace the headers originally on the adapter for placement
	translate([(peg_x_offset),(peg_y_offset), -digilent_h/2]) {
		cylinder(r=1.2, h=adapter_h/2, $fn=7);
		cylinder(r=2.5, h=(adapter_h/2 - 3), $fn=7);
	}
	translate([-(peg_x_offset),(peg_y_offset), -digilent_h/2]) {
		cylinder(r=1.2, h=adapter_h/2, $fn=7);
		cylinder(r=2.5, h=(adapter_h/2 - 3), $fn=7);
	}
	translate([(peg_x_offset),-(peg_y_offset), -digilent_h/2]) {
		cylinder(r=1.2, h=(adapter_h/2 - 1.5), $fn=7);
		cylinder(r=2.5, h=(adapter_h/2 - 4.5), $fn=7);
	}
	translate([-(peg_x_offset),-(peg_y_offset), -digilent_h/2]) {
		cylinder(r=1.2, h=adapter_h/2, $fn=7);
		cylinder(r=2.5, h=(adapter_h/2 - 3), $fn=7);
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
		cube([wall_thickness*2, adapter_w-radius+wall_thickness, adapter_h+4], true);
	}
}

// The lid
lid_l1 = digilent_l;
lid_l2 = adapter_l;
lid_h1 = digilent_h;
lid_h2 = 2;
lid_w1 = digilent_w;
lid_w2 = adapter_w;

translate([0,0,30]) lid(lid_l1, lid_l2, lid_w1, lid_w2, lid_h1, lid_h2, wall_thickness, radius);
