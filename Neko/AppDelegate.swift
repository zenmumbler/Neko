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
		let statusBar = NSStatusBar.system
		
		statusItem = statusBar.statusItem(withLength: -1)
		statusItem.menu = statusMenu
		let menuIcon = NSImage(named: NSImage.Name(rawValue: "AppIcon"))
		menuIcon?.size = NSMakeSize(16, 16)
		menuIcon?.isTemplate = true
		statusItem.image = menuIcon
	}

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		let nekoRect = NSMakeRect(500, 500, 64, 64)
		nekoWindow = NekoWindow(contentRect: nekoRect, styleMask: NSWindow.StyleMask.borderless, backing: NSWindow.BackingStoreType.buffered, defer: false)

		nekoController = NekoController()
		nekoWindow.contentView = nekoController.view
		
		setupStatusMenu()

		nekoWindow.makeKeyAndOrderFront(nil)
	}

	@IBAction func setBehaviour(_ sender: NSMenuItem) {
		if (sender.title == "Contextual") {
			NSLog("CTX")
		}
		else {
			NSLog("CHASE")
		}
	}
	
	@IBAction func setScale(_ sender: NSMenuItem) {
		var scale = 1
		if (sender.title == "2x") {
			scale = 2
		}
		
		nekoController.setScale(scale)
	}
	
	@IBAction func setCatLayer(_ sender: NSMenuItem) {
		if (sender.title == "On Desktop") {
			nekoWindow.level = Int(CGWindowLevelKey.desktopWindow.rawValue)
		}
		else {
			nekoWindow.level = Int(CGWindowLevelKey.screenSaverWindow.rawValue)
		}
		
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}

}
