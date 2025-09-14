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

boltOD = 18;
boltLength = 133;
handleWidth = 8;
guideHeight = 7;
handleFromBoltFace = 70;
guideFromBoltFace = 83;
guideOffsetFromHandle_deg = 60;

holderWallThickness = guideHeight + 3;
holderEndThickness = 3;
// holderBoltFaceStubOD = 3;
// holderExtractorBottomID = 5;
// holderExtractorTopID = 5;
// holderBoltFaceStubZ = 4.5;

holderOD = boltOD + holderWallThickness*2;
holderEndCZ = 3;
holderLength = boltLength + holderEndThickness;

handleSlotWidth = handleWidth + 1;

module itemModule()
{
	difference()
    {
        simpleChamferedCylinderDoubleEnded(d=holderOD, h=holderLength, cz=holderEndCZ);
        
        translate([0,0,holderEndThickness])
        { 
            // Main recess:
            cylinder(d=boltOD, h=200);

            // Slot for bolt-handle:
            tcu([0, -handleSlotWidth/2, handleFromBoltFace], [100, handleSlotWidth, 200]);

            // Slot for guide:
            rotate([0,0,guideOffsetFromHandle_deg]) tcu([0, -handleSlotWidth/2, guideFromBoltFace], [100, handleSlotWidth, 200]);
        }
    }

    // simpleChamferedCylinder(d=holderBoltFaceStubOD, h=holderBoltFaceStubZ+holderEndThickness, cz=0.6);
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
