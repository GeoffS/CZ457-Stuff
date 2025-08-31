include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCAD_Lib/chamferedCylinders.scad>

halfInchNutRecessDia = 22.0;
halfInchNutRecessDepth = 11.4 - 0.55;
halfInchWasherOD = 35.5;
halfInchWasherThickness = 2.9 - 0.1;
halfInchRodOD = 13.0;

knobCoreOD = 60;
knobExtraZ = 3;
knobZ = halfInchNutRecessDepth + halfInchWasherThickness + knobExtraZ;
knobCZ = 2.5;
echo(str("knobZ = ", knobZ));

module itemModule()
{
	difference() 
    {
        union()
        {
            simpleChamferedCylinderDoubleEnded(d=knobCoreOD, h=knobZ, cz=knobCZ);
            for (a=[0:360/10:360]) rotate([0,0,a])
            {
                echo(str("a = ", a));
                bumpDia = 15;
                translate([knobCoreOD/2-bumpDia/2+bumpDia*0.35, 0, 0]) simpleChamferedCylinderDoubleEnded(d=bumpDia, h=knobZ, cz=knobCZ); 
            }
        }

        // Hole for threaded-rod:
        tcy([0,0,-1], d=halfInchRodOD, h=40);
        // Chamfer:
        translate([0,0,-10+halfInchRodOD/2+1.5]) cylinder(d1=20, d2=0, h=10);

        // Recess for nut and washer:
        translate([0,0,knobZ])
        {
            tcy([0,0,-halfInchWasherThickness], d=halfInchWasherOD, h=10);
            tcy([0,0,-halfInchWasherThickness-halfInchNutRecessDepth], d=halfInchNutRecessDia, h=20, $fn=6);
        }
    }
}

module clip(d=0)
{
	// tc([-200, -400-d, -10], 400);
}

if(developmentRender)
{
	display() itemModule();
}
else
{
	itemModule();
}
