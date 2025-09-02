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

nominalHoleDia = 12.25;

od = nominalHoleDia + 8;
z = 22;

module itemModule()
{
    difference()
    {
        // Exterior:
	    simpleChamferedCylinderDoubleEnded(d=od, h=z, cz=2);

        // Hole:
        tcy([0,0,2], d=nominalHoleDia, h=100);
        translate([0,0,z-nominalHoleDia/2-0.6]) cylinder(d1=0, d2=20, h=10);
    }
}

module clip(d=0)
{
	tc([-200, -400-d, -10], 400);
}

if(developmentRender)
{
	display() itemModule();
}
else
{
	itemModule();
}
