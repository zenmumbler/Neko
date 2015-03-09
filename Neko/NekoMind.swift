//
//  NekoMind.swift
//  Neko
//
//  Created by Arthur Langereis on 2015/3/4.
//  Copyright (c) 2015 logic-dream. All rights reserved.
//

import Foundation


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

protocol NekoMindQueries {
	func physicalLocation() -> CGPoint
}


class NekoMind {
	private var state_ = NekoState.Idle
	private var lastStateChange_ = NSDate()

	let queries: NekoMindQueries
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

	var targetPosition = CGPointMake(0, 0) {
		didSet {
		}
	}
	
	init(worldQueries: NekoMindQueries) {
		queries = worldQueries
	}
	
	func awaken() {
		state = .Idle
	}
	
	private func schedule(fromNow: NSTimeInterval, block: () -> ()) {
		Timer.start(fromNow, repeats: false) { timer in block() }
	}
	
	private func act() {
		switch state_ {
			case .Idle:
				schedule(10) { self.state = .GoingToSleep }
			case .GoingToSleep:
				schedule(0.8) { self.state = .Sleeping }
			case .Sleeping:
				schedule(120) { self.state = .WakingUp }
			case .WakingUp:
				schedule(0.8) { self.state = .Idle }
		}
	}
}
