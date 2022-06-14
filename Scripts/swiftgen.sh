#!/bin/bash

# This file is part of the Screen Commander project.
# Copyright (c) 2017-2022 Brian Christensen
# Author: Brian Christensen <bkc@xensen.net>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# In addition, this program is also subject to certain additional terms.
# You should have received a copy of these additional terms immediately
# following the terms and conditions of the GNU General Public License
# which accompanied this program.  If not, please request a copy in
# writing from the Author at the above e-mail address.

# In case of custom $PATH where our swiftgen might live
if [ -e "${HOME}/.bash_profile" ]; then
	source "${HOME}/.bash_profile"
fi

if [ -e "${HOME}/.bashrc" ]; then
	source "${HOME}/.bashrc"
fi

if which swiftgen >/dev/null; then
	swiftgen run strings "${PROJECT_DIR}/${TARGET_NAME}/Resources/Base.lproj/Localizable.strings" --output "${PROJECT_DIR}/${TARGET_NAME}/Generated/LocalizableStrings.swift" --template flat-swift5
else
	echo "warning: SwiftGen not installed, download it from https://github.com/AliSoftware/SwiftGen"
fi
