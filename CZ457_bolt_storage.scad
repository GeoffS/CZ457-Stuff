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

include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCAD_Lib/chamferedCylinders.scad>

makeHolder = false;
makeTest = false;

boltOD = 18;
boltLength = 133;
handleWidth = 8;
guideHeight = 6.6;
handleFromBoltFace = 70;
guideFromBoltFace = 83;
guideOffsetFromHandle_deg = 60;

holderEndThickness = 3;

holderOD = 30; //boltOD + holderWallThickness*2;
holderID = boltOD + 0.3;
holderEndCZ = 2;
holderEntryCZ = 2;
holderLength = boltLength + holderEndThickness;

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
        exterior();
        
        translate([0,0,holderEndThickness])
        { 
            // Main recess:
            cylinder(d=boltOD+0.3, h=200);

            // Slot for bolt-handle:
            tcu([0, -handleSlotWidth/2, handleFromBoltFace], [100, handleSlotWidth, 200]);

            // Slot for guide:
            rotate([0,0,guideOffsetFromHandle_deg]) tcu([0, -handleSlotWidth/2, guideFromBoltFace], [100, handleSlotWidth, 200]);
        }

        // Chamfer at entry of holder-slot:
        slotEntryChamfer(angle_deg=guideOffsetFromHandle_deg);
        
        // Chamfer at entry of handle-slot:
        slotEntryChamfer(angle_deg=0);

        // Chamfer at entry of bolt:
        translate([0,0,holderLength-boltOD/2-holderEntryCZ]) cylinder(d2=30, d1=0, h=15);
    }

    // Friction nubs on guide:
    nubDia = 8;
    nubExposure = handleSlotWidthExtra/2 + 0.5;
    for(nubOffsetZ = [20, 30, 40])
    {
        //exterior();
        rotate([0,0,guideOffsetFromHandle_deg]) 
            doubleY() translate([0, handleSlotWidth/2+nubDia/2-nubExposure, holderLength - nubOffsetZ])
                difference()
                {
                    tsp([(holderOD/2+holderID/2)/2-0.7,0,0], d=nubDia);
                    tcu([-50,-nubDia/2+nubExposure+nothing,-50], 100);
                }
    }
}

module exterior()
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
