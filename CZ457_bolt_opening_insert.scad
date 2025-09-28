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

makeForwardPiece = false;
makeMiddlePiece = false;
makeAftPiece = false;

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
handleLugCZ = 0.4;

handleFrontToFrontOfinsert = 64;
handleRearToFrontOfinsert = handleFrontToFrontOfinsert + handleLugZ;

forwardPieceZ = 62;
middlePieceZ = 16;
aftPieceZ = 53;

guideLugZ = aftPieceZ;

threadedHoldDia = 4.5; //3.9;
clearanceHoleDia = 4.99; //4.1;
headRecessDia = 9.4; //7.7; //7.6;
headRecessZ = 26;
springRecessDia = 6.4; //5; //4.95;
springRecessZ = headRecessZ + 8.5;

threadedHoleZ = 8;

module forwardPiece()
{
	difference() 
    {
        simpleChamferedCylinder(d=forwardBoltOD, h=forwardPieceZ, cz=2);

        // Top cutaway:
        cutY = forwardBoltOD-10.5;
        cutZ = forwardPieceZ - 46.3;
        cutDia = 20;

        cutOffsetY = -forwardBoltOD/2 + cutY;
        echo(str("cutOffsetY = ", cutOffsetY));

        ribX = 4; //5.3; //3.4;
        ribY = 1.8; //3.0;

        difference()
        {
            // Remove the flat portion:
            union()
            {
                tcu([-100, cutOffsetY-200, cutZ], 200);
                translate([0, cutOffsetY-cutDia/2, cutZ]) rotate([0,90,0]) tcy([0,0,-100], d=cutDia, h=200);
            }

            // Add in the rib:
            tcu([-ribX/2, cutOffsetY-ribY, 0], [ribX, 100, 100]);
        }

        // Chamfer the rib:
        translate([0,0,forwardPieceZ])
        {
            chamferIndent = 0.6;
            translate([0, cutOffsetY-ribY, 0]) rotate([45,0,0]) tcu([-10, -10, -chamferIndent], 20);
            doubleX() translate([ribX/2, cutOffsetY, 0]) rotate([0,45,0]) tcu([-10, -20, -chamferIndent], 20);
        }

        // Ejector slot:
        ejectorX = 2;
        ejectorY = 2;
        translate([ribX/2-ejectorX+nothing,0, 2.5])
        {
            tcu([0, -10+cutOffsetY+ejectorY, cutZ], [ejectorX, 10, 100]);
            translate([0, cutOffsetY+ejectorY-cutDia/2, cutZ]) rotate([0,90,0]) tcy([0,0,0], d=cutDia, h=ejectorX);
        }

        // Bolt retainer cutout:
        retainerX = 2;
        tcu([forwardBoltOD/2-retainerX, 0-100, -20], 200);

        // Bottom slot:
        slotX= 3.8;
        slotY = 2;
        tcu([-slotX/2, forwardBoltOD/2-slotY, -1], [slotX, 20, 200]);

        // Screw hole:
        tcy([0,0,-50+threadedHoleZ], d=threadedHoldDia, h=50);
        // Chamfer:
        translate([0,0,-5+threadedHoldDia/2+0.6]) cylinder(d1=10, d2=0, h=5);
    }
}

module middlePiece()
{
    difference() 
    {
        union()
        {
            cylinder(d=forwardBoltOD, h=middlePieceZ);

            // Lug:
            difference()
            {
                lugDia=25;
                translate([0,0,-lugDia/2+handleLugZ]) rotate([0,90,0]) simpleChamferedCylinder(d=lugDia, h=handleLugX, cz=handleLugCZ*1.4);

                // Trim the width:
                doubleY() tcu([-100, handleLugY/2, -100], 200);
                // Trim the back/bottom:
                tcy([0,0,-100], d=100, h=100);
                // Chamfer the back/bottom side edges:
                doubleY() translate([0, handleLugY/2, 0]) rotate([-45,0,0]) tcu([-1, -handleLugCZ, -10], 20);
                // Chamfer the front/top side edges:
                doubleY() translate([0, handleLugY/2, handleLugZ-0.65]) rotate([45,0,0]) tcu([-1, -handleLugCZ, -10], 20);
                // Chamfer the outer corners:
                doubleY() translate([handleLugX, handleLugY/2, 0]) rotate([0,0,-45]) tcu([-10, -handleLugCZ, -1], 20);
                // Chamfer the back/bottom outside edge:
                translate([handleLugX, 0, 0]) rotate([0,45,0]) tcu([-handleLugCZ, -10, -10], 20);
            }
        }

        // Screw hole:
        tcy([0,0,-1], d=clearanceHoleDia, h=100);
        // Chamfer:
        translate([0,0,-5+clearanceHoleDia/2+0.6]) cylinder(d1=10, d2=0, h=5);
    }
}

