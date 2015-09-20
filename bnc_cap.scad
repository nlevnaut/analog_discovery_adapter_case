// BNC dust cap

height  = 12;
outer_d = 14.5;
inner_d = 11;
base_h  = 0.8;

$fn=300;

difference() {
	cylinder(h=height, d=outer_d, center=true);
	cylinder(h=height+1, d=inner_d, center=true);
	linear_extrude(height=height+1, center=true, twist=-90){
		square([2.5, inner_d + 2], center=true);
	}
}

// base
translate([0,0, -height/2 - base_h/2])
cylinder(h=base_h, d=outer_d, center=true);
