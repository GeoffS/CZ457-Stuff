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

include <CaldwellLeadSledSolo.scad>

module itemModule()
{
	// End cap:
    endDia = 3.5;
    endOffsetXY = (tubeOutsideDim - endDia)/2;
    endZ = 3;
    hull() doubleX() doubleY() mirror([0,0,1])translate([endOffsetXY,endOffsetXY,-endZ]) simpleChamferedCylinder(d=endDia, h=endZ, cz=1);

    // Inside:
    insideDia = 1.8;
    insideOffsetXY = (tubeInsideDim - 1 - insideDia)/2;
    insideZ = 13;
    hull() doubleX() doubleY() translate([insideOffsetXY,insideOffsetXY,0]) simpleChamferedCylinder(d=insideDia, h=insideZ, cz=0.6);

    // Nubs:
    nubDia = 3;
    nubOffsetXY = (tubeInsideDim - nubDia)/2;
    nubOffsetFromCornerXY = 6;
    doubleX() doubleY() translate([insideOffsetXY,insideOffsetXY-nubOffsetFromCornerXY,0]) simpleChamferedCylinder(d=nubDia, h=insideZ, cz=0.6);
    doubleX() doubleY() translate([insideOffsetXY-nubOffsetFromCornerXY,insideOffsetXY,0]) simpleChamferedCylinder(d=nubDia, h=insideZ, cz=0.6);
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
