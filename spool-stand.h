include <thing_libutils/units.scad>;
include <thing_libutils/system.scad>;
include <thing_libutils/bearing_data.scad>;
include <config.scad>;

spool_stand_bearing = bearing_608;

spool_stand_legs_dia = 16*mm;
spool_stand_legs_dia_extra = 3*mm;
spool_stand_h = 220/2 + 10*mm;
spool_stand_angle = 60;

spool_stand_w = 150*mm;

spool_stand_tube_shorten = spool_stand_legs_dia+15*mm;
spool_stand_tube_shorten_upper = spool_stand_legs_dia+20*mm;
spool_stand_tube_overlap = 30*mm;
spool_stand_tube_tolerance = .3*mm;

spool_stand_rod_d = 8*mm;
