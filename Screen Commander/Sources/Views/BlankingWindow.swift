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
import SwiftyUserDefaults

class BlankingWindow: NSWindow {
	convenience init(screen: NSScreen) {
		self.init(contentRect: NSRect(origin: NSPoint.zero, size: screen.frame.size), styleMask: .borderless, backing: .buffered, defer: false, screen: screen)
		
		title = "Screen Commander"
		backgroundColor = NSColor.black
		canHide = false
		hidesOnDeactivate = false
		collectionBehavior = [.fullScreenPrimary, .canJoinAllSpaces, .transient, .fullScreenDisallowsTiling]
		contentView = BlankingView(frame: contentLayoutRect)
        level = NSWindow.Level(Int(CGWindowLevelForKey(.overlayWindow)))
		
		// center()
		// DO NOT invoke center(). This often causes other screen's windows to end up on the wrong screen!
	}
	
	func popUpContextMenu(with event: NSEvent) {
		guard let delegate = NSApp.delegate as? AppDelegate else { return }
		guard let view = contentView else { return }
		
		delegate.popUpContextMenu(event: event, view: view)
	}
	
	override func mouseDown(with event: NSEvent) {
		let clickOption = Defaults[\.screenMenuPopup] ?? .primaryClick
		guard clickOption == .primaryClick || clickOption == .primaryOrSecondaryClick else { return }
		
		popUpContextMenu(with: event)
	}
	
	override func rightMouseDown(with event: NSEvent) {
		let clickOption = Defaults[\.screenMenuPopup] ?? .primaryClick
		guard clickOption == .secondaryClick || clickOption == .primaryOrSecondaryClick else { return }
		
		popUpContextMenu(with: event)
	}
}
