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

import Cocoa
import CoreGraphics

class BlankedScreen: NSObject, NSWindowDelegate {
	public private(set) static var activeScreens: [CGDirectDisplayID : BlankedScreen] = [:]
	
	public static func find(_ displayID: CGDirectDisplayID?) -> BlankedScreen? {
		guard let displayID = displayID else { return nil }
		
		if let screen = findActive(displayID) {
			return screen
		}
		
		if let screen = BlankedScreen(displayID: displayID) {
			return screen
		}
		
		return nil
	}
	
	public static func findActive(_ displayID: CGDirectDisplayID?) -> BlankedScreen? {
		guard let displayID = displayID else { return nil }

		if let screen = activeScreens[displayID] {
			return screen
		}
		
		return nil
	}
	
	public static func isBlanked(_ displayID: CGDirectDisplayID) -> Bool {
		return findActive(displayID) != nil
	}
	
	public static func blankAll(excluding excludedID: CGDirectDisplayID? = nil) {
		var errors = [Error]()
		
		for screen in NSScreen.screens {
			if let blankedScreen = BlankedScreen.find(screen.displayID) {
				if excludedID == nil || blankedScreen.displayID != excludedID {
					do {
						try blankedScreen.blank()
					} catch let err {
						errors.append(err)
					}
				}
			}
		}
		
		if errors.count > 0 {
			for err in errors {
				print("Blanking error: \(err)")
			}
		}
	}
	
	public static func unblankAll(excluding excludedID: CGDirectDisplayID? = nil) {
		for screen in activeScreens.values {
			if excludedID == nil || screen.displayID != excludedID {
				screen.unblank()
			}
		}
	}
	
	enum BlankingError: Error {
		case screenMismatch
		case unableToCreateWindow
	}
	
	public let displayID: CGDirectDisplayID
	public let screen: NSScreen
	public private(set) var window: NSWindow?
	
	public var isBlanked: Bool {
		return BlankedScreen.isBlanked(displayID)
	}
	
	private init?(displayID: CGDirectDisplayID) {
		self.displayID = displayID
		guard let screen = NSScreen.findScreen(displayID: displayID) else { return nil }
		self.screen = screen
		
		super.init()
	}
	
	public func blank() throws {
		createWindow()
		
		guard let window = window else { throw BlankingError.unableToCreateWindow }
		
		window.makeKeyAndOrderFront(self)
		
		if window.screen != screen {
			destroyWindow()
			
			throw BlankingError.screenMismatch
		}
		
		markBlanked(true)
	}
	
	public func unblank() {
		destroyWindow()
	}
	
	private func createWindow() {
		guard window == nil else { return }
		
		window = BlankingWindow(screen: screen)
		window?.delegate = self
	}

	private func destroyWindow() {
		guard let window = window else { return }
		
		window.orderOut(self)
		
		window.delegate = nil
		self.window = nil
		
		markBlanked(false)
	}

	private func markBlanked(_ flag: Bool) {
		if flag {
			BlankedScreen.activeScreens[displayID] = self
		} else {
			BlankedScreen.activeScreens.removeValue(forKey: displayID)
		}
	}
	
	func windowDidChangeScreen(_ notification: Notification) {
		guard let window = window else { return }
		guard let newScreenID = window.screen?.displayID else { return }
		guard newScreenID != displayID else { return }
		
		#if DEBUG
			print("Blanking window changed screens, removing now.")
			print("- Window: \(window)")
			print("- newScreen: \(newScreenID), previousScreen: \(displayID)=")
		#endif
		
		destroyWindow()
	}
}
