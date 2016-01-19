//
//  ExpBackOffTimer.m
//  CrowdSoundApp
//
//  Created by Nishad Krishnan on 2016-01-18.
//  Copyright © 2016 CrowdSound. All rights reserved.
//

#import "ExpBackOffTimer.h"

@interface ExpBackOffTimer()

@property(assign) NSTimeInterval timeInterval;
@property(strong) NSTimer *timer;
@property(copy) void (^backoffBlock)(ExpBackOffTimer *timer);


@end


@implementation ExpBackOffTimer

+ (ExpBackOffTimer *) setTimerWithInterval:(NSTimeInterval) interval WithBlock:(void (^)(ExpBackOffTimer *timer))block {
    ExpBackOffTimer *timer = [[ExpBackOffTimer alloc]init];
    timer.timeInterval = interval;
    timer.timer = [NSTimer scheduledTimerWithTimeInterval:timer.timeInterval target:timer selector:@selector(executeBackOff) userInfo:nil repeats:NO];
    timer.backoffBlock = block;
    return timer;
    
}

- (void) executeBackOff {
    self.backoffBlock(self);
    
    if (!self.finished) {
        if (self.timeInterval < 20.0f) {
            self.timeInterval = self.timeInterval >  30.0f ? 1 : 1.2;
            _timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(executeBackOff) userInfo:nil repeats:NO];
        }
    }
    [_timer invalidate];
}

@end
