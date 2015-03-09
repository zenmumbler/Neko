#include "MouseTracker.h"

CGEventRef mouseTapCallback(CGEventTapProxy proxy, CGEventType type,
				  CGEventRef event, void *refcon)
{
	if (type == kCGEventMouseMoved) {
		CGPoint point = CGEventGetLocation(event);
		id<MouseTrackerDelegate> delegate = (__bridge id<MouseTrackerDelegate>)(refcon);
		[delegate mouseMovedToX: point.x andY: point.y];
	}
	
	return event;
}


@implementation NekoMouseTracker

- (instancetype) init {
	eventTap = CGEventTapCreate(kCGSessionEventTap,
								kCGTailAppendEventTap,
								kCGEventTapOptionListenOnly,
								CGEventMaskBit(kCGEventMouseMoved),
								mouseTapCallback,
								(__bridge void *)(self));

	eventSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0);
	CFRunLoopAddSource(CFRunLoopGetCurrent(), eventSource, kCFRunLoopCommonModes);

	return self;
}

- (void) dealloc {
	[self stop];
	CFRunLoopRemoveSource(CFRunLoopGetCurrent(), eventSource, kCFRunLoopCommonModes);
	CFRelease(eventSource);
	CFRelease(eventTap);
}

- (void) start {
	CGEventTapEnable(eventTap, true);
}

- (void) stop {
	CGEventTapEnable(eventTap, false);
}

- (void) mouseMovedToX:(CGFloat)x andY:(CGFloat)y {
	if (self.delegate)
		[self.delegate mouseMovedToX:x andY:y];
}

@end
