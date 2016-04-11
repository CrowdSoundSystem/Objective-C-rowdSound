
#import "SIFloatingNode.h"

@interface BubbleNode : SIFloatingNode

@property (strong, nonatomic) SKLabelNode *labelNode;
@property (strong, nonatomic) NSString *cachedLabel;

+ (BubbleNode *) instantiateWithText: (NSString*)text andRadius: (int)radius;

@end
