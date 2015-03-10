//
//  Helpers.swift
//  Neko
//
//  Created by Arthur Langereis on 2015/3/9.
//  Copyright (c) 2015 logic-dream. All rights reserved.
//

import Foundation


public class Timer {
	// each instance has its own handler
	private var handler: (timer: NSTimer) -> () = { (timer: NSTimer) in }
	
	public class func start(duration: NSTimeInterval, repeats: Bool, handler:(timer: NSTimer)->()) {
		var t = Timer()
		t.handler = handler
		NSTimer.scheduledTimerWithTimeInterval(duration, target: t, selector: "processHandler:", userInfo: nil, repeats: repeats)
	}
	
	@objc private func processHandler(timer: NSTimer) {
		self.handler(timer: timer)
	}
}


public struct Vec2 {
	var x, y: Float
	
	static let Zero = Vec2(x: 0, y: 0)

	init() {
		x = 0
		y = 0
	}
	
	init(x: Float, y: Float) {
		self.x = x
		self.y = y
	}

	init(point: CGPoint) {
		x = Float(point.x)
		y = Float(point.y)
	}

	func dot(other: Vec2) -> Float {
		return (x * other.x) + (y * other.y)
	}

	func squaredDistanceTo(other: Vec2) -> Float {
		let sdist = self - other
		return sdist.dot(sdist)
	}
	
	func distanceTo(other: Vec2) -> Float {
		return sqrt(squaredDistanceTo(other))
	}
	
	func length() -> Float {
		return distanceTo(Vec2.Zero)
	}
	
	func normalized() -> Vec2 {
		return self / length()
	}
	
	func angleTo(other: Vec2) -> Float {
		let cosTh = self.normalized().dot(other.normalized())
		return cosTh < 0 ? acos(-cosTh) : acos(cosTh)
	}
}

func -(a: Vec2, b: Vec2) -> Vec2 {
	return Vec2(x: a.x - b.x, y: a.y - b.y)
}

func +(a: Vec2, b: Vec2) -> Vec2 {
	return Vec2(x: a.x + b.x, y: a.y + b.y)
}

func /(v: Vec2, scalar: Float) -> Vec2 {
	return Vec2(x: v.x / scalar, y: v.y / scalar)
}
