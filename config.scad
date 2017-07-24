e=0.01*mm;

// high quality etc
is_build = false;

// minimum size of a fragment
// resolution of any round object (segment length)
// Because of this variable very small circles have a smaller number of fragments than specified using $fa.
// The default value is 2.
$fs = is_build ? 0.5 : 1;

// minimum angle for a fragment.
// The default value is 12 (i.e. 30 fragments for a full circle)
$fa = is_build ? 4 : 16;

$show_vit = is_build ? false : true;

// enable preview model (faster openscad)
$preview_mode = is_build ? false : true;
