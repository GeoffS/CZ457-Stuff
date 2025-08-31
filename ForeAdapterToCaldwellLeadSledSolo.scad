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
	difference()
	{
		leadSledFwdHolder(realThreads);
		cz457ForwardStockProfile(adapterBottomY=10);
	}
}

md = 5;
md2 = md/2;

topDia = 6;
topX = 46.5;
topY = forwardSupportHeight - topDia/2;

module leadSledFwdHolder(realThreads)
{
	x = 55;
	tcu([-x/2, 0, 0], [x, 41, 35]);
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
