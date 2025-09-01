include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCAD_Lib/chamferedCylinders.scad>

nominalHoleDia = 12.25;

od = nominalHoleDia + 8;
z = 22;

module itemModule()
{
    difference()
    {
        // Exterior:
	    simpleChamferedCylinderDoubleEnded(d=od, h=z, cz=2);

        // Hole:
        tcy([0,0,2], d=nominalHoleDia, h=100);
        translate([0,0,z-nominalHoleDia/2-0.6]) cylinder(d1=0, d2=20, h=10);
    }
}

module clip(d=0)
{
	tc([-200, -400-d, -10], 400);
}

if(developmentRender)
{
	display() itemModule();
}
else
{
	itemModule();
}
