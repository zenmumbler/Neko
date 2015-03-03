//
//  NekoView.swift
//  Neko
//
//  Created by Arthur Langereis on 2015/3/3.
//  Copyright (c) 2015 logic-dream. All rights reserved.
//

import Cocoa

enum CatFrameIndex : Int {
	case Play
	case Surprise
	case Sleep1
	case Sleep2
	case ScratchSelf1
	case ScratchSelf2
	case Sit
	case Yawn

	case ScratchLeft1
	case ScratchLeft2
	case ScratchBottom1
	case ScratchBottom2
	case ScratchRight1
	case ScratchRight2
	case ScratchTop1
	case ScratchTop2

	case RunNorthWest1
	case RunNorthWest2
	case RunWest1
	case RunWest2
	case RunSouthWest1
	case RunSouthWest2
	case RunSouth1
	case RunSouth2
	case RunSouthEast1
	case RunSouthEast2
	case RunEast1
	case RunEast2
	case RunNorthEast1
	case RunNorthEast2
	case RunNorth1
	case RunNorth2
}


enum CatAnimation {
	case Idle
	case Yawning
	case Surprised
	case Sleeping
	case Cleaning
	case Playing
	
	case ScratchingNorth
	case ScratchingWest
	case ScratchingSouth
	case ScratchingEast
	
	case RunningNorth
	case RunningNorthWest
	case RunningWest
	case RunningSouthWest
	case RunningSouth
	case RunningSouthEast
	case RunningEast
	case RunningNorthEast
}


class NekoView : NSView {
	private var catFrames: [CGImage] = []
	
	var animation: CatAnimation = .Sleeping

	private static let animFrameMap: [CatAnimation: (CatFrameIndex, CatFrameIndex)] = [
		.Idle:      (.Sit, .Sit),
		.Yawning:   (.Yawn, .Yawn),
		.Surprised: (.Surprise, .Surprise),
		.Sleeping:  (.Sleep1, .Sleep2),
		.Cleaning:  (.ScratchSelf1, .ScratchSelf2),
		.Playing:   (.Play, .Sit),
		
		.ScratchingNorth: (.ScratchTop1, .ScratchTop2),
		.ScratchingWest:  (.ScratchLeft1, .ScratchLeft2),
		.ScratchingSouth: (.ScratchBottom1, .ScratchBottom2),
		.ScratchingEast:  (.ScratchRight1, .ScratchRight2),
		
		.RunningNorth:     (.RunNorth1, .RunNorth2),
		.RunningNorthWest: (.RunNorthWest1, .RunNorthWest2),
		.RunningWest:      (.RunWest1, .RunWest2),
		.RunningSouthWest: (.RunSouthWest1, .RunSouthWest2),
		.RunningSouth:     (.RunSouth1, .RunSouth2),
		.RunningSouthEast: (.RunSouthEast1, .RunSouthEast2),
		.RunningEast:      (.RunEast1, .RunEast2),
		.RunningNorthEast: (.RunNorthEast1, .RunNorthEast2)
	]
	
	private var frameIndex: Int {
		let frames = NekoView.animFrameMap[animation]
		return frames?.0.rawValue ?? 0
	}

	func useCatAtlasTexture(catsAtlas: NSImage) {
		// create 32 frames from the atlas image provided
		var imageRect = CGRectMake(0, 0, catsAtlas.size.width, catsAtlas.size.height)
		let cgi = catsAtlas.CGImageForProposedRect(&imageRect, context: nil, hints: nil)?.takeRetainedValue()
		
		for y in 0...15 {
			let yTop = 32.0 * CGFloat(y)

			for x in 0...1 {
				let xLeft = 32.0 * CGFloat(x)
				let subRect = CGRectMake(xLeft, yTop, 32, 32)
				
				let subImage = CGImageCreateWithImageInRect(cgi, subRect)
				catFrames.append(subImage)
			}
		}
	}
	
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

		let ctx = NSGraphicsContext.currentContext()?.CGContext
		let sizedIconFrame = CGRectMake(0, 0, 64, 64)

		CGContextDrawImage(ctx, sizedIconFrame, catFrames[frameIndex])
    }
}
