//
//  NekoController.swift
//  Neko
//
//  Created by Arthur Langereis on 2015/3/3.
//  Copyright (c) 2015 logic-dream. All rights reserved.
//

import Cocoa

class NekoController : NSViewController, NekoMindNotifications, NekoMindQueries, MouseTrackerDelegate {

	weak var nekoView: NekoView!
	var mind: NekoMind!
	var mouseTracker = NekoMouseTracker()
	
	// notification from the NekoMind
	func stateDidChange(_ sender: NekoMind) {
		switch sender.state {
			case .idle:
				nekoView.animation = .idle
			case .goingToSleep:
				nekoView.animation = .yawning
			case .sleeping:
				nekoView.animation = .sleeping
			case .wakingUp:
				nekoView.animation = .yawning
		}
	}

	// query from the NekoMind
	func physicalLocation() -> CGPoint {
		return nekoView.hotSpot
	}

	// inform NekoMind of mouse position
	func mouseMovedTo(x: CGFloat, andY y: CGFloat) {
		mind.targetPosition = CGPoint(x: x, y: y)
	}

	override func loadView() {
		mind = NekoMind(worldQueries: self)
		mind.listener = self

		view = NekoView(frame: NSMakeRect(0, 0, 64, 64))
		nekoView = view as! NekoView // weak alias typed to subclass

		let cats = NSImage(named: NSImage.Name(rawValue: "cats.png"))
		nekoView.useCatlasTexture(cats!)

		mind.awaken()
		
		mouseTracker?.delegate = self
		mouseTracker?.start()
	}

	func setScale(_ scale: Int) {
		nekoView.scale = CGFloat(scale)
	}
}


/*

Get list of all open windows
http://stackoverflow.com/a/11403271

CFArrayRef windows =
	CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly |
		kCGWindowListExcludeDesktopElements,
		kCGNullWindowID);



Track mouse events without polling with an CGEventTap
https://developer.apple.com/library/mac/documentation/Carbon/Reference/QuartzEventServicesRef/index.html#//apple_ref/c/func/CGEventTapCreate

*/
