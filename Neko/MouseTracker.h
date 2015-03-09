#import <CoreFoundation/CoreFoundation.h>
#import <CoreGraphics/CoreGraphics.h>

@protocol MouseTrackerDelegate

- (void)mouseMovedToX:(CGFloat)x andY:(CGFloat)y;

@end


@interface NekoMouseTracker : NSObject<MouseTrackerDelegate> {
	CFMachPortRef eventTap;
	CFRunLoopSourceRef eventSource;
}

- (instancetype)init;
- (void)start;
- (void)stop;

@property id<MouseTrackerDelegate> delegate;

@end
