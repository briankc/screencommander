Screen Commander GPL Source Code
================================

Sections:

* GENERAL NOTES
* LICENSE

GENERAL NOTES
=============

Description of source release
-----------------------------

This source code release contains the Screen Commander project, a utility 
application for MacOS that lives in the menubar and provides screen 
blanking options. It was previously released on the Mac App Store as
freeware (it is no longer available there).

I effectively stopped actively developing this project in early 2018 when I 
switched to using a GNU/Linux distribution as my primary personal operating
system. For this source code release, however, I did spend some time 
cleaning up the codebase (such as upgrading it to Swift 5 and ensuring that
it builds properly using the latest version of Xcode). Beyond these already
completed changes, I do not intend to continue any development on this 
project. Meaning:

*** SCREEN COMMANDER IS NO LONGER ACTIVELY MAINTAINED. ***

Compiling with Xcode
--------------------

After cloning the repository, run the following command to retrieve the
required submodules:

	git submodule update --init --recursive

Once that command completes, open the "Screen Commander.xcworkspace" file
with Xcode (version 13.4.1 or later). You should now be be able to build
and run the application.

LICENSE
=======

This program is free software: you can redistribute it and/or modify it 
under the terms of the GNU General Public License as published by the Free 
Software Foundation, either version 3 of the License, or (at your option) 
any later version.

This program is distributed in the hope that it will be useful, but WITHOUT 
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or 
FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for 
more details.

You should have received a copy of the GNU General Public License along 
with this program.  If not, see <http://www.gnu.org/licenses/>.

(See COPYING or LICENSE for the GNU General Public License.)

ADDITIONAL TERMS:  This program is also subject to certain additional 
terms. You should have received a copy of these additional terms 
immediately following the terms and conditions of the GNU General Public 
License which accompanied this program.  If not, please request a copy in 
writing from the author (Brian Christensen) at this e-mail address: 
<bkc@xensen.net>

(See COPYING or LICENSE for the ADDITIONAL TERMS following the GNU General 
Public License.)

EXCLUDED CODE:  The code described below, which is referenced by the Screen 
Commmander GPL Source Code release via Git submodules under the "Vendor"
directory and whose output frameworks are linked into the Screen Commander
program, is NOT part of the Program covered by the GPL and is expressly
excluded from its terms.  You are solely responsible for obtaining from
the copyright holder a license for such code and complying with the 
applicable license terms.

Nimble (framework)
---------------------------------------------------------------------------
Files: Vendor/Nimble/*
License: Apache License, Version 2.0

COPYRIGHT AND PERMISSION NOTICE

Copyright 2016 Quick Team

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Quick (framework)
---------------------------------------------------------------------------
Files: Vendor/Quick/*
License: Apache License, Version 2.0

COPYRIGHT AND PERMISSION NOTICE

Copyright 2014, Quick Team

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

SwiftyUserDefaults (framework)
---------------------------------------------------------------------------
Files: Vendor/SwiftyUserDefaults/*
License: The MIT License (MIT)

COPYRIGHT AND PERMISSION NOTICE

Copyright (c) 2015-present Radosław Pietruszewski, Łukasz Mróz

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
