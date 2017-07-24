include <spool-stand.h>;

include <thing_libutils/bearing_data.scad>;
include <thing_libutils/materials.scad>
include <thing_libutils/transforms.scad>;
include <thing_libutils/shapes.scad>;

module filament_spool(part)
{
    // http://thrinter.com/empty-spool-weights/
    spool_d_inner = 19*mm;
    spool_d_core = 100*mm;
    spool_d_outer = 205*mm;

    spool_w = 93*mm;

    if(part==undef)
    {
        difference()
        {
            filament_spool(part="pos");
            filament_spool(part="neg");
        }
    }
    else if(part=="pos")
    {
        tz(spool_stand_h)
        {
            // side walls
            for(x=[-1,1])
            tx(x*spool_w/2)
            cylindera(d=spool_d_outer, h=2*mm, orient=X, align=-x*X);
            // core
            cylindera(d=spool_d_core, h=spool_w, orient=X);
        }
    }
    else if(part=="neg")
    {
        tz(spool_stand_h)
        cylindera(d=spool_d_inner, h=spool_w+5, orient=X);
    }
}

module spool_rods(a=60, h, d, w, h, extend_w)
{
    assert(d!=undef);
    assert(w!=undef);
    assert(h!=undef);

    leg_adj =  1/sin(a) * h;
    leg_hyp =  1/cos(a) * leg_adj/2;

    // rods to connect triangles
    for(y=[-1,1])
    ty(y*leg_adj/2)
    cylindera(d=d, h=w+(extend_w?1000*mm:0), extra_h=-spool_stand_tube_shorten, orient=X);

    // side triangles lower legs
    for(x=[-1,1])
    tx(x*w/2*mm)
    cylindera(d=d, h=leg_adj, extra_h=-spool_stand_tube_shorten, orient=Y, align=N);

    // side triangles uprights
    for(x=[-1,1])
    for(y=[-1,1])
    tx(x*w/2*mm)
    ty(y*leg_adj/2)
    ry(y*(90-a))
    cylindera(d=d, h=leg_hyp, extra_h=-spool_stand_tube_shorten_upper, orient=Z, align=Z);
}

module triangle_connector_lower(part, x, y)
{
    a=spool_stand_angle;
    h=spool_stand_h;
    d=spool_stand_legs_dia+5*mm;
    w=spool_stand_w;

    assert(d!=undef);
    assert(w!=undef);
    assert(h!=undef);
    assert(x!=undef);
    assert(y!=undef);

    leg_adj =  1/sin(a) * h;
    leg_hyp =  1/cos(a) * leg_adj/2;

    if(part==undef)
    {
        difference()
        {
            hull()
            {
                triangle_connector_lower(part="pos", x=x, y=y);
            }
            triangle_connector_lower(part="neg", x=x, y=y);
        }
    }
    else if(part=="pos")
    {
        material(Mat_Plastic)
        tx(x*w/2)
        ty(y*leg_adj/2)
        {
            // rods to connect side triangles
            rcylindera(d=d+spool_stand_legs_dia_extra, h=spool_stand_tube_overlap, orient=X, align=-x*X);

            // rods to connect triangle
            rcylindera(d=d+spool_stand_legs_dia_extra, h=spool_stand_tube_overlap, orient=Y, align=-y*Y);

            // side triangles uprights
            ry(y*(90-a))
            tz(spool_stand_tube_shorten_upper)
            rcylindera(d=d, h=spool_stand_tube_overlap, orient=Z, align=-Z);
        }

    }
    else if(part=="neg")
    {
        spool_rods(a=spool_stand_angle, h=spool_stand_h, d=spool_stand_legs_dia+spool_stand_tube_tolerance, w=spool_stand_w, extend_w=true);
    }
}

module triangle_connector_upper(part)
{
    a=spool_stand_angle;
    h=spool_stand_h;
    d=spool_stand_legs_dia+5*mm;
    w=spool_stand_w;

    leg_adj =  1/sin(a) * h;
    leg_hyp =  1/cos(a) * leg_adj/2;

    if(part==undef)
    {
        difference()
        {
            hull()
            {
                triangle_connector_upper(part="pos");
            }
            triangle_connector_upper(part="neg");
        }
    }
    else if(part=="pos")
    material(Mat_Plastic)
    {
        // side triangles uprights
        for(y=[-1,1])
        tx(w/2)
        tz(h)
        ry(y*(90-a))
        rcylindera(d=d, h=spool_stand_tube_overlap, orient=Z, align=-Z);

    }
    else if(part=="neg")
    {
        tz(h)
        hull()
        stack(dist=100, axis=Z)
        {
            cylindera(d=spool_stand_rod_d, h=spool_stand_w+40*mm, orient=X);
            cylindera(d=spool_stand_rod_d, h=spool_stand_w+40*mm, orient=X);
        }

        spool_rods(a=spool_stand_angle, h=spool_stand_h, d=spool_stand_legs_dia+spool_stand_tube_tolerance, w=spool_stand_w, extend_w=true);
    }
}

module part_triangle_connector_lower_A()
{
    triangle_connector_lower(x=1, y=-1);
}

module part_triangle_connector_lower_B()
{
    triangle_connector_lower(x=-1, y=-1);
}

module part_triangle_connector_lower_C()
{
    triangle_connector_lower(x=-1, y=1);
}

module part_triangle_connector_lower_D()
{
    triangle_connector_lower(x=1, y=1);
}

module part_triangle_connector_upper_A()
{
    triangle_connector_upper();
}

module part_triangle_connector_upper_B()
{
    mirror([1,0,0])
    triangle_connector_upper();
}

/*module preview()*/
{
    for(x=[-1,1])
    {
        for(y=[-1,1])
        triangle_connector_lower(x=x, y=y);

        mirror(X+x*X)
        triangle_connector_upper();
    }

    // spool rod
    tz(spool_stand_h)
    cylindera(d=spool_stand_rod_d, h=spool_stand_w+40*mm, orient=X);

    %spool_rods(a=spool_stand_angle, h=spool_stand_h, d=spool_stand_legs_dia, w=spool_stand_w);

    %filament_spool();
}

