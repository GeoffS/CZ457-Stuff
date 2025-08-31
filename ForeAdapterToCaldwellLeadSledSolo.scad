include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCAD_Lib/chamferedCylinders.scad>
include <../OpenSCAD_Lib/threads.scad>

include <CaldwellLeadSledSolo.scad>
include <CZ457American.scad>

makeTestProfile = false;
makeForwardSupport = false;

// adapterBottomY = 4; //10;
adapterZ = 10; //forwardSupportLength;

module cz457ForwardStockProfile(adapterBottomY)
{
	// Fore-grip profile:
		hull()
		{
			translate([0, 0, -1])
			{
				// Bottom:
				doubleX() tcy(
					[
						foregripProfileBottomWidth/2 - foregripProfileBottomDia/2, 
						adapterBottomY+foregripProfileBottomDia/2, 
						0
					], 
					d=foregripProfileBottomDia, h=100);

				// Middle:
				middleDia = 40;
				doubleX() tcy(
					[
						foregripProfileMaxWidth/2 - middleDia/2 + 1.3, 
						adapterBottomY + 21.5, 
						0
					], 
					d=middleDia, h=100);

				// Top:
				topDia = 20;
				doubleX() tcy(
					[
						foregripProfileMaxWidth/2 - topDia/2 + 1.5, 
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
		x = 55;
		tcu([-x/2, 0, 0], [x, 31+threadedHolderRecessY, holderZ]);

		threadedRodRecess(y=threadedHolderRecessY, realThreads=realThreads);
	}
}

module threadedRodRecess(y, realThreads)
{
	translate([0, y, holderZ/2]) rotate([-90,0,0]) if(realThreads)
	{
		tcy([0,0,-100], d=12.5, h=100);
	}
	else 
	{  
		tcy([0,0,-100], d=12.5, h=100);
	}
}

module cz457ForwardStockProfileTest()
{
	adapterBottomY=4;

	difference()
	{
		x = foregripProfileMaxWidth + 10;
		tcu([-x/2, 0, 0], [x, foregripProfileHeightAtMaxWidth+adapterBottomY, adapterZ]);

		cz457ForwardStockProfile(adapterBottomY=adapterBottomY);
	}
}

module clip(d=0)
{
	//tc([-200, -400-d, -10], 400);
	// tcu([0-d, -200, -200], 400);

	tcu([-200, -200, holderZ/2-d], 400);
}

if(developmentRender)
{
	// display() cz457ForwardStockProfileTest();
	// display() translate([-80,0,0]) leadSledFwdAdapter(realThreads=false);

	display() leadSledFwdAdapter(realThreads=false);
	display() translate([-80,0,0]) cz457ForwardStockProfileTest();
}
else
{
	if(makeTestProfile) cz457ForwardStockProfileTest();
	if(makeForwardSupport) leadSledFwdAdapter(realThreads=true);
}
