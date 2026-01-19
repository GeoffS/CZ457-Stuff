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
makeCatch = false;

boltOD = 18;
boltLength = 133;
handleWidth = 8;
guideHeight = 6.6;
handleBaseHeight = guideHeight;
handleBaseLength = 12;
handleFromBoltFace = 70;
guideFromBoltFace = 83;
guideOffsetFromHandle_deg = 60;
guideKength = 40;

holderWallThickness = 3;
holderEndThickness = 3;

holderID = boltOD + 0.25;
holderOD = holderID + 2*holderWallThickness;
holderEndCZ = 1.5;
holderEntryCZ = 1;
holderExtraLength = 2;
holderLength = boltLength + holderEndThickness + holderExtraLength;

echo(str("holderID = ", holderID));
echo(str("holderOD = ", holderOD));

handleSlotWidthExtra = 0.2;
handleSlotWidth = handleWidth + handleSlotWidthExtra;

// Bump at guide-slot:
guideBumpBottomZ = handleFromBoltFace + holderEndThickness;
guideBumpZ = holderLength + holderEndCZ + 1 - guideBumpBottomZ;
guideBumpExtraX = 5;
guideCylinderOD = 30;

// MAGIC!!!
//  Make handelAndGuideAngle ~= 8 degrees
//   --------------vvvvv
handelAndGuideCZ = 2.324;

// MAGIC!!!
// Make chamfer meet at top.
//   ---------------------------------------------------------------vvvvv
handelAndGuideAngle = asin(handelAndGuideCZ/(guideCylinderOD/2)) * 0.898;

echo(str("handelAndGuideAngle = ", handelAndGuideAngle));

guideBumpTrimAngle1 = 19;
guideBumpTrimAngle2 = -guideOffsetFromHandle_deg - guideBumpTrimAngle1 - 7;

guideBumpOD = guideCylinderOD + 2*holderWallThickness - holderEndCZ;
guideBumpCornerDia = 6;
guideBumpCornerDiaOffsetX = guideBumpOD/2-guideBumpCornerDia/2;

echo(str("guideBumpOD = ", guideBumpOD));

handleBaseCtrX = boltOD/2 + handleBaseHeight/2;

catchBoltHoleDia = 3.3; // m3
catchSpringMinLength = 4.75;
catchSpringHoleDia = 4.3;
// MAGIC!!!
//  Correct to edge of handle-slot opening.
//  -------------------------------------------------------------------------vvvvv
effectiveRadiusAtHandleSlotOutsideOpeningX = guideBumpOD/2 * handleSlotWidth/8.443;
effectiveRadiusAtHandleSlotInsideOpeningX  =    holderID/2 * handleSlotWidth/9.15;

catchCorrectionX = 0.8;
catchCtrX = (effectiveRadiusAtHandleSlotOutsideOpeningX + effectiveRadiusAtHandleSlotInsideOpeningX)/2 - catchCorrectionX/2;
catchRecessX = effectiveRadiusAtHandleSlotOutsideOpeningX - effectiveRadiusAtHandleSlotInsideOpeningX - 2 - catchCorrectionX;
catchRecessY = 10;
catchRecessZ = handleBaseLength + 15;

echo(str("catchCtrX = ", catchCtrX));
echo(str("catchRecessX = ", catchRecessX));
echo(str("catchRecessY = ", catchRecessY));
echo(str("catchRecessZ = ", catchRecessZ));

catchExtraY = 5;
catchClearanceX = 0.2;
catchClearanceZ = 0.2;

catchX = catchRecessX - 2*catchClearanceX;
catchY = handelAndGuideCZ + catchExtraY;
catchZ = catchRecessZ - 2*catchClearanceZ;

$fn = 180;

module itemModule()
{
	difference()
    {
        // Exterior:
        union()
        {
            exteriorCylinder();

            guideBump();

            // Catch external bump:
            hull()
            {

            }
        }
        
        translate([0,0,holderEndThickness])
        { 
            // Main recess:
            boltCylinder();

            // Slot for bolt-handle:
            tcu([0, -handleSlotWidth/2, handleFromBoltFace], [100, handleSlotWidth, 200]);

            // Notch at bottom of bolt-handle slot:
            hull()
            {
                translate([0, -handleSlotWidth/2, handleFromBoltFace]) rotate([0,0,handelAndGuideAngle]) 
                {
                    tcu([0, 0, handleBaseLength], [100, handleSlotWidth-handelAndGuideCZ, handelAndGuideCZ]);
                    cube([100, handleSlotWidth, handleBaseLength]);
                }
            }

            // Slot for guide:
            intersection() 
            {
                guideCylinder();
                rotate([0,0,guideOffsetFromHandle_deg]) tcu([0, -handleSlotWidth/2, guideFromBoltFace], [100, handleSlotWidth, 200]);
            }

            // Notch at bottom of guide slot:
            intersection() 
            {
                guideCylinder();
                hull()
                {
                    rotate([0,0,guideOffsetFromHandle_deg]) translate([0, -handleSlotWidth/2, guideFromBoltFace]) rotate([0,0,handelAndGuideAngle]) 
                    {
                        tcu([0, 0, guideKength+handelAndGuideCZ], [100, handleSlotWidth-handelAndGuideCZ, 0.5]);
                        cube([100, handleSlotWidth, guideKength]);
                    }
                }
            }

            // Recess for catch:
            tcu([catchCtrX-catchRecessX/2, -100, handleFromBoltFace], [catchRecessX, 100, catchRecessZ]);
        }

        // Chamfer at entry of holder-slot:
        intersection() 
        {
            guideCylinder();
            slotEntryChamfer(angle_deg=guideOffsetFromHandle_deg);
        }
        
        // Chamfer at entry of handle-slot:
        slotEntryChamfer(angle_deg=0);

        // Chamfer at entry of bolt:
        translate([0,0,holderLength-boltOD/2-holderEntryCZ]) cylinder(d2=30, d1=0, h=15);
    }
}

