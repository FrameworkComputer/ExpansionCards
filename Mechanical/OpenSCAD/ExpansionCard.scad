// Parametric Expansion Card
//  An OpenSCAD implementation of a basic enclosure of an Expansion Card for
//  use with Framework products like the Framework Laptop.
//
//  See https://frame.work for more information about Framework products and
//  additional documentation around Expansion Cards.

// Parametric Expansion Card © 2021 by Nirav Patel at Framework Computer LLC
// is licensed under Attribution 4.0 International. 
// To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/

// The basic dimensions of an Expansion Card
base = [30.0, 32.0, 6.8];
// The default wall thickness
side_wall = 1.5;

// Size and location of the typical PCB
pcb_gap = 0.5;
pcb = [26.0, 30.0, 0.8];
pcb_h = 3.05;

// USB-C plug dimensions
usb_c_r = 1.315;
usb_c_w = 5.86+usb_c_r*2;
usb_c_h = 2.2;

rail_h = 4.25; // to top of rail

// Boss locations matching the other Framework Expansion Cards
boss_y = 10.5;
boss_x = 3.7;

// The rail cutout in the sides of the card
module rail(make_printable) {
    rail_depth = 0.81;
    rail_flat_h = 0.32;
    
    mirror([0, 1, 0]) {
        
        // The rail that holds the card
        bottom_angle = 43.54;
        difference() {
            union() {
                translate([rail_depth, 0, -rail_flat_h]) rotate([0, 180+bottom_angle, 0]) cube([2, base[1]-side_wall, 2]);
                translate([-2+rail_depth, 0, -rail_flat_h]) cube([2, base[1]-side_wall, rail_flat_h]);
            }
            translate([-5+rail_depth, 0, 0]) cube([5, base[1]-side_wall, 5]);
        }
    
        pyramid_b = 3.23*sqrt(2);
        pyramid_t = 1.75*sqrt(2);
        pyramid_h = 1.0;
        pyramid_inset = 1.3+0.5;
        pyramid_step = 3.06;
        
        // The ramps to make slotting into the latch smooth
        translate([-1.75/2+pyramid_inset, 0, -1.75/2]) rotate([-90, 0, 0]) rotate([0, 0, 45]) { 
            cylinder(r1 = pyramid_b/2, r2 = pyramid_t/2, h = pyramid_h, $fn=4);
            cylinder(r = pyramid_t/2, h = pyramid_step+pyramid_h, $fn=4);
            translate([-0.1, 0.1, 0])cylinder(r = pyramid_t/2, h = pyramid_step+pyramid_h, $fn=4);
        }
        
        latch_l = 2.67;
        latch_d = pyramid_inset;
        latch_h = 2.85;
        latch_wall = 1.39;
        
        // The pocket that the latch bar drops into, including a 45 degree cut for printability
        translate([0, latch_wall, -latch_h]) cube([latch_d, latch_l, latch_h]);
        if (make_printable) {
            translate([latch_d, latch_wall+latch_l, -latch_h]) rotate([0, 0, -180+45]) translate([0, -latch_l, 0]) cube([latch_d*2, latch_l, latch_h]);
        }
    }
}

// A simple 45 degree rib to improve printability
module rib(thickness, height) {
    translate([-thickness/2, 0, 0]) difference() {
        cube([thickness, height, height]);
        translate([-thickness/2, height, 0]) rotate([45, 0, 0]) cube([thickness*2, height*2, height*2]);
    }
}

// A simple cylinder cutout to fillet edges
module fillet(radius, length) {
    translate([length, 0, 0]) rotate([0, -90, 0]) difference() {
        cube([radius, radius, length]);
        translate([radius, radius, -1]) cylinder(h = length+2, r = radius, $fn = 64);
    }
}

// The cutout for the USB-C plug
module usb_c_cutout(open_top) {
    // The plug is "pushed in" by an extra 0.6 to account for 3d printing tolerances
    translate([-usb_c_w/2+usb_c_r, 7-10+0.6, usb_c_r]) rotate([-90, 0, 0]) union() {
        translate([0, usb_c_r, 0]) cylinder(r = usb_c_r, h = 10, $fn = 64);
        translate([usb_c_w-usb_c_r*2, usb_c_r, 0]) cylinder(r = usb_c_r, h = 10, $fn = 64);
        cube([usb_c_w-usb_c_r*2, usb_c_r*2, 10]);
        
        // Cutout for the pin side of the shell that expands out
        translate([0, usb_c_r, 0]) cylinder(r2 = usb_c_r, r1 = 3.84/2, h = 10-7.7, $fn = 64);
        translate([usb_c_w-usb_c_r*2, usb_c_r, 0]) cylinder(r2 = usb_c_r, r1 = 3.84/2, h = 10-7.7, $fn = 64);
        translate([usb_c_w/2-usb_c_r, usb_c_r, 0]) scale([1.8, 1, 1]) rotate([0, 0, 45]) cylinder(r2 = usb_c_r*sqrt(2), r1 = 3.84/2*sqrt(2), h = 10-7.7, $fn = 4);
        
        // If the card drops in from the top rather than sliding in from the front,
        // cut out a slot for the USB-C plug to drop into.
        if (open_top) {
            translate([-usb_c_r, -10+usb_c_r, 0]) cube([usb_c_w, 10, 10]);
        }
    }
}

// Quarter section of a sphere, used as a clip
module qsphere(radius = 1) {
    difference() {
        sphere(r = radius, $fn = 32);
        translate([-radius-1, -radius-1, -radius]) cube([radius*2+2, radius*2+2, radius]);
        translate([0, -radius-1, -radius-1]) cube([radius, radius*2+2, radius*2+2]);
    }
}

