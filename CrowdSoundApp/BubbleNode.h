
#import "SIFloatingNode.h"

@interface BubbleNode : SIFloatingNode

@property (strong, nonatomic) SKLabelNode *labelNode;


+ (BubbleNode *) instantiateWithText: (NSString*)text andRadius: (int)radius;

@end
