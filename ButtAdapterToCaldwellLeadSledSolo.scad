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
		leadSledButt();
		
		// Butt profile:
		hull()
		{
			// End:
			translate([0, endOffsetY, endOffsetZ])
			{
				// %tcy([0, adapterBottomY + endProfileBottomDia/2, -1], d=2, h=100);
				tcy([0, adapterBottomY + endProfileBottomDia/2, -1], d=endProfileBottomDia, h=1);
				profileSection(endProfileWidthAt30mm, 29, dia=65, thicknessY=30);
				profileSection(endProfileWidthAt60mm, 60, dia=65, thicknessY=30);
			}

			// Forward:
			translate([0, fwdOffsetY, fwdOffsetZ])
			{
				tcy([0, adapterBottomY + fwdProfileBottomDia/2, -1], d=fwdProfileBottomDia, h=1);
				profileSection(fwdProfileWidthAt30mm, 29, dia=70, thicknessY=40);
				profileSection(fwdProfileWidthAt60mm, 60, dia=60, thicknessY=30);
			}
		}
	}
}

module leadSledButt()
{
	// hull() translate([0, (51+adapterBottomY)/2, 0]) doubleX() doubleY() tcy([50/2, (51+adapterBottomY)/2, 0], d=6, h=adapterZ);
	difference()
	{
		hull()
		{
			tcy([0,buttBottomDia/2,0], d=buttBottomDia, h=adapterZ);
			tcy([0,buttBottomDia/2+30,0], d=buttWidthAt30mm, h=adapterZ);
			tcy([0,buttBottomDia/2+50,0], d=buttWidthAt50mm, h=adapterZ);
		}
		tcu([-200, 60, -200], 400);
	}
}

module profileSection(x, y, dia=100, thicknessZ=1, thicknessY=10)
{
	translate([0, adapterBottomY+y, -0.8]) difference() 
	{
		doubleX() difference()
		{
			tcy([x/2-dia/2, 0, 0], d=dia, h=thicknessZ);
			// %tcy([0, 0, 0], d=1, h=100);
			tcu([-400, -200, -200], 400);
		}
		doubleY() tcu([-200, thicknessY/2, -200], 400);
	}
}

module clip(d=0)
{
	//tc([-200, -400-d, -10], 400);
	// tcu([0-d, -200, -200], 400);
}

if(developmentRender)
{
	display() buttAdapter();
}
else
{
	rotate([0,180,0]) buttAdapter();
}