module aftPiece()
{
    rearCZ = 3;
    difference()
    {
        union()
        {
            translate([0,0,aftPieceZ]) mirror([0,0,1]) simpleChamferedCylinder(d=rearBoltOD, h=aftPieceZ, cz=rearCZ);

            // Guide:
            difference()
            {
                // translate([0,0,-lugDia/2+handleLugZ]) rotate([0,90,0]) simpleChamferedCylinder(d=lugDia, h=handleLugX, cz=handleLugCZ*1.4);
                tcu([0, -handleLugY/2, 0], [handleLugX, handleLugY, guideLugZ]);

                // Chamfer the front/top outside edge:
                translate([handleLugX, 0, guideLugZ]) rotate([0,-45,0]) tcu([-handleLugCZ, -10, -10], 20);
                // tcy([0,0,-100], d=100, h=100);
                doubleY() translate([0, handleLugY/2, 0]) rotate([-45,0,0]) tcu([-1, -handleLugCZ, -10], 20);
                // Chamfer the front/top side edges:
                doubleY() translate([0, handleLugY/2, guideLugZ]) rotate([45,0,0]) tcu([-1, -handleLugCZ, -10], 20);
                // Chamfer the outer corners:
                doubleY() translate([handleLugX, handleLugY/2, 0]) rotate([0,0,-45]) tcu([-10, -handleLugCZ, -1], 100);
                // Chamfer the back/bottom outside edge:
                translate([handleLugX, 0, 0]) rotate([0,45,0]) 
                {
                    tcu([-rearCZ*0.707, -10, -10], 20);
                    // Chamfer the outer corners:
                    doubleY() translate([0, handleLugY/2, 0]) rotate([0,0,-45]) tcu([-10, -handleLugCZ-1.5, -10], 100);
                }
            }
        }

        // Bolt hole:
        tcy([0,0,-1], d=clearanceHoleDia, h=200);
        // Head recess:
        tcy([0,0,-1], d=headRecessDia, h=headRecessZ+1);
        // Spring recess:
        tcy([0,0,0], d=springRecessDia, h=springRecessZ);
        // Bottom Chamfer:
        translate([0, 0, -10+headRecessDia/2+0.6]) cylinder(d1=20, d2=0, h=10);
        // Bottom Chamfer:
        translate([0, 0, aftPieceZ-clearanceHoleDia/2-0.6]) cylinder(d2=10, d1=0, h=5);
    }
}

module clip(d=0)
{
	// tcu([-200, -400-d, -100], 400);
    // tcu([-d,-200,-100], 400);
}

if(developmentRender)
{
    display() forwardPiece();


    // displayPieces(forward);
    // displayPieces(middle);
    // displayPieces(aft);

    // dz = 0.05;
    // display()                                               rotate([0,0,0]) aftPiece();
    // display() translate([0,0,aftPieceZ+dz])                 rotate([0,0,60]) middlePiece();
    // display() translate([0,0,aftPieceZ+dz+middlePieceZ+dz]) rotate([0,0,180]) forwardPiece();
    // screwLength = 50;
    // displayGhost() translate([0,0,aftPieceZ+dz+middlePieceZ+dz+threadedHoleZ-1-screwLength]) cylinder(d=4.8, h=screwLength);
}
else
{
	if(makeForwardPiece) forwardPiece();
    if(makeMiddlePiece) mirror([0,0,1]) middlePiece();
    if(makeAftPiece) aftPiece();
}

module displayPieces(x)
{
    display() translate([-40+x,0,0]) forwardPiece();
    display() translate([    x,0,0]) middlePiece();
    display() translate([ 40+x,0,0]) aftPiece();
}

forward = 40;
middle = 0;
aft = -40;
