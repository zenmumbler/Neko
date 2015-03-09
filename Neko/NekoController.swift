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
	func stateDidChange(sender: NekoMind) {
		switch sender.state {
			case .Idle:
				nekoView.animation = .Idle
			case .GoingToSleep:
				nekoView.animation = .Yawning
			case .Sleeping:
				nekoView.animation = .Sleeping
			case .WakingUp:
				nekoView.animation = .Yawning
		}
	}

	// query from the NekoMind
	func physicalLocation() -> CGPoint {
		let window = nekoView.window!
		let winFrame = window.frame
		let winBounds = nekoView.bounds

		// convert window origin point to desktop coordinate space
		var catHotSpot = winFrame.origin
		catHotSpot.y = (NSScreen.mainScreen()?.frame.size.height)! - catHotSpot.y

		// use x-center and near-bottom as cat focus point
		catHotSpot.x += winBounds.size.width / 2
		catHotSpot.y -= 4 * nekoView.scale
		
		return catHotSpot
	}

	// inform NekoMind of mouse position
	func mouseMovedToX(x: CGFloat, andY y: CGFloat) {
		mind.targetPosition = CGPointMake(x, y)
	}

	override func loadView() {
		mind = NekoMind(worldQueries: self)
		mind.listener = self

		view = NekoView(frame: NSMakeRect(0, 0, 64, 64))
		nekoView = view as! NekoView // weak alias typed to subclass

		let cats = NSImage(named: "cats.png")
		nekoView.useCatlasTexture(cats!)

		mind.awaken()
		
		mouseTracker.delegate = self
		mouseTracker.start()
	}

	func setScale(scale: Int) {
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
