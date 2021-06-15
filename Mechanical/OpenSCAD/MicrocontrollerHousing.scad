// Microcontroller Housing
//  An enclosure to use with the Microcontroller Expansion Card
//  reference design.
//
//  See https://frame.work for more information about Framework products and
//  additional documentation around Expansion Cards.

// Microcontroller Housing © 2021 by Nirav Patel at Framework Computer Inc
// is licensed under Attribution 4.0 International. 
// To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/

include <ExpansionCard.scad>;

gap = 0.5;
jst_w = 6.0; // JST SH 4-pin receptacle
jst_d = 4.25;
b3u_offset = 5.596+side_wall+pcb_gap;
b3u_w = 3.0; // Omron B3U-3100 button
b3u_pad_w = 4.0;
b3u_h = 1.2;
b3u_d = 2.5;
rib_w = 1;

module microcontroller_housing(make_printable = true) {
    difference() {
        expansion_card_base(open_end = false, make_printable = make_printable, pcb_mount="boss");
        translate([side_wall, 0, pcb_h]) cube([base[0]-side_wall*2, side_wall, base[2]]);
        // Cut out for bottom mount JST SH connector
        translate([base[0]/2-jst_w/2-gap, 0, 0]) cube([jst_w+gap*2, jst_d+gap, base[2]]);
        // Cut out for bottom mount reset switch
        translate([b3u_offset-b3u_w/2-gap, 0, pcb_h-b3u_h-gap]) cube([b3u_w+gap*2, b3u_d+gap, base[2]]);
        translate([b3u_offset-b3u_pad_w/2-gap, 0, pcb_h-gap]) cube([b3u_pad_w+gap*2, b3u_d+gap, base[2]]);
    }

    if (make_printable) {
        // Add ribs for printability
        translate([base[0]/2-jst_w/2-gap-rib_w/2, side_wall, 0]) rib(rib_w, pcb_h);
        translate([base[0]*0.75+jst_w*0.25+gap/2, side_wall, 0]) rib(base[0]/2-jst_w/2-gap, pcb_h);
        translate([b3u_offset-b3u_w/2-gap-rib_w/2, side_wall, 0]) rib(rib_w, pcb_h-gap);
        translate([b3u_offset+b3u_w/2+gap+rib_w/2, side_wall, 0]) rib(rib_w, pcb_h-gap);
        translate([b3u_offset/2-b3u_pad_w/4-gap/2, side_wall, 0]) rib(b3u_offset-b3u_pad_w/2-gap, pcb_h);
        translate([b3u_offset+b3u_pad_w/2+gap+rib_w/2, side_wall, 0]) rib(rib_w, pcb_h);
    }
}

rotate([-90, 0, 0]) translate([0, -base[1], 0]) microcontroller_housing(true);