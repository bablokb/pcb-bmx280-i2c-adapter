// -----------------------------------------------------------------------------
// 3D-Model (OpenSCAD): enclosure for sensor+i2c-adapter.
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/pcb-bmx280-i2c-adapter
// ---------------------------------------------------------------------------

include <dimensions.scad>
include <BOSL2/std.scad>

TEST = true;

// dimensions   ----------------------------------------------------------------

x_pcb   = 20.0;
y_pcb   = 34.0;
z_pcb   = 1.6;
xo_screw = 2.525;
yo_screw = 3.45;
r_screw  = 1.50; 

x_support = 5.60;           // support (for solder joints at the back)
y_support = x_support;
z_support = b + 2.00;

z1_bot  = z_support + z_pcb;        // wall with 4 perimeters from bottom
z2_bot  = z1_bot + 4.5;             // wall with 2 perimeters from bottom
z2_top  = b + 4.5;                  // wall with 2 perimeters from top

yb_sensor = 11.20;                             // distance sensor to bottom
yt_sensor = 10.50;                             // distance sensor to top
y_sensor  = y_pcb - yb_sensor - yt_sensor;

x_stemma = 8;
z_stemma = 3.2;

x_grove = 10;
z_grove = 0;      // TBD

x_case = x_pcb + 2*gap + 2*w4;
y_case = y_pcb + 2*gap + 2*w4;

// --- supports   --------------------------------------------------------------

module supports() {
  x = x_support + w4 + gap;
  y = y_support + w4 + gap;
  x_off = x_case/2-x/2;
  y_off = y_case/2-y/2;
  move([-x_off,-y_off,0]) cuboid([x,y,z_support],anchor=BOTTOM+CENTER);
  move([-x_off,+y_off,0]) cuboid([x,y,z_support],anchor=BOTTOM+CENTER);
  move([+x_off,-y_off,0]) cuboid([x,y,z_support],anchor=BOTTOM+CENTER);
  move([+x_off,+y_off,0]) cuboid([x,y,z_support],anchor=BOTTOM+CENTER);
}

// --- screws   ----------------------------------------------------------------

module screws() {
  x_off = x_pcb/2-xo_screw;
  y_off = y_pcb/2-yo_screw;
  r     = r_screw - 2*gap;
  move([-x_off,-y_off,z_support-fuzz]) cyl(r=r,h=z_pcb,anchor=BOTTOM+CENTER);
  move([-x_off,+y_off,z_support-fuzz]) cyl(r=r,h=z_pcb,anchor=BOTTOM+CENTER);
  move([+x_off,-y_off,z_support-fuzz]) cyl(r=r,h=z_pcb,anchor=BOTTOM+CENTER);
  move([+x_off,+y_off,z_support-fuzz]) cyl(r=r,h=z_pcb,anchor=BOTTOM+CENTER);
}

// --- bottom part   -----------------------------------------------------------

module bottom() {
  difference() {
    union() {
      // base plate
      cuboid([x_case,y_case,b],anchor=BOTTOM+CENTER);
      // suport and screws
      supports();
      screws();
      // walls around sensor
      rect_tube(size=[x_case,y_case],wall=w4,h=z1_bot,anchor=BOTTOM+CENTER);
      rect_tube(size=[x_case,y_case],wall=w2,h=z2_bot,anchor=BOTTOM+CENTER);
    }
    // cutouts Stemma
    move([0,-y_case/2+w4/2,b])
                 cuboid([x_stemma,2*w4,z2_bot-b+fuzz],anchor=BOTTOM+CENTER);
    move([0,+y_case/2-w4/2,b])
                 cuboid([x_stemma,2*w4,z2_bot-b+fuzz],anchor=BOTTOM+CENTER);
  }
}

// --- top part   --------------------------------------------------------------

module top() {
  difference() {
    union() {
      // base plate
      cuboid([x_case,y_case,b],anchor=BOTTOM+CENTER);
      // walls around sensor
      rect_tube(size=[x_case-2*w2,y_case-2*w2],
                wall=w2,h=z2_top,anchor=BOTTOM+CENTER);
      rect_tube(size=[x_case-4*w2,y_case-4*w2],
                wall=w2,h=z2_top+z_pcb,anchor=BOTTOM+CENTER);
    }
    // cutouts Stemma
    move([0,-y_case/2+w4/2,b])
          cuboid([x_stemma,3*w4,z2_top+z_pcb-b+fuzz],anchor=BOTTOM+CENTER);
    move([0,+y_case/2-w4/2,b])
          cuboid([x_stemma,3*w4,z2_top+z_pcb-b+fuzz],anchor=BOTTOM+CENTER);
    // cutouts ventilation
    move([0,0,-fuzz]) cuboid([x_pcb/2,w4,b+2*fuzz],anchor=BOTTOM+CENTER);
    move([0,3*w4,-fuzz]) cuboid([x_pcb/2,w4,b+2*fuzz],anchor=BOTTOM+CENTER);
    move([0,-3*w4,-fuzz]) cuboid([x_pcb/2,w4,b+2*fuzz],anchor=BOTTOM+CENTER);
  }
}

// --- top-level object   ----------------------------------------------------

//bottom();
top();
