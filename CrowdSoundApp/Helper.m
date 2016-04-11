
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

+ (UIColor*) getUIColorWithRed: (CGFloat)red andGreen: (CGFloat)green andBlue: (CGFloat)blue andAlpha: (CGFloat)alpha {
    return [[UIColor alloc]initWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}

+ (UIColor*) getCloudGrey {
    return [Helper getUIColorWithRed:61 andGreen:79 andBlue:89 andAlpha:1.0];
}

+ (UIColor*) getLighterCloudGrey {
    return [Helper getUIColorWithRed:20 andGreen:27 andBlue:31 andAlpha:1.0];
}

+ (UIColor*) getBurntOrange {
    return [Helper getUIColorWithRed:215 andGreen:92 andBlue:74 andAlpha:1.0];
}

+ (UIColor *) getMustardYellow {
    return [Helper getUIColorWithRed:243 andGreen:195 andBlue:95 andAlpha:1.0];
}

@end
