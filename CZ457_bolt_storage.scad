// Copyright (C) 2025 Geoff Sobering

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program (see the LICENSE file in this directory).  
// If not, see <https://www.gnu.org/licenses/>.

// $fn=360;

include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCAD_Lib/chamferedCylinders.scad>
include <../OpenSCAD_Lib/torus.scad>

makeHolder = false;
makeTest = false;

boltOD = 18;
boltLength = 133;
handleWidth = 8;
guideHeight = 6.6;
handleFromBoltFace = 70;
guideFromBoltFace = 83;
guideOffsetFromHandle_deg = 60;

bungieHoldDia = 4.2;
holderEndThickness = 3 + bungieHoldDia + 4.5;
bungieHoleCtrX = 2 + bungieHoldDia;
bungieHoleCtrZ = 3 + 1 + bungieHoldDia/2;

holderOD = 30;
holderID = boltOD + 0.3;
holderEndCZ = 2;
holderEntryCZ = 2;
holderExtraLength = 2;
holderLength = boltLength + holderEndThickness + holderExtraLength;

echo(str("holderOD = ", holderOD));

handleSlotWidthExtra = 0.6;
handleSlotWidth = handleWidth + handleSlotWidthExtra;

holderWallThickness = (holderOD-holderID)/2;
echo(str("holderWallThickness = ", holderWallThickness));

module itemModule()
{
	difference()
    {
        // Exterior:
        union()
        {
            exteriorCylinder();

            hull()
            {
                // Bump at guide-slot:
                guideBumpBottomZ = handleFromBoltFace + holderEndThickness;
                guideBumpZ = holderLength - guideBumpBottomZ;
                guideBumpExtraX = 5;
                guideBumpDia = 27;

                rotate([0,0,guideOffsetFromHandle_deg]) 
                    translate([holderOD/2-guideBumpDia/2+guideBumpExtraX, 0, holderLength-guideBumpZ]) 
                        simpleChamferedCylinder(d=guideBumpDia, h=guideBumpZ, cz=holderEndCZ);
                
                // Holder exterior for hull() smoothing:
                difference()
                {
                    exteriorCylinder();
                    tcy([0,0,guideBumpBottomZ-guideBumpExtraX-6-400], d=100, h=400);
                }
            }
        }
        
        translate([0,0,holderEndThickness])
        { 
            // Main recess:
            cylinder(d=boltOD+0.3, h=200);

            // Slot for bolt-handle:
            tcu([0, -handleSlotWidth/2, handleFromBoltFace], [100, handleSlotWidth, 200]);

            // Slot for guide:
            intersection() 
            {
                exteriorCylinder();
                rotate([0,0,guideOffsetFromHandle_deg]) tcu([0, -handleSlotWidth/2, guideFromBoltFace], [100, handleSlotWidth, 200]);
            }
        }

        // Chamfer at entry of holder-slot:
        intersection() 
        {
            // exteriorCylinder();
            cylinder(d=holderOD, h=holderLength+nothing);
            slotEntryChamfer(angle_deg=guideOffsetFromHandle_deg);
        }
        
        // Chamfer at entry of handle-slot:
        slotEntryChamfer(angle_deg=0);

        // Chamfer at entry of bolt:
        translate([0,0,holderLength-boltOD/2-holderEntryCZ]) cylinder(d2=30, d1=0, h=15);

        // Holes for bungie;
        rotate([0,0,90]) doubleX() translate([bungieHoleCtrX, 0, bungieHoleCtrZ])
        {
            rotate([-90,0,0]) tcy([0,0,-nothing], d=bungieHoldDia, h=100);
            od = 36;
            translate([0,0,od/2-bungieHoldDia/2]) rotate([0,90,0]) difference()
            {
                torus3a(outsideDiameter=od, circleDiameter=bungieHoldDia);
                tcu([-200,0,-200], 400); // trim back
                tcu([-400,-200,-200], 400); // trim top
            }
        }

        // Bungie hole chamfers:
        // WARNING: All MAGIC, all the time!!!
        // EVERYTHING!!! I'm not kidding...
        doubleY() rotate([0,0,27]) translate([-holderOD/2-1.4, 0, bungieHoleCtrZ]) rotate([0,0,-7]) rotate([0,90,0]) cylinder(d1=10, d2=0, h=5);
    }

    // Friction nubs on guide:
    nubDia = 8;
    nubExposure = handleSlotWidthExtra/2 + 0.40;
    for(nubOffsetZ = [20, 30, 40])
    {
        rotate([0,0,guideOffsetFromHandle_deg]) 
            doubleY() translate([0, handleSlotWidth/2+nubDia/2-nubExposure, holderLength - nubOffsetZ])
                difference()
                {
                    tsp([(holderOD/2+holderID/2)/2-0.7,0,0], d=nubDia);
                    tcu([-50,-nubDia/2+nubExposure+nothing,-50], 100);
                }
    }
}

module exteriorCylinder()
{
    simpleChamferedCylinderDoubleEnded(d=holderOD, h=holderLength, cz=holderEndCZ);
}

module slotEntryChamfer(angle_deg)
{
    translate([0,0,holderLength-handleSlotWidth/2-holderEntryCZ]) rotate([0,0,angle_deg]) rotate([45,0,0]) tcu([0,0,0], 20);
}

module clip(d=0)
{
	// tcu([-200, -400-d, -10], 400);
    // rotate([0,0,guideOffsetFromHandle_deg]) tcu([-200, -400-d, -10], 400);

    // tcy([0,0,bungieHoleCtrZ-100], d=100, h=100);
    // tcy([0,0,20], d=100, h=400);

    // tcu([-200, bungieHoleCtrX-400-d, -10], 400);
}

if(developmentRender)
{
	display() itemModule();

    display() translate([-60,0,0]) fitTest();
}
else
{
	if(makeHolder) itemModule();
    if(makeTest) fitTest();
}

module fitTest()
{
    difference()
    {
        itemModule();
        translate([0,0,holderEndThickness])
        {
            tcy([0,0,guideFromBoltFace+13], d=100, h=200);
            tcy([0,0,handleFromBoltFace-3-200], d=100, h=200);
        }
    }
}
