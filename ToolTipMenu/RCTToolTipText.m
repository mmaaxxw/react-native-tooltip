#import "RCTToolTipText.h"
#import <React/RCTEventDispatcher.h>
#import <React/UIView+React.h>

@implementation RCTToolTipText
{
    RCTEventDispatcher *_eventDispatcher;
    NSInteger _nativeEventCount;
}

- (id)initWithEventDispatcher:(RCTEventDispatcher *)eventDispatcher
{
    NSLog(@"tooltip 1123");
    if ((self = [super initWithFrame:CGRectZero])) {
        _eventDispatcher = eventDispatcher;
    }

//        UIMenuItem *customMenuItem1 = [[UIMenuItem alloc] initWithTitle:@"Custom 1qa" action:@selector(customAction1)];
//        UIMenuItem *customMenuItem2 = [[UIMenuItem alloc] initWithTitle:@"Custom 2wa" action:@selector(customAction2)];
//        [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:customMenuItem1, customMenuItem2, nil]];
     NSLog(@"tooltip 5555");
    return self;
}

RCT_NOT_IMPLEMENTED(- (instancetype)initWithFrame:(CGRect)frame)
RCT_NOT_IMPLEMENTED(- (instancetype)initWithCoder:(NSCoder *)aDecoder)

- (BOOL) canBecomeFirstResponder
{
    return YES;
}

- (void) customAction1 {
  NSLog(@"custom action 1x1x");
    _nativeEventCount++;
    [_eventDispatcher sendTextEventWithType:RCTTextEventTypeChange
                                   reactTag:self.reactTag
                                       text:@"customAction1"
                                        key:nil
                                 eventCount:_nativeEventCount];
      NSLog(@"custom action 1x1 after send");
}

- (void) customAction2 {
  NSLog(@"custom action 2z1");

}

- (void)tappedMenuItem:(NSString *)text {
    _nativeEventCount++;
    [_eventDispatcher sendTextEventWithType:RCTTextEventTypeChange
                                        reactTag:self.reactTag
                                            text:text
                                            key:nil
                                      eventCount:_nativeEventCount];
}

- (void)didHideMenu:(NSNotification *)notification {
    _nativeEventCount++;
    [_eventDispatcher sendTextEventWithType:RCTTextEventTypeBlur
                                   reactTag:self.reactTag
                                       text:nil
                                        key:nil
                                 eventCount:_nativeEventCount];

}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    NSLog(@"tooltip canPerformAction 333");
        if (action == @selector(customAction1) || action == @selector(customAction2)) {
          return YES;
        }

    NSString *sel = NSStringFromSelector(action);
    NSRange match = [sel rangeOfString:@"magic_"];
    if (match.location == 0) {
        return YES;
    }
    return NO;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    if ([super methodSignatureForSelector:sel]) {
        return [super methodSignatureForSelector:sel];
    }
    return [super methodSignatureForSelector:@selector(tappedMenuItem:)];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    NSString *sel = NSStringFromSelector([invocation selector]);
    NSRange match = [sel rangeOfString:@"magic_"];
    if (match.location == 0) {
        [self tappedMenuItem:[sel substringFromIndex:6]];
    } else {
        [super forwardInvocation:invocation];
    }
}


@end
