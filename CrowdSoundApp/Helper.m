
#import "Helper.h"


@implementation Helper

+ (CGFloat) random {
    return arc4random();
}

+ (CGFloat) randomBetweenMin:(CGFloat)min AndMax:(CGFloat)max {
    CGFloat randNum = (float)arc4random()/0x100000000;
    return randNum * (max - min) + min;
}

+ (NSString *) getUserId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString* UUID = [defaults objectForKey:@"id"];
    
    if (UUID) {
        return UUID;
    } else {
        UUID = [[NSUUID UUID] UUIDString];
        [defaults setObject:UUID forKey:@"id"];
        return UUID;
    }
}


@end
