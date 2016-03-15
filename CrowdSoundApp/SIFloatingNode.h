
#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

typedef enum SIFloatingNodeState {SIFloatingNodeStateNormal, SIFloatingNodeStateTapped, SIFloatingNodeStateLongPressed, SIFloatingNodeStateRemoving}SIFloatingNodeState;

@interface SIFloatingNode : SKShapeNode

@property(nonatomic, assign) SIFloatingNodeState state;
@property(nonatomic, assign) SIFloatingNodeState previousState;
@property(nonatomic) NSString *removingKey;
@property(nonatomic) NSString *tappingKey;
@property(nonatomic) NSString *longPressingKey;
@property(nonatomic) NSString *normalizeKey;


-(SKAction*) tappingAnimation;
-(SKAction*) longPressingAnimation;
-(SKAction*) normalizeAnimation;
-(SKAction*) removeAnimation;
-(SKAction*) removingAnimation;


@end
