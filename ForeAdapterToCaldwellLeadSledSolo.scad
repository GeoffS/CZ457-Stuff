include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCAD_Lib/chamferedCylinders.scad>
include <CaldwellLeadSledSolo.scad>
include <CZ457American.scad>

adapterBottomY = 3;
adapterZ = 10; //forwardSupportLength;

module leadSledFwdAdapter()
{
	difference()
	{
		// Exterior:
		leadSledFwdHolder();
		
		// Fore-grip profile:
		hull()
		{
			translate([0, 0, -1])
			{
				// Bottom:
				doubleX() tcy(
					[
						foregripProfileBottomWidth/2-foregripProfileBottomDia/2, 
						adapterBottomY+foregripProfileBottomDia/2, 
						0
					], 
					d=foregripProfileBottomDia, h=100);

				// Top:
				topDia = 20;
				doubleX() tcy(
					[
						foregripProfileMaxWidth/2 - topDia/2, 
						adapterBottomY+foregripProfileHeightAtMaxWidth, 
						0
					], 
					d=foregripProfileBottomDia, h=100);
			}
		}
	}
}

md = 5;
md2 = md/2;

module leadSledFwdHolder()
{
	x = foregripProfileMaxWidth + 6;
	tcu([-x/2, 0, 0], [x, foregripProfileHeightAtMaxWidth, adapterZ]);
	// minkowski() 
	// {
	// 	difference()
	// 	{
	// 		hull()
	// 		{
	// 			tcy([0, buttBottomDia/2,    md2], d=buttBottomDia-md, h=adapterZ-md);
	// 			tcy([0, buttWidthAt30mm/2+md2+30, md2], d=buttWidthAt30mm-md, h=adapterZ-md);
	// 			tcy([0, buttWidthAt50mm/2+md2+50, md2], d=buttWidthAt50mm-md, h=adapterZ-md);
	// 		}
	// 		tcu([-200, 65-md2, -200], 400);
	// 	}
	// 	// sphere(d=md);
	// 	translate([0,0,-md2]) simpleChamferedCylinderDoubleEnded(d=md, h=md, cz=2);
	// }
}

// module profileSection(x, y, dia=100, thicknessZ=1, thicknessY=10)
// {
// 	translate([0, adapterBottomY+y, -0.8]) difference() 
// 	{
// 		doubleX() difference()
// 		{
// 			tcy([x/2-dia/2, 0, 0], d=dia, h=thicknessZ);
// 			// %tcy([0, 0, 0], d=1, h=100);
// 			tcu([-400, -200, -200], 400);
// 		}
// 		doubleY() tcu([-200, thicknessY/2, -200], 400);
// 	}
// }

module clip(d=0)
{
	//tc([-200, -400-d, -10], 400);
	// tcu([0-d, -200, -200], 400);
}

if(developmentRender)
{
	display() leadSledFwdAdapter();
}
else
{
	rotate([0,180,0]) leadSledFwdAdapter();
}
