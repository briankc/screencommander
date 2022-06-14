/*
 * This file is part of the Screen Commander project.
 * Copyright (c) 2017-2022 Brian Christensen
 * Author: Brian Christensen <bkc@xensen.net>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * In addition, this program is also subject to certain additional terms.
 * You should have received a copy of these additional terms immediately
 * following the terms and conditions of the GNU General Public License
 * which accompanied this program.  If not, please request a copy in
 * writing from the Author at the above e-mail address.
 */

import Foundation

import Quick
import Nimble
import Cocoa
@testable import Screen_Commander

class NSRectSpec: QuickSpec {
	override func spec() {
		describe("NSRect") {
			it("should return rect centered in rect") {
				let rect1 = NSRect(origin: NSPoint.zero, size: NSSize(width: 500.0, height: 500.0))
				let rect2 = NSRect(origin: NSPoint.zero, size: NSSize(width: 250.0, height: 250.0))
				let centered = rect2.centering(inRect: rect1)
				
				expect(centered.origin.x) ≈ (125.0, 0.01)
				expect(centered.origin.y) ≈ (125.0, 0.01)
				expect(centered.size.width) ≈ (250.0, 0.01)
				expect(centered.size.height) ≈ (250.0, 0.01)
			}
		}
	}
}
