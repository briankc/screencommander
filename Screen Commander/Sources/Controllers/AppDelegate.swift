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
import SwiftyUserDefaults

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate, NSMenuItemValidation {
	enum MenuItems: Int {
		case blankThisScreen = 1000
		case unblankThisScreen = 1001
		case blankOthers = 1100
		case unblankOthers = 1101
		case blankAll = 1200
		case unblankAll = 1201
		case debugMenu = 68040
	}
	
	@IBOutlet weak var statusMenu: NSMenu?
	
	private let statusItem = StatusItem(image: NSImage(named:	"StatusBarIconTemplate"))
	private var observedScreenID: CGDirectDisplayID?
	private var contextScreenID: CGDirectDisplayID?

	private var currentScreenID: CGDirectDisplayID? {
		return contextScreenID ?? (observedScreenID ?? NSScreen.main?.displayID)
	}
	
	private var currentScreen: NSScreen? {
		if let displayID = currentScreenID {
			return NSScreen.findScreen(displayID: displayID)
		}
		
		return nil
	}
	
	@available(OSX, deprecated: 10.10)
	func presentLoginLaunchPrompt() {
		guard Defaults[\.hasPromptedForLoginLaunch] == false else { return }
		guard PrefsController.shared.launchesAtLogin == false else { return }
		
		let alert = NSAlert()
		
		alert.alertStyle = .informational
        alert.messageText = L10n.launchAtLoginPromptAlertTitle
        alert.informativeText = L10n.launchAtLoginPromptAlertMessage
		
        alert.addButton(withTitle: L10n.launchAtLoginPromptAlertPrimaryButton)
        alert.addButton(withTitle: L10n.launchAtLoginPromptAlertSecondaryButton)
		
		let response = alert.runModal()
		
        if response == NSApplication.ModalResponse.alertFirstButtonReturn {
			PrefsController.shared.launchesAtLogin = true
		}
		
		Defaults[\.hasPromptedForLoginLaunch] = true
	}
	
	// MARK: - App Delegate

	@available(OSX, deprecated: 10.10)
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		statusItem.menu = statusMenu
		
		#if DEBUG
			statusItem.menu?.item(withTag: MenuItems.debugMenu.rawValue)?.isHidden = false
		#endif
		
        NotificationCenter.default.addObserver(forName: NSMenu.didBeginTrackingNotification, object: statusItem.menu, queue: nil) { _ in
			self.observedScreenID = self.statusItem.systemStatusItem.button?.window?.screen?.displayID

			guard let screenID = self.currentScreenID else { return }
			guard let menu = self.statusItem.menu else { return }

			let isBlanked = BlankedScreen.activeScreens[screenID] != nil
			
			menu.item(withTag: MenuItems.blankThisScreen.rawValue)?.isHidden = isBlanked
			menu.item(withTag: MenuItems.unblankThisScreen.rawValue)?.isHidden = !isBlanked
		}
		
		presentLoginLaunchPrompt()
	}
	
	// MARK: - Contextual Menu Tracking
	
	public func popUpContextMenu(event: NSEvent, view: NSView) {
		guard let menu = statusMenu else { return }
		guard let screenID = view.window?.screen?.displayID else { return }
		
		contextScreenID = screenID
		NSMenu.popUpContextMenu(menu, with: event, for: view)
		contextScreenID = nil
	}
	
	// MARK: - IB Actions
	
	@IBAction func toggleThisScreen(sender: AnyObject?) {
		guard let screen = BlankedScreen.find(currentScreenID) else { return }
		
		if screen.isBlanked {
			screen.unblank()
		} else {
			do {
				try screen.blank()
			} catch let err {
				presentBlankingError(err)
			}
		}
	}
	
	@IBAction func blankOtherScreens(sender: AnyObject?) {
		guard let screenID = currentScreenID else { return }
		
		BlankedScreen.blankAll(excluding: screenID)
	}
	
	@IBAction func unblankOtherScreens(sender: AnyObject?) {
		guard let screenID = currentScreenID else { return }
		
		BlankedScreen.unblankAll(excluding: screenID)
	}
	
	@IBAction func blankAllScreens(sender: AnyObject?) {
		BlankedScreen.blankAll()
	}
	
	@IBAction func unblankAllScreens(sender: AnyObject?) {
		BlankedScreen.unblankAll()
	}
	
	@available(OSX, deprecated: 10.10)
	@IBAction func showPreferences(sender: AnyObject?) {
		PrefsController.shared.presentWindow(onScreen: currentScreen)
	}
	
	@IBAction func showAboutPanel(sender: AnyObject?) {
		AboutBox.shared.presentWindow(onScreen: currentScreen)
	}
	
    func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
		guard let screenID = currentScreenID else { return false }
        guard let tag = MenuItems(rawValue: menuItem.tag) else { return true }
        
        let screenCount = NSScreen.screens.count
		let blankedCount = BlankedScreen.activeScreens.count
		
		if tag == .unblankOthers {
			return BlankedScreen.isBlanked(screenID) ? blankedCount > 1 : blankedCount > 0
		}
		
		if tag == .blankOthers {
			return BlankedScreen.isBlanked(screenID) ? blankedCount < screenCount : blankedCount < screenCount - 1
		}
		
		if tag == .blankAll {
			return blankedCount < screenCount
		}
		
		if tag == .unblankAll {
			return blankedCount > 0
		}
		
		return true
	}
	
	// MARK: - Debugging
	
	@IBAction func debugPrintScreenInfo(sender: AnyObject?) {
		#if DEBUG
			if let currentScreen = BlankedScreen.find(currentScreenID) {
				print("\(currentScreen): \(currentScreen.screen.deviceDescription)")
			}
		#endif
	}
	
	@IBAction func debugPresentBlankingError(sender: AnyObject?) {
		#if DEBUG
			presentBlankingError(BlankedScreen.BlankingError.screenMismatch)
		#endif
	}
	
	@IBAction func debugPrintBlankingWindows(sender: AnyObject?) {
		#if DEBUG
			for screenID in BlankedScreen.activeScreens.keys {
				print("\(screenID) : \(BlankedScreen.activeScreens[screenID]!)")
			}
		#endif
	}
	
	// MARK: - Errors
	
	func presentBlankingError(_ error: Error) {
		let alert = NSAlert()
		
        alert.messageText = L10n.blankingErrorAlertTitle
        alert.informativeText = L10n.blankingErrorAlertMessage(error.localizedDescription)
		
		alert.runModal()
	}
}
