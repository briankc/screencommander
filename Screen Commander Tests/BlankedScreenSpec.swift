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

import Quick
import Nimble
import Cocoa
@testable import Screen_Commander

class BlankedScreenSpec: QuickSpec {
	override func spec() {
		describe("BlankedScreen") {
			it("has no active screens") {
				expect(BlankedScreen.activeScreens.count).to(equal(0))
			}
			
			context("after blanking this screen") {
				var screen: BlankedScreen!
				
				beforeEach {
                    screen = BlankedScreen.find(NSScreen.main?.displayID)
					try! screen.blank()
				}
				
				afterEach {
					screen.unblank()
					screen = nil
				}
				
				it("has one active screen") {
					expect(BlankedScreen.activeScreens.count).to(equal(1))
				}
				
				it("is blanked") {
					expect(screen.isBlanked).to(beTrue())
				}
				
				it("matches main screen display ID") {
                    expect(screen.displayID).to(equal(NSScreen.main?.displayID))
				}
				
				it("matches findActive") {
                    expect(screen).to(equal(BlankedScreen.findActive(NSScreen.main?.displayID)))
				}
				
				it("has a visible window") {
					expect(screen.window).to(beAnInstanceOf(BlankingWindow.self))
					expect(screen.window?.isVisible).to(beTrue())
				}
			}
			
			context("after blanking and unblanking this screen") {
				var screen: BlankedScreen!
				
				beforeEach {
                    screen = BlankedScreen.find(NSScreen.main?.displayID)
					try! screen.blank()
					screen.unblank()
				}
				
				afterEach {
					screen = nil
				}
				
				it("has no active screens") {
					expect(BlankedScreen.activeScreens.count).to(equal(0))
				}
				
				it("is not blanked") {
					expect(screen.isBlanked).to(beFalse())
				}
				
				it("does not have a blanking window") {
					expect(screen.window).to(beNil())
				}
			}
			
			context("after blanking all screens") {
				beforeEach {
					BlankedScreen.blankAll()
				}
				
				afterEach {
					BlankedScreen.unblankAll()
				}
				
				it("has same number of active screens as there are NSScreens") {
                    expect(BlankedScreen.activeScreens.count).to(equal(NSScreen.screens.count))
				}
				
				it("has all active screens blanked with visible windows") {
					for screen in BlankedScreen.activeScreens.values {
						expect(screen.isBlanked).to(beTrue())
						expect(screen.window).to(beAnInstanceOf(BlankingWindow.self))
						expect(screen.window?.isVisible).to(beTrue())
					}
				}
			}
			
			context("after blanking and unblanking all screens") {
				beforeEach {
					BlankedScreen.blankAll()
					BlankedScreen.unblankAll()
				}
				
				it("has no active screens") {
					expect(BlankedScreen.activeScreens.count).to(equal(0))
				}
			}
			
			context("after blanking other screens") {
				var mainScreen: BlankedScreen!
				
				beforeEach {
                    mainScreen = BlankedScreen.find(NSScreen.main?.displayID)
					BlankedScreen.blankAll(excluding: mainScreen.displayID)
				}
				
				afterEach {
					BlankedScreen.unblankAll(excluding: mainScreen.displayID)
					mainScreen = nil
				}
				
				it("blanked the right number of displays") {
                    let screenCount = NSScreen.screens.count
					
					if screenCount == 1 {
						expect(BlankedScreen.activeScreens.count).to(equal(0))
					} else {
						expect(BlankedScreen.activeScreens.count).to(equal(screenCount - 1))
					}
				}
				
				it("did not blank the main screen") {
					expect(mainScreen.isBlanked).to(beFalse())
				}
			}
		}
	}
}
