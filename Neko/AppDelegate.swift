//
//  AppDelegate.swift
//  Neko
//
//  Created by Arthur Langereis on 2015/3/3.
//  Copyright (c) 2015 logic-dream. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	var nekoWindow: NekoWindow!
	var nekoController: NekoController!

	func applicationDidFinishLaunching(aNotification: NSNotification) {
		let nekoRect = NSMakeRect(500, 500, 64, 64)
		nekoWindow = NekoWindow(contentRect: nekoRect, styleMask: NSBorderlessWindowMask, backing: NSBackingStoreType.Buffered, defer: false)

		nekoController = NekoController()
		nekoWindow.contentView = nekoController.view

		nekoWindow.makeKeyAndOrderFront(nil)
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}

}
