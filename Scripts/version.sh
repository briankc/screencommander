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

commit=$(git rev-parse --short HEAD)
status=$(git status --porcelain)
branch=$(git rev-parse --abbrev-ref HEAD)
commit_count=$(git rev-list --count master..HEAD)

if [ "$branch" == "master" ]; then
	branch="M"
elif [ "${branch:0:8}" == "feature/" ]; then
	branch="F"
elif [ "${branch:0:8}" == "release/" ]; then
	branch_version="${branch:8}"
	branch="R"
else
	branch="O" # other branch
fi

if [ "$status" != "" ]; then # uncommitted changes
	symbols="${symbols}🙊"
	annotations="${annotations}U" 
fi

if [ "$CONFIGURATION" == "Debug" ]; then
	symbols="${symbols}🐞"
	annotations="${annotations}D"
elif [ "$CONFIGURATION" == "Release" ]; then
	symbols="${symbols}🐶"
	annotations="${annotations}R"
else
	symbols="${symbols}😱" # unknown configuration used!!
	annotations="${annotations}?"
fi

if [ "$annotations" != "" ]; then
	annotations="+${annotations}"
fi

# Put together our build identifier
build_identifier="${branch}${commit}"
build_identifier=$(echo $build_identifier | awk 'BEGIN { getline; print toupper($0) }')

build_identifier_symbols="${build_identifier}${symbols}"
build_identifier_annotations="${build_identifier}${annotations}"

target_plist="${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"
dsym_plist="${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Info.plist"

# Put together our CFBundleShorVersionString
if [ -f "$target_plist" ]; then
	bundle_short_version=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "$target_plist")
else
	echo "error: Not found: ${target_plist}"
fi

short_version_parts=( ${bundle_short_version//./ } )

if [ "${#short_version_parts[@]}" == "2" ]; then
	short_version_parts[2]="0"
fi

((major_minor=short_version_parts[0]*100+short_version_parts[1]))
bundle_version="${major_minor}.${short_version_parts[2]}"

if [ "$branch" == "R" ]; then
	bundle_version="${bundle_version}.${commit_count}"

	# Make sure we don't have a mismatch between release branch version and the one in the plist
	branch_version_parts=( ${branch_version//./ } )

	if [ "${branch_version_parts[0]}" == "${short_version_parts[0]}" ] && [ "${branch_version_parts[1]}" == "${short_version_parts[1]}" ] && [ "${branch_version_parts[2]}" == "${short_version_parts[2]}" ]; then
		echo "Release branch: release/${branch_version}, CFBundleShortVersionString: ${bundle_short_version}"
	else
		version_mismatch_message="Release branch ${branch_version} does not match CFBundleShortVersionString ${bundle_short_version}"

		if [ "$CONFIGURATION" == "Release" ]; then
			echo "error: ${version_mismatch_message}"
			exit 1
		else
			echo "warning: ${version_mismatch_message}"
		fi
	fi
else
	bundle_version="${bundle_version}.${commit}"
fi

# Uncommited changes
if [ "$status" != "" ]; then
	if [ "$CONFIGURATION" == "Release" ]; then
		echo "error: Uncommitted changes, can't build in Release configuration!"
		exit 1
	fi

	bundle_version="${bundle_version}u"
fi

# Write to plists
for plist in "$target_plist" "$dsym_plist"; do
	if [ -f "$plist" ]; then
		current_identifier=$(/usr/libexec/PlistBuddy -c "Print :SCBuildIdentifier" "${plist}" 2>/dev/null)

		if [ $? == 0 ]; then
			plist_command_prefix="Set :SCBuildIdentifier"
		else
			plist_command_prefix="Add :SCBuildIdentifier string"
		fi

		/usr/libexec/PlistBuddy -c "${plist_command_prefix} ${build_identifier_symbols}" "${plist}"
		/usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${bundle_version}" "${plist}"
	elif [ "$plist" = "$target_plist" ]; then
		echo "error: Not found: $plist"
		exit 1
	fi
done

echo "Build Identifier: ${build_identifier_symbols} (${build_identifier_annotations})"
echo "Bundle Version: ${bundle_version}"

exit 0
