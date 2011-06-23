// FrameLabel_as.hx:  ActionScript 3 "FrameLabel" class, for Gnash.
//
// Generated by gen-as3.sh on: 20090514 by "rob". Remove this
// after any hand editing loosing changes.
//
//   Copyright (C) 2009, 2010 Free Software Foundation, Inc.
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
//

// This test case must be processed by CPP before compiling to include the
//  DejaGnu.hx header file for the testing framework support.

#if flash9
import flash.display.FrameLabel;
import flash.display.MovieClip;
#end
import flash.Lib;
import Type;

//NOTE: this was implemented in AS3 and is only valid for flash v.9 and greater


// import our testing API
import DejaGnu;
import Std;

// Class must be named with the _as suffix, as that's the same name as the file.
class FrameLabel_as {
    static function main() {
        #if !flash9
			DejaGnu.note("This is only a valid test for AS3 and greater.");
		#end
		#if flash9
		var x1:FrameLabel = new FrameLabel("Test Label", 15);
		var x2:FrameLabel = new FrameLabel("This is a longer test label", 200);

        // Make sure we actually get a valid class        
        if (x1 != null) {
            DejaGnu.pass("FrameLabel class exists");
        } else {
            DejaGnu.fail("FrameLabel lass doesn't exist");
        }
// Tests to see if all the properties exist. All these do is test for
// existance of a property, and don't test the functionality at all. This
// is primarily useful only to test completeness of the API implementation.
	if ((x1.frame == 15) && (Type.typeof(x1.frame) == ValueType.TInt)) {
	    DejaGnu.pass("FrameLabel::frame property exists");
	} else {
	    DejaGnu.fail("FrameLabel::frame property doesn't exist");
	}
	if (Std.is(x1.name, String) && (x1.name == "Test Label")) {
	    DejaGnu.pass("FrameLabel::name property exists");
	} else {
	    DejaGnu.fail("FrameLabel::name property doesn't exist");
	}
	if (x2.frame == 200) {
		DejaGnu.pass("FrameLabel::frame property exists");
	} else {
		DejaGnu.fail("FrameLabel::frame is returning the wrong value");
	}
	if (x2.name == "This is a longer test label") {
		DejaGnu.pass("FrameLabel::name is returning the correct string");
	} else {
		DejaGnu.fail("FrameLabel::name is returning the wrong string");
	}
	#end
        // Call this after finishing all tests. It prints out the totals.
        DejaGnu.done();
    }
}

// local Variables:
// mode: C++
// indent-tabs-mode: t
// End:

