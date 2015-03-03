//
//  NekoController.swift
//  Neko
//
//  Created by Arthur Langereis on 2015/3/3.
//  Copyright (c) 2015 logic-dream. All rights reserved.
//

import Cocoa

class NekoController : NSViewController {

	weak var nekoView: NekoView!

	override func loadView() {
		view = NekoView(frame: NSMakeRect(0, 0, 64, 64))
		nekoView = view as! NekoView // weak alias typed to subclass

		let cats = NSImage(named: "cats.png")
		nekoView.useCatAtlasTexture(cats!)
	}

}
