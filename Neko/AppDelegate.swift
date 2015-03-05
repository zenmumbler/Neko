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

	@IBOutlet weak var statusMenu: NSMenu!
	var statusItem: NSStatusItem!
	
	func setupStatusMenu() {
		let statusBar = NSStatusBar.systemStatusBar()
		
		statusItem = statusBar.statusItemWithLength(-1)
		statusItem.menu = statusMenu
		let menuIcon = NSImage(named: "AppIcon")
		menuIcon?.size = NSMakeSize(16, 16)
		menuIcon?.setTemplate(true)
		statusItem.image = menuIcon
	}

	func applicationDidFinishLaunching(aNotification: NSNotification) {
		let nekoRect = NSMakeRect(500, 500, 64, 64)
		nekoWindow = NekoWindow(contentRect: nekoRect, styleMask: NSBorderlessWindowMask, backing: NSBackingStoreType.Buffered, defer: false)

		nekoController = NekoController()
		nekoWindow.contentView = nekoController.view
		
		setupStatusMenu()

		nekoWindow.makeKeyAndOrderFront(nil)
	}

	@IBAction func setBehaviour(sender: NSMenuItem) {
		if (sender.title == "Contextual") {
			NSLog("CTX")
		}
		else {
			NSLog("CHASE")
		}
	}
	
	@IBAction func setScale(sender: NSMenuItem) {
		var scale = 1
		if (sender.title == "2x") {
			scale = 2
		}
		
		// TODO: apply scale
	}
	
	@IBAction func setCatLayer(sender: NSMenuItem) {
		if (sender.title == "On Desktop") {
			nekoWindow.level = kCGDesktopWindowLevelKey
		}
		else {
			nekoWindow.level = kCGScreenSaverWindowLevelKey
		}
		
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}

}
