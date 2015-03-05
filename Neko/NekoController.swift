//
//  NekoController.swift
//  Neko
//
//  Created by Arthur Langereis on 2015/3/3.
//  Copyright (c) 2015 logic-dream. All rights reserved.
//

import Cocoa

class NekoController : NSViewController, NekoMindNotifications {

	weak var nekoView: NekoView!
	var mind = NekoMind()
	
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

	override func loadView() {
		mind.listener = self

		view = NekoView(frame: NSMakeRect(0, 0, 64, 64))
		nekoView = view as NekoView // weak alias typed to subclass

		let cats = NSImage(named: "cats.png")
		nekoView.useCatAtlasTexture(cats!)
		
		mind.awaken()
	}

}


/*

Get list of all open windows
http://stackoverflow.com/a/11403271

CFArrayRef windows =
	CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly |
		kCGWindowListExcludeDesktopElements,
		kCGNullWindowID);

*/
