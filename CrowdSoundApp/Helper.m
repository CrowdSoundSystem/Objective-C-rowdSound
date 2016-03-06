
#import "Helper.h"


@implementation Helper

+ (CGFloat) random {
    return arc4random();
}

+ (CGFloat) randomBetweenMin:(CGFloat)min AndMax:(CGFloat)max {
    CGFloat randNum = (float)arc4random()/0x100000000;
    return randNum * (max - min) + min;
}


@end
