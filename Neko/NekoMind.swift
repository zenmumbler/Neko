//
//  NekoMind.swift
//  Neko
//
//  Created by Arthur Langereis on 2015/3/4.
//  Copyright (c) 2015 logic-dream. All rights reserved.
//

import Foundation


enum NekoState {
	case idle
	case goingToSleep
	case sleeping
	case wakingUp

//	case Startled
//	case Running
}


protocol NekoMindNotifications {
	func stateDidChange(_ sender: NekoMind)
}

protocol NekoMindQueries {
	func physicalLocation() -> CGPoint
}


class NekoMind {
	fileprivate var state_ = NekoState.idle
	fileprivate var lastStateChange_ = Date()

	let queries: NekoMindQueries
	var listener: NekoMindNotifications?
	
	var state: NekoState {
		get {
			return state_
		}
		
		set {
			state_ = newValue
			lastStateChange_ = Date()
			act()
			
			listener?.stateDidChange(self)
		}
	}
	
	var lastStateChange: Date { return lastStateChange_ }

	var targetPosition = CGPoint(x: 0, y: 0) {
		didSet {
		}
	}
	
	init(worldQueries: NekoMindQueries) {
		queries = worldQueries
	}
	
	func awaken() {
		state = .idle
	}
	
	fileprivate func schedule(_ fromNow: TimeInterval, block: @escaping () -> ()) {
		Timer.start(fromNow, repeats: false) { timer in block() }
	}
	
	fileprivate func act() {
		switch state_ {
			case .idle:
				schedule(10) { self.state = .goingToSleep }
			case .goingToSleep:
				schedule(0.8) { self.state = .sleeping }
			case .sleeping:
				schedule(120) { self.state = .wakingUp }
			case .wakingUp:
				schedule(0.8) { self.state = .idle }
		}
	}
}