// The screw boss for the PCB, optionally with space for a threaded insert
module boss(radius, use_insert, make_printable) {
    difference() {
        cylinder(r = radius, h = pcb_h, $fn = 64);
        if (use_insert) {
            // Use threaded insert
            translate([0, 0, side_wall]) cylinder(r = 1.5, h = pcb_h, $fn = 64);
        } else {
            translate([0, 0, side_wall]) cylinder(r = 0.75, h = pcb_h, $fn = 64);
        }
    }
    
    // Add a rib for printability
    if (make_printable) {
        translate([0, radius-0.1, 0]) rib(1, pcb_h);
    }
}

// Incomplete implementation of a lid to use with this shell
module expansion_card_lid() {
    gap = 0.25;
    union() {
        translate([side_wall+gap, side_wall+gap, base[2]-side_wall]) cube([base[0]-side_wall*2-gap*2, base[1]-side_wall*2-gap*2, side_wall]);
        difference() {
            translate([base[0]/2-usb_c_w/2+gap, base[1]-side_wall-gap, usb_c_r+usb_c_h]) cube([usb_c_w-gap*2, side_wall+gap, base[2]-(usb_c_r+usb_c_h)]);
            translate([base[0]/2, base[1], usb_c_r+usb_c_h]) usb_c_cutout(false);
        }
    }
}

// A basic, printable Expansion Card enclosure
//  open_end - A boolean to make the end of the card that is exposed when inserted open
//  make_printable - Adds ribs to improve printability
//  pcb_mount - The method the PCB is held in with, "boss" for self-threading screws,
//            "boss_insert" for fastener with a threaded insert,
//            "clip" for a fastener-less clip, or
//            "" for no PCB mounting structure
module expansion_card_base(open_end, make_printable, pcb_mount="boss") {
    // Hollowing of the inside
    extra = 0.1;
    inner = [base[0]-side_wall*2, base[1]-side_wall*2, base[2]-side_wall+extra];
    boss_radius = 2.3;
    
    difference() {
        cube(base);
        
        difference() {
            notch = 1.0;
            notch_l = 3.0;
            notch_h = 3.8;
            // The main hollow
            translate([side_wall, open_end ? 0 : side_wall, side_wall]) cube([inner[0], open_end ? inner[1]+side_wall : inner[1], inner[2]]);
            // Extra wall thickness where the latch cutouts are
            translate([side_wall, inner[1]+side_wall-notch_l, side_wall+notch_h/2]) rotate([0, 0, -90]) rotate([0, 90, 0]) rib(notch_h, notch);
            translate([side_wall, inner[1]+side_wall-notch_l, side_wall]) cube([notch, notch_l, notch_h]);
            translate([inner[0]+side_wall, inner[1]+side_wall-notch_l, side_wall+notch_h/2]) rotate([0, 0, 180]) rotate([0, 90, 0]) rib(notch_h, notch);
            translate([inner[0]+side_wall-notch, inner[1]+side_wall-notch_l, side_wall]) cube([notch, notch_l, notch_h]);
        }
        
        // The rounded front edge to match the laptop
        edge_r = 0.8;
        fillet(edge_r, base[0]);
        
        // The USB-C plug cutout
        translate([base[0]/2, base[1], usb_c_r+usb_c_h]) usb_c_cutout(!open_end);
        
        // The sliding rails
        translate([0, base[1], rail_h]) rail(make_printable);
        translate([base[0], base[1], rail_h]) mirror([1, 0, 0]) rail(make_printable);
        
        // Cut out the end of what is normally the aluminum cover
        ledge_cut = 0.6;
        ledge_cut_d = 3.2;
        ledge_fillet_r = 0.3;
        
        translate([0, base[1]-ledge_cut_d, 0]) cube([base[0], ledge_cut_d, ledge_cut]);
        // The fillet on that cover
        translate([base[0], base[1]-ledge_cut_d, 0]) rotate([0, 0, 180]) fillet(ledge_cut/2, base[0]);
    }
    
    if (pcb_mount == "boss" || pcb_mount == "boss_insert") {        
        // Add the screw bosses
        translate([boss_x, boss_y, 0]) boss(boss_radius, pcb_mount == "boss_insert", make_printable);
        translate([base[0]-boss_x, boss_y, 0]) boss(boss_radius, pcb_mount == "boss_insert", make_printable);
    } else if (pcb_mount == "clip") {
        clip_w = 1.5;
        clip_gap = 0.5;
        translate([boss_x-boss_radius, boss_y-boss_radius, 0]) {
            cube([boss_radius*2, boss_radius*2, pcb_h]);
            if (make_printable)
                translate([boss_radius, boss_radius*2, 0]) rib(boss_radius*2, pcb_h);
            translate([0, boss_radius-clip_w, pcb_h+pcb[2]+clip_gap]) rotate([0, 0, 180]) qsphere(clip_w);
        }
        translate([base[0]-boss_x-boss_radius, boss_y-boss_radius, 0]) {
            cube([boss_radius*2, boss_radius*2, pcb_h]);
            if (make_printable)
                translate([boss_radius, boss_radius*2, 0]) rib(boss_radius*2, pcb_h);
            translate([boss_radius*2, boss_radius-clip_w, pcb_h+pcb[2]+clip_gap]) qsphere(clip_w);
        }
    }
}

// Rotate into a printable orientation
rotate([-90, 0, 0]) translate([0, -base[1], 0]) expansion_card_base(open_end = true, make_printable = true, pcb_mount="");
