//
//  Helpers.swift
//  Neko
//
//  Created by Arthur Langereis on 2015/3/9.
//  Copyright (c) 2015 logic-dream. All rights reserved.
//

import Foundation


open class Timer {
	// each instance has its own handler
	fileprivate var handler: (_ timer: Foundation.Timer) -> () = { (timer: Foundation.Timer) in }
	
	open class func start(_ duration: TimeInterval, repeats: Bool, handler:@escaping (_ timer: Foundation.Timer)->()) {
		let t = Timer()
		t.handler = handler
		Foundation.Timer.scheduledTimer(timeInterval: duration, target: t, selector: #selector(Timer.processHandler(_:)), userInfo: nil, repeats: repeats)
	}
	
	@objc fileprivate func processHandler(_ timer: Foundation.Timer) {
		self.handler(timer)
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

	func dot(_ other: Vec2) -> Float {
		return (x * other.x) + (y * other.y)
	}

	func squaredDistanceTo(_ other: Vec2) -> Float {
		let sdist = self - other
		return sdist.dot(sdist)
	}
	
	func distanceTo(_ other: Vec2) -> Float {
		return sqrt(squaredDistanceTo(other))
	}
	
	func length() -> Float {
		return distanceTo(Vec2.Zero)
	}
	
	func normalized() -> Vec2 {
		return self / length()
	}
	
	func angleTo(_ other: Vec2) -> Float {
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
