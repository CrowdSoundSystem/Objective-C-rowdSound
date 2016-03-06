
#import "SIFloatingNode.h"


@implementation SIFloatingNode

-(id)init {
    if (self = [super init]) {
        _state = SIFloatingNodeStateNormal;
        _previousState = SIFloatingNodeStateNormal;
        _removingKey = @"action.removing";
        _selectingKey = @"action.selecting";
        _normalizeKey = @"action.normalize";
    }
    return self;
}

-(void)setState:(SIFloatingNodeState)state {
    if (_state != state) {
        _previousState = _state;
        _state = state;
        [self stateChanged];
    }
}


- (void)stateChanged {
    SKAction *action;
    NSString *actionKey;
    
    switch (_state) {
        case SIFloatingNodeStateNormal:
            action = [self normalizeAnimation];
            actionKey = _normalizeKey;
            break;
        case SIFloatingNodeStateSelected:
            action = [self selectingAnimation];
            actionKey = _selectingKey;
            break;
        case SIFloatingNodeStateRemoving:
            action = [self removingAnimation];
            actionKey = _removingKey;
            break;
        default:
            break;
    }
    
    if (action && actionKey) {
        [self runAction:action withKey:actionKey];
    }
}

-(void) removeFromParent {
    SKAction *action = [self removeAnimation];
    if (action) {
        [self runAction:action completion:^{
            [super removeFromParent];
        }];
    } else {
        [super removeFromParent];
    }
}

-(SKAction*) selectingAnimation { return nil; }
-(SKAction*) normalizeAnimation { return nil; }
-(SKAction*) removeAnimation { return nil; }
-(SKAction*) removingAnimation { return nil; }


@end
