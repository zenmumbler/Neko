//
//  NekoMind.swift
//  Neko
//
//  Created by Arthur Langereis on 2015/3/4.
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


enum NekoState {
	case Idle
	case GoingToSleep
	case Sleeping
	case WakingUp

//	case Startled
//	case Running
}


protocol NekoMindNotifications {
	func stateDidChange(sender: NekoMind)
}


class NekoMind {
	private var state_ = NekoState.Idle
	private var lastStateChange_ = NSDate()
	var listener: NekoMindNotifications?
	
	var state: NekoState {
		get {
			return state_
		}
		
		set {
			state_ = newValue
			lastStateChange_ = NSDate()
			act()
			
			listener?.stateDidChange(self)
		}
	}
	
	var lastStateChange: NSDate { return lastStateChange_ }
	
	init() {}
	
	func awaken() {
		state = .Idle
	}
	
	private func schedule(fromNow: NSTimeInterval, block: () -> ()) {
		Timer.start(fromNow, repeats: false) { timer in block() }
	}
	
	private func act() {
		switch state_ {
			case .Idle:
				schedule(4) { self.state = .GoingToSleep }
			case .GoingToSleep:
				schedule(0.8) { self.state = .Sleeping }
			case .Sleeping:
				schedule(4) { self.state = .WakingUp }
			case .WakingUp:
				schedule(0.8) { self.state = .Idle }
		}
	}
}
