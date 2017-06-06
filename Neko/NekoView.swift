//
//  NekoView.swift
//  Neko
//
//  Created by Arthur Langereis on 2015/3/3.
//  Copyright (c) 2015 logic-dream. All rights reserved.
//

import Cocoa

enum NekoFrameIndex : Int {
	case play
	case surprise
	case sleep1
	case sleep2
	case scratchSelf1
	case scratchSelf2
	case sit
	case yawn

	case scratchLeft1
	case scratchLeft2
	case scratchBottom1
	case scratchBottom2
	case scratchRight1
	case scratchRight2
	case scratchTop1
	case scratchTop2

	case runNorthWest1
	case runNorthWest2
	case runWest1
	case runWest2
	case runSouthWest1
	case runSouthWest2
	case runSouth1
	case runSouth2
	case runSouthEast1
	case runSouthEast2
	case runEast1
	case runEast2
	case runNorthEast1
	case runNorthEast2
	case runNorth1
	case runNorth2
}


enum NekoAnimation {
	case idle
	case yawning
	case surprised
	case sleeping
	case cleaning
	case playing
	
	case scratchingNorth
	case scratchingWest
	case scratchingSouth
	case scratchingEast
	
	case runningNorth
	case runningNorthWest
	case runningWest
	case runningSouthWest
	case runningSouth
	case runningSouthEast
	case runningEast
	case runningNorthEast
}


class NekoView : NSView {
	var scale: CGFloat = 1 {
		didSet {
			let curFrame = (window?.frame)!
			let newSize = NSMakeRect(curFrame.origin.x, curFrame.origin.y, 32 * scale, 32 * scale)
			window?.setFrame(newSize, display: true)
		}
	}

	fileprivate var animStartTime = Date.timeIntervalSinceReferenceDate
	var animation: NekoAnimation = .sleeping {
		didSet {
			// reset animation start time
			animStartTime = Date.timeIntervalSinceReferenceDate
			setNeedsDisplay(frame)
		}
	}

	fileprivate let animFrameMap: [NekoAnimation: (NekoFrameIndex, NekoFrameIndex)] = [
		.idle:      (.sit, .sit),
		.yawning:   (.yawn, .yawn),
		.surprised: (.surprise, .surprise),
		.sleeping:  (.sleep1, .sleep2),
		.cleaning:  (.scratchSelf1, .scratchSelf2),
		.playing:   (.play, .sit),
		
		.scratchingNorth: (.scratchTop1, .scratchTop2),
		.scratchingWest:  (.scratchLeft1, .scratchLeft2),
		.scratchingSouth: (.scratchBottom1, .scratchBottom2),
		.scratchingEast:  (.scratchRight1, .scratchRight2),
		
		.runningNorth:     (.runNorth1, .runNorth2),
		.runningNorthWest: (.runNorthWest1, .runNorthWest2),
		.runningWest:      (.runWest1, .runWest2),
		.runningSouthWest: (.runSouthWest1, .runSouthWest2),
		.runningSouth:     (.runSouth1, .runSouth2),
		.runningSouthEast: (.runSouthEast1, .runSouthEast2),
		.runningEast:      (.runEast1, .runEast2),
		.runningNorthEast: (.runNorthEast1, .runNorthEast2)
	]
	
	fileprivate var catFrames: [CGImage] = []
	
	fileprivate func animationFrameTime() -> TimeInterval {
		// duration of each frame in seconds
		switch animation {
			case .idle, .yawning, .surprised:
				return 99.0
			case .sleeping:
				return 1.0
			case .scratchingNorth, .scratchingWest, .scratchingSouth, .scratchingEast:
				return 0.3
			default:
				return 0.5
		}
	}
	
	fileprivate var frameIndex: Int {
		let frames = animFrameMap[animation]!
		let interval = Date.timeIntervalSinceReferenceDate - animStartTime
		let index = Int(round(interval.truncatingRemainder(dividingBy: (2 * animationFrameTime())) / animationFrameTime()))
		return index == 0 ? frames.0.rawValue : frames.1.rawValue
	}

	func useCatlasTexture(_ catsAtlas: NSImage) {
		// create 32 frames from the atlas image provided
		var imageRect = CGRect(x: 0, y: 0, width: catsAtlas.size.width, height: catsAtlas.size.height)
		let cgi = catsAtlas.cgImage(forProposedRect: &imageRect, context: nil, hints: nil)
		
		for y in 0...15 {
			let yTop = 32.0 * CGFloat(y)

			for x in 0...1 {
				let xLeft = 32.0 * CGFloat(x)
				let subRect = CGRect(x: xLeft, y: yTop, width: 32, height: 32)
				
				let subImage = cgi?.cropping(to: subRect)
				catFrames.append(subImage!)
			}
		}
	}
	
	@objc func nextFrame(_ timer: Foundation.Timer!) {
		setNeedsDisplay(frame)
	}
	
	var hotSpot: CGPoint {
		let winFrame = window!.frame
		
		// convert window origin point to desktop coordinate space
		var catHotSpot = winFrame.origin
		catHotSpot.y = (NSScreen.main?.frame.size.height)! - catHotSpot.y
		
		// use x-center and near-bottom as cat focus point
		catHotSpot.x += bounds.size.width / 2
		catHotSpot.y -= 4 * scale
		
		return catHotSpot
	}
	
	override func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)

		let ctx = NSGraphicsContext.current?.cgContext

		let windowBounds = (window?.frame)!
		ctx?.draw(catFrames[frameIndex], in: NSMakeRect(0, 0, windowBounds.size.width, windowBounds.size.height))
		
		let nextFrameTime = Date(timeIntervalSinceNow: animationFrameTime())
		let nextFrame = Foundation.Timer(fireAt: nextFrameTime, interval: 0, target: self, selector: #selector(NekoView.nextFrame(_:)), userInfo: nil, repeats: false)
		RunLoop.current.add(nextFrame, forMode: RunLoopMode.defaultRunLoopMode)
		
		// TODO: kill this timer when animation changes
	}
	
	override var mouseDownCanMoveWindow: Bool { return true }
}
