include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCAD_Lib/chamferedCylinders.scad>
include <../OpenSCAD_Lib/threads.scad>

include <CaldwellLeadSledSolo.scad>
include <CZ457American.scad>

makeTestProfile = false;
makeForwardSupport = false;

module cz457ForwardStockProfile(adapterBottomY)
{
	dx = -1;

	// Fore-grip profile:
	hull()
	{
		translate([0, 0, -1])
		{
			// Bottom:
			doubleX() tcy(
				[
					foregripProfileBottomWidth/2 - foregripProfileBottomDia/2 + dx, 
					adapterBottomY+foregripProfileBottomDia/2, 
					0
				], 
				d=foregripProfileBottomDia, h=100);

			// Middle:
			middleDia = 40;
			doubleX() tcy(
				[
					foregripProfileMaxWidth/2 - middleDia/2 + 1.3 + dx, 
					adapterBottomY + 21.5, 
					0
				], 
				d=middleDia, h=100);

			// Top:
			topDia = 20;
			doubleX() tcy(
				[
					foregripProfileMaxWidth/2 - topDia/2 + 1.5 + dx, 
					adapterBottomY + foregripProfileHeightAtMaxWidth + 2, 
					0
				], 
				d=topDia, h=100);
		}
	}
}

module leadSledFwdAdapter(realThreads)
{
	threadedHolderRecessY = 30;
	difference()
	{
		leadSledFwdHolder(threadedHolderRecessY=threadedHolderRecessY, realThreads=realThreads);
		cz457ForwardStockProfile(adapterBottomY=threadedHolderRecessY+3);
	}
}

holderZ = 35;

module leadSledFwdHolder(threadedHolderRecessY, realThreads)
{
	difference()
	{
		leadSledFwdHolderExterior(threadedHolderRecessY=threadedHolderRecessY);
		threadedRodRecess(y=threadedHolderRecessY, realThreads=realThreads);
	}
}

exteriorDia = 25;
exteriorCZ = 3;

module leadSledFwdHolderExterior(threadedHolderRecessY)
{
	ed2 = exteriorDia/2;

	hull() doubleX()
	{
		exteriorCorner(22-ed2, ed2);
		exteriorCorner(33-ed2, threadedHolderRecessY);
		exteriorCorner(37-ed2, threadedHolderRecessY + 35 - ed2);
	}
}

module exteriorCorner(x, y)
{
	translate([x, y, 0]) simpleChamferedCylinderDoubleEnded(d=exteriorDia, h=holderZ, cz=exteriorCZ);
}

module threadedRodRecess(y, realThreads)
{
	nominalHoleDia = 12.5;

	translate([0, 0, holderZ/2]) rotate([-90,0,0]) 
	{
		translate([0, 0, y]) 
		{
			if(realThreads)
			{
				tcy([0,0,-100], d=nominalHoleDia, h=100);
			}
			else 
			{  
				tcy([0,0,-100], d=nominalHoleDia, h=100);
			}
		}

		// Chamfer:
		translate([0,0,-15+nominalHoleDia/2+1]) cylinder(d1=30, d2=0, h=15);
	}

}

module cz457ForwardStockProfileTest()
{
	adapterBottomY=4;

	difference()
	{
		x = foregripProfileMaxWidth + 10;
		tcu([-x/2, 0, 0], [x, foregripProfileHeightAtMaxWidth+adapterBottomY, 10]);

		cz457ForwardStockProfile(adapterBottomY=adapterBottomY);
	}
}

module clip(d=0)
{
	//tc([-200, -400-d, -10], 400);
	// tcu([0-d, -200, -200], 400);

	// tcu([-200, -200, holderZ/2-d], 400);
}

if(developmentRender)
{
	display() cz457ForwardStockProfileTest();
	display() translate([-80,0,0]) leadSledFwdAdapter(realThreads=false);

	// display() leadSledFwdAdapter(realThreads=false);
	// display() translate([-80,0,0]) cz457ForwardStockProfileTest();
}
else
{
	if(makeTestProfile) cz457ForwardStockProfileTest();
	if(makeForwardSupport) leadSledFwdAdapter(realThreads=true);
}