module catch()
{
    tcu([0,0,0], [catchX, catchY, catchZ]);
}

module boltCylinder()
{
    cylinder(d=boltOD+0.3, h=200);
}

module guideCylinder()
{
    tcy([0,0,-1], d=guideCylinderOD, h=holderLength+2);
}

module guideBump()
{
    hull()
    {
        difference()
        {
            translate([0, 0, holderLength-guideBumpZ]) 
                simpleChamferedCylinderDoubleEnded(d=guideBumpOD, h=guideBumpZ, cz=holderEndCZ);

            rotate([0,0,guideOffsetFromHandle_deg]) 
            {
                rotate([0,0, guideBumpTrimAngle1]) tcu([-200,   0, -10], 400);
                rotate([0,0, guideBumpTrimAngle2]) tcu([-200,-400, -10], 400);
            }
        }

        // Round the corners:
        guideBumpCornerOnExternalDiameter(a=guideBumpTrimAngle1);
        guideBumpCornerOnExternalDiameter(a=guideBumpTrimAngle2);

        // Add an extension for the catch:
        guideBumpCorner(x=effectiveRadiusAtHandleSlotOutsideOpeningX, y=-holderOD/2);
        
        // Holder exterior for hull() smoothing:
        difference()
        {
            exteriorCylinder();
            tcy([0,0,guideBumpBottomZ-guideBumpExtraX-6-400], d=100, h=400);
        }
    }
}

module guideBumpCornerOnExternalDiameter(a)
{
    translate([0, 0, holderLength-guideBumpZ]) 
            rotate([0,0, guideOffsetFromHandle_deg+a]) translate([guideBumpCornerDiaOffsetX,0,0]) 
                simpleChamferedCylinderDoubleEnded(d=guideBumpCornerDia, h=guideBumpZ, cz=holderEndCZ);;
}

module guideBumpCorner(x, y)
{
    echo(str("guideBumpCorner(x, y) = ", x, ", ", y));
    echo(str("y+guideBumpCornerDia/2 = ", y+guideBumpCornerDia/2));

    translate([x-guideBumpCornerDia/2, y+guideBumpCornerDia/2, holderLength-guideBumpZ]) 
        simpleChamferedCylinderDoubleEnded(d=guideBumpCornerDia, h=guideBumpZ, cz=holderEndCZ);;
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

    // tcy([0,0,20], d=100, h=400);

    // tcu([-200, -400+d, -10], 400);

    // x = boltOD/2 + handleBaseHeight/2;
    // echo(str(" Handle bump ctr X = ", x));
    // tcu([x, -200, -10], 400);

    // tcy([0,0,handleFromBoltFace+handleBaseLength], d=100, h=400);

    // rotate([0,0,45]) tcu([-400+d, -200, -10], 400);
}

if(developmentRender)
{
	display() itemModule();
    displayGhost() 
        translate([catchCtrX-catchX/2, -catchY-handleSlotWidth/2+handelAndGuideCZ, handleFromBoltFace+holderEndThickness+catchClearanceZ]) 
            catch();

    display() translate([-30, 0, 0]) catch();
    // display() rotate([0,0,-guideOffsetFromHandle_deg]) itemModule();
    // display() rotate([0,0,-handelAndGuideAngle]) itemModule();

    // display() translate([-60,0,0]) fitTest();

    // displayGhost() tcu([effectiveRadiusAtHandleSlotOutsideOpeningX, -50, guideFromBoltFace], [1, 100, 1]);
    // displayGhost() tcu([effectiveRadiusAtHandleSlotInsideOpeningX-1, -50, guideFromBoltFace], [1, 100, 1]);
}
else
{
	if(makeHolder) itemModule();
    if(makeTest) fitTest();
    if(makeCatch) catch();
}

module fitTest()
{
    difference()
    {
        itemModule();

        // translate([0,0,holderEndThickness])
        // {
        //     tcy([0,0,guideFromBoltFace+13], d=100, h=200);
        //     tcy([0,0,handleFromBoltFace-3-200], d=100, h=200);
        // }

        tcy([0,0,-1], d=100, h=68+1);
    }
}
