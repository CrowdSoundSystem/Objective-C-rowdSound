

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Helper : NSObject

+ (CGFloat) random;
+ (CGFloat) randomBetweenMin:(CGFloat)min AndMax:(CGFloat)max;
+ (NSString *) getUserId;
+ (UIColor*) getUIColorWithRed: (CGFloat)red andGreen: (CGFloat)green andBlue: (CGFloat)blue andAlpha: (CGFloat)alpha;
+ (UIColor *) getMustardYellow;
+ (UIColor*) getBurntOrange;
+ (UIColor*) getCloudGrey;
+ (UIColor*) getLighterCloudGrey;
@end
