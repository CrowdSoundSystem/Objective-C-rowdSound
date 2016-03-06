
#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

typedef enum SIFloatingNodeState {SIFloatingNodeStateNormal, SIFloatingNodeStateSelected, SIFloatingNodeStateRemoving}SIFloatingNodeState;

@interface SIFloatingNode : SKShapeNode

@property(nonatomic, assign) SIFloatingNodeState state;
@property(nonatomic, assign) SIFloatingNodeState previousState;
@property(nonatomic) NSString *removingKey;
@property(nonatomic) NSString *selectingKey;
@property(nonatomic) NSString *normalizeKey;


-(SKAction*) selectingAnimation;
-(SKAction*) normalizeAnimation;
-(SKAction*) removeAnimation;
-(SKAction*) removingAnimation;


@end
