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
import ServiceManagement
import SwiftyUserDefaults

enum ShowScreenMenuPopupOption: Int, DefaultsSerializable, Codable {
	case primaryClick = 10
	case secondaryClick = 15
	case primaryOrSecondaryClick = 20
    
    public static var _defaults: DefaultsCodableBridge<Self> { return DefaultsCodableBridge() }
    public static var _defaultsArray: DefaultsCodableBridge<[Self]> { return DefaultsCodableBridge() }
}

extension DefaultsKeys {
    var hasPromptedForLoginLaunch: DefaultsKey<Bool> { .init("hasPromptedForLoginLaunch", defaultValue: false) }
    var screenMenuPopup: DefaultsKey<ShowScreenMenuPopupOption?> { .init("screenMenuPopup") }
}

class PrefsController: NSWindowController, NSWindowDelegate {
	static public let shared = PrefsController()

	@IBOutlet weak var launchAtLoginCheckbox: NSButton?
	@IBOutlet weak var buttonClickPopUpButton: NSPopUpButton?
	
	private let bundleIdentifier = BundleIdentifier.helperApp.rawValue
	
	// http://stackoverflow.com/questions/36376735/login-item-cocoa
	@available(OSX, deprecated: 10.10)
	public var launchesAtLogin: Bool {
		get {
			guard let jobs = SMCopyAllJobDictionaries(kSMDomainUserLaunchd).takeRetainedValue() as NSArray as? [[String : AnyObject]] else { return false }
			
			return jobs.filter {
				if let label = $0["Label"] as? String {
					return label == bundleIdentifier
				} else {
					return false
				}
			}.isEmpty == false
		}
		
		set {
			if !SMLoginItemSetEnabled(bundleIdentifier as CFString, newValue) {
				let alert = NSAlert()

                alert.messageText = L10n.launchAtLoginErrorAlertTitle(newValue ? L10n.launchAtLoginErrorAlertEnable : L10n.launchAtLoginErrorAlertDisable)
                alert.informativeText = L10n.launchAtLoginErrorAlertMessage(newValue ? L10n.launchAtLoginErrorAlertRegister : L10n.launchAtLoginErrorAlertUnregister)
				
				alert.runModal()
			}
		}
	}
	
	private convenience init() {
		self.init(windowNibName: "Preferences")
	}
	
	override func windowDidLoad() {
		window?.delegate = self
        window?.level = NSWindow.Level(Int(CGWindowLevelForKey(.overlayWindow) + 1))
	}
	
	@available(OSX, deprecated: 10.10)
	override func showWindow(_ sender: Any?) {
		reloadDefaults()
		super.showWindow(sender)
	}
	
	@available(OSX, deprecated: 10.10)
	func reloadDefaults() {
        launchAtLoginCheckbox?.state = launchesAtLogin ? NSControl.StateValue.on : NSControl.StateValue.off
		buttonClickPopUpButton?.selectItem(withTag: Defaults[\.screenMenuPopup]?.rawValue ?? ShowScreenMenuPopupOption.primaryClick.rawValue)
	}
	
	// MARK: - IB Actions
	
	@available(OSX, deprecated: 10.10)
	@IBAction func toggleLaunchAtLogin(_ sender: AnyObject?) {
		guard let state = launchAtLoginCheckbox?.state else { return }
		
		launchesAtLogin = state == NSControl.StateValue.on ? true : false
	}
	
	@IBAction func changeButtonClickPopUpButton(_ sender: AnyObject?) {
		guard let sender = sender as? NSPopUpButton else { return }
		guard let tag = sender.selectedItem?.tag else { return }
		
		Defaults[\.screenMenuPopup] = ShowScreenMenuPopupOption(rawValue: tag)
	}
}
