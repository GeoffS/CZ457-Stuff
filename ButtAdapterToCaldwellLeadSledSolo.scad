include <../OpenSCAD_Lib/MakeInclude.scad>
include <CaldwellLeadSledSolo.scad>
include <CZ457American.scad>

adapterBottomY = 3;
adapterZ = 50;

module buttAdapter()
{
	difference()
	{
		// Exterior:
		// tcu([-25, 0, 0], [50, 51+adapterBottomY, adapterZ]);
		hull() translate([0, (51+adapterBottomY)/2, 0]) doubleX() doubleY() tcy([50/2, (51+adapterBottomY)/2, 0], d=6, h=adapterZ);

		// Butt profile:
		hull()
		{
			// End:
			translate([0, endOffsetY, endOffsetZ])
			{
				tcy([0, adapterBottomY+endProfileBottomDia/2, -1], d=endProfileBottomDia, h=1);
				profileSection(endProfileWidthAt30mm, 30);
				profileSection(endProfileWidthAt60mm, 60);
			}

			// Forward:
			translate([0, fwdOffsetY, fwdOffsetZ])
			{
				tcy([0, adapterBottomY + fwdProfileBottomDia/2, -1], d=fwdProfileBottomDia, h=1);
				profileSection(fwdProfileWidthAt30mm, 30);
				profileSection(fwdProfileWidthAt60mm, 60);
			}
		}
	}
}

module profileSection(x, y, thicknessZ=1)
{
	translate([0, adapterBottomY+y, -1]) difference() 
	{
		cylinder(d=x, h=thicknessZ);
		doubleY() tcu([-200, 5, -200], 400);
	}
}

module clip(d=0)
{
	//tc([-200, -400-d, -10], 400);
	tcu([0-d, -200, -200], 400);
}

if(developmentRender)
{
	display() buttAdapter();
}
else
{
	buttAdapter();
}
