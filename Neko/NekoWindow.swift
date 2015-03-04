//
//  NekoWindow.swift
//  Neko
//
//  Created by Arthur Langereis on 2015/3/4.
//  Copyright (c) 2015 logic-dream. All rights reserved.
//

import Cocoa

class NekoWindow : NSWindow {

	override init(contentRect: NSRect, styleMask aStyle: Int, backing bufferingType: NSBackingStoreType, defer flag: Bool) {
		super.init(contentRect: contentRect, styleMask: aStyle, backing: bufferingType, defer: flag)
		
		opaque = false
		backgroundColor = NSColor.clearColor()
		movableByWindowBackground = true
	}

	required init?(coder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

	override var canBecomeMainWindow: Bool {
		return true
	}

	override var canBecomeKeyWindow: Bool {
		return true
	}
}
