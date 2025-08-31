include <../OpenSCAD_Lib/MakeInclude.scad>

halfInchNutRecessDia = 22.0;
halfInchNutRecessDepth = 11.4;
halfInchWasherOD = 35.5;
halfInchWasherThickness = 2.9;
halfInchRodOD = 12.8;

knobZ = halfInchNutRecessDepth+halfInchWasherThickness+5;

module itemModule()
{
	difference() 
    {
        cylinder(d=60, h=knobZ);

        tcy([0,0,-1], d=halfInchRodOD, h=40);

        translate([0,0,knobZ])
        {
            tcy([0,0,-halfInchWasherThickness], d=halfInchWasherOD, h=10);
            tcy([0,0,-halfInchWasherThickness-halfInchNutRecessDepth], d=halfInchNutRecessDia, h=20, $fn=6);
        }
    }
}

module clip(d=0)
{
	//tc([-200, -400-d, -10], 400);
}

if(developmentRender)
{
	display() itemModule();
}
else
{
	itemModule();
}
