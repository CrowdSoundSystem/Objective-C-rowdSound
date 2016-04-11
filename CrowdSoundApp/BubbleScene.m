
#import "BubbleScene.h"
#import "Helper.h"



@implementation BubbleScene

- (void) didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    [self configure];
}

- (void) configure {
    self.backgroundColor = [Helper getCloudGrey];
    self.scaleMode = SKSceneScaleModeAspectFill;
    self.allowMultipleSelection = true;
    CGRect bodyFrame = self.frame;
    bodyFrame.size.width = (CGFloat)self.magneticField.minimumRadius;
    bodyFrame.origin.x -= bodyFrame.size.width/2;
    bodyFrame.size.height = self.frame.size.height - _bottomOffset;
    bodyFrame.origin.y = self.frame.size.height - bodyFrame.size.height - _topOffset;
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:bodyFrame];
    self.magneticField.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + _bottomOffset/2 - _topOffset);
}

- (void) addChild:(SKNode *)node {
    if ([node isKindOfClass:BubbleNode.class]) {
        CGFloat x = [Helper randomBetweenMin:-_bottomOffset AndMax:-node.frame.size.width];
        CGFloat y = [Helper randomBetweenMin:self.frame.size.height - _bottomOffset - node.frame.size.height AndMax:self.frame.size.height - _topOffset - node.frame.size.height];
        
        if (self.floatingNodes.count % 2 == 0 || self.floatingNodes.count == 0) {
            x = [Helper randomBetweenMin:self.frame.size.width + node.frame.size.width AndMax:self.frame.size.width + _bottomOffset];
        }
        node.position = CGPointMake(x, y);
    }
    [super addChild:node];
}

- (void) performCommitSelectionAnimation {
    self.physicsWorld.speed = 0;
    NSArray *sortedNodes = [self sortedFloatingNodes];
    NSMutableArray *actions = [[NSMutableArray alloc]init];
    
    for (SIFloatingNode *node in sortedNodes) {
        node.physicsBody = nil;
        SKAction *action = [self actionForFloatingNode:node];
        [actions addObject:action];
    }
    [self runAction:[SKAction sequence:actions]];
}

- (void) throwNode:(SKNode *)node toPoint:(CGPoint)point withCompletionBlock:(void (^)(void))callbackBlock {
    [node removeAllActions];
    SKAction *movingXAction = [SKAction moveToX:point.x duration:0.2];
    SKAction *movingYAction = [SKAction moveToX:point.y duration:0.4];
    SKAction *resize = [SKAction scaleTo:0.3 duration:0.4];
    SKAction *throwAction = [SKAction group:@[movingXAction, movingYAction, resize]];
    [node runAction:throwAction];
}

- (NSArray*) sortedFloatingNodes {
    NSArray *sortedNodes = [self.floatingNodes sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        CGFloat distance1 = [self distanceBetweenFirstPoint:((SIFloatingNode *)obj1).position andSecondPoint:self.magneticField.position];
        CGFloat distance2 = [self distanceBetweenFirstPoint:((SIFloatingNode *)obj2).position andSecondPoint:self.magneticField.position];
        return (distance1 < distance2 && ((SIFloatingNode *)obj1).state != SIFloatingNodeStateTapped);
    }];
    
    return sortedNodes;
}

- (SKAction *)actionForFloatingNode:(SIFloatingNode*)node {
    SKAction *action = [SKAction runBlock:^{
        int index = (int)[self.floatingNodes indexOfObject:node];
        [self removeFloatingNodeAtIndex:index];
        if (node.state == SIFloatingNodeStateTapped) {
            [self throwNode:node toPoint:CGPointMake(self.size.width/2, self.size.height + 40) withCompletionBlock:^{
                [node removeFromParent];
            }];
        }
    }];
    return action;
}



@end
