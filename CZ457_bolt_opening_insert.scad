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

// boltOD = 18;
boltLength = 133;
handleWidth = 8;
guideHeight = 6.6;
// handleFromBoltFace = 70;
guideFromBoltFace = 83;
guideOffsetFromHandle_deg = 60;

forwardBoltOD = 17.5;
rearBoltOD = 18;

handleLugX = 25 - 9;
handleLugY = 7.8;
handleLugZ = 11.5;

handleFrontToFrontOfinsert = 64;
handleRearToFrontOfinsert = handleFrontToFrontOfinsert + handleLugZ;

module itemModule()
{
	difference() 
    {
        union()
        {
            simpleChamferedCylinder(d=forwardBoltOD, h=handleRearToFrontOfinsert, cz=2);

            // Lug:
            difference()
            {
                lugDia=25;
                translate([0,0,-lugDia/2+handleLugZ]) rotate([0,90,0]) simpleChamferedCylinder(d=lugDia, h=handleLugX, cz=1);

                // Trim the width:
                doubleY() tcu([-100, handleLugY/2, -100], 200);
                // Trim the back/bottom:
                tcy([0,0,-100], d=100, h=100);
                cz = 0.4;
                // Chamfer the back/bottom side edges:
                doubleY() translate([0, handleLugY/2, 0]) rotate([-45,0,0]) tcu([-1, -cz, -10], 20);
                // Chamfer the outer corners:
                doubleY() translate([handleLugX, handleLugY/2, 0]) rotate([0,0,-45]) tcu([-10, -cz, -1], 20);
                // Chamfer the back/bottom outside edge:
                translate([handleLugX, 0, 0]) rotate([0,45,0]) tcu([-cz, -10, -10], 20);
            }
        }

        // M4 Screw hole:
        m4ThreadedHoldDia = 4;
        tcy([0,0,-50+15], d=m4ThreadedHoldDia, h=50);
        // Chamfer:
        translate([0,0,-5+m4ThreadedHoldDia/2+0.6]) cylinder(d1=10, d2=0, h=5);
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
