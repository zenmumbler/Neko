//
//  NekoWindow.swift
//  Neko
//
//  Created by Arthur Langereis on 2015/3/4.
//  Copyright (c) 2015 logic-dream. All rights reserved.
//

import Cocoa

class NekoWindow : NSWindow {

	override init(contentRect: NSRect, styleMask aStyle: NSWindowStyleMask, backing bufferingType: NSBackingStoreType, defer flag: Bool) {
		super.init(contentRect: contentRect, styleMask: aStyle, backing: bufferingType, defer: flag)
		
		isOpaque = false
		backgroundColor = NSColor.clear
		isMovableByWindowBackground = true
		level = Int(CGWindowLevelKey.screenSaverWindow.rawValue)
	}

	override var canBecomeMain: Bool {
		return true
	}

	override var canBecomeKey: Bool {
		return true
	}
}
