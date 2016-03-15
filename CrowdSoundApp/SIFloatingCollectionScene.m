
#import "SIFloatingCollectionScene.h"
#import <CoreGraphics/CoreGraphics.h>

@interface SIFloatingCollectionScene()

@property CGPoint touchPoint;
@property NSTimeInterval touchStartedTime;
@property NSTimeInterval removingStartedTIme;
@property (strong) UILongPressGestureRecognizer* lpgr;

@end

@implementation SIFloatingCollectionScene

- (id)initWithSize:(CGSize)size {
    if ([super initWithSize:size]) {
        _magneticField = [SKFieldNode radialGravityField];
        _mode = SIFloatingCollectionSceneModeNormal;
        _timeToStartRemove = 0.7;
        _timeToRemove = 2;
        _allowEditing = false;
        _allowMultipleSelection = false;
        _restrictedToBounds = true;
        _pushStrength = 10000;
        _touchPoint = CGPointMake(-1, -1);
        _touchStartedTime = -1;
        _removingStartedTIme = -1;
        _floatingNodes = [[NSMutableArray alloc]init];
        
        _lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestures:)];
        _lpgr.minimumPressDuration = 1.0f;
        _lpgr.allowableMovement = 100.0f;
        
        [self.view addGestureRecognizer:_lpgr];
    }
    return self;
}

- (void) setMode:(SIFloatingCollectionSceneMode)mode {
    _mode = mode;
    [self modeUpdated];
    
}

- (void) update:(NSTimeInterval)currentTime {
    for (SKNode *node in _floatingNodes) {
        CGFloat distanceFromCenter = [self distanceBetweenFirstPoint:_magneticField.position andSecondPoint:node.position];
        node.physicsBody.linearDamping = distanceFromCenter > 100 ? 2 : 2 + ((100 - distanceFromCenter) / 10);
    }
    
    if (_mode == SIFloatingCollectionSceneModeMoving || !_allowEditing) {
        return;
    }
    
    if (!CGPointEqualToPoint(_touchPoint, CGPointMake(-1, -1)) && _touchStartedTime != -1) {
        NSTimeInterval dTime = currentTime - _touchStartedTime;
        if (dTime > _timeToStartRemove) {
            _touchStartedTime = -1;
            SIFloatingNode *node = (SIFloatingNode*)[self nodeAtPoint:_touchPoint];
            if (node) {
                _removingStartedTIme = currentTime;
                [self startRemovingNode:node];
                
            }
        }
    } else if (_mode == SIFloatingCollectionSceneModeEditing && _removingStartedTIme != -1 && !CGPointEqualToPoint(_touchPoint, CGPointMake(-1, -1))) {
        NSTimeInterval dTime = currentTime - _removingStartedTIme;
        if (dTime > _timeToRemove) {
            _removingStartedTIme = -1;
            SIFloatingNode *node = (SIFloatingNode*)[self nodeAtPoint:_touchPoint];
            if (node) {
                int index = (int)[_floatingNodes indexOfObject:node];
                [self removeFloatingNodeAtIndex:index];
            }
        }
    }
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        _touchPoint = [touch locationInNode:self];
        _touchStartedTime = [touch timestamp];
    }
}

- (void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_mode == SIFloatingCollectionSceneModeEditing) {
        return;
    }
    
    for (UITouch *touch in touches) {
        CGPoint plin = [touch previousLocationInNode:self];
        CGPoint lin = [touch locationInNode:self];
        CGFloat dx = lin.x - plin.x;
        CGFloat dy = lin.y - plin.y;
        CGFloat b = sqrt(pow(lin.x, 2) + pow(lin.y, 2));
        dx = b == 0 ? 0 : (dx/b);
        dy = b == 0 ? 0 : (dy/b);
        
        if (dx == 0 && dy == 0) {
            return;
        } else if (_mode != SIFloatingCollectionSceneModeMoving) {
            _mode = SIFloatingCollectionSceneModeMoving;
        }
        
        for (SIFloatingNode* node in _floatingNodes) {
            CGFloat w = node.frame.size.width/2;
            CGFloat h = node.frame.size.height/2;
            CGVector direction = CGVectorMake(_pushStrength * dx, _pushStrength * dy);
            
            if (_restrictedToBounds) {
                if ((node.position.x < -w || node.position.x > self.size.width + w) && (node.position.x * dx > 0)) {
                    direction.dx = 0;
                }
                if ((node.position.y < -h || node.position.y > self.size.height + h) && (node.position.y * dy > 0)) {
                    direction.dy = 0;
                }
            }
            [node.physicsBody applyForce:direction];
        }
        
    }
}

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_mode != SIFloatingCollectionSceneModeMoving && !CGPointEqualToPoint(_touchPoint, CGPointMake(-1, -1))) {
        SKNode *node = [self nodeAtPoint:_touchPoint];
        if ([node isKindOfClass:SIFloatingNode.class]) {
            [self updateNodeState:(SIFloatingNode *)node];
        }
    }
    _mode = SIFloatingCollectionSceneModeNormal;
}

- (void)handleLongPressGestures:(UILongPressGestureRecognizer *)sender
{
    if ([sender isEqual:self.lpgr]) {
        if (sender.state == UIGestureRecognizerStateBegan)
        {
            _touchPoint = [sender locationInView:self.view];
            
        }
    }
}


- (void) touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _mode = SIFloatingCollectionSceneModeNormal;
}

- (CGFloat)distanceBetweenFirstPoint: (CGPoint) firstPoint andSecondPoint: (CGPoint)secondPoint {
    return hypot(secondPoint.x - firstPoint.x, secondPoint.y - firstPoint.y);
}

- (void) didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    [self configureScene];
    
}

- (void) cancelRemovingNode: (SIFloatingNode *)node {
    _mode = SIFloatingCollectionSceneModeNormal;
    node.physicsBody.dynamic = true;
    node.state = node.previousState;
    int index = (int)[_floatingNodes indexOfObject:node];
    if (_floatingDelegate) {
        [_floatingDelegate floatingScene:self canceledRemovingOfFloatingNodeAtIndex:index];
    }
}

- (SIFloatingNode *) floatingNodeAtIndex: (int)index {
    if (index < _floatingNodes.count && index >= 0) {
        return _floatingNodes[index];
    }
    return nil;
}

- (int) indexOfSelectedNode {
    int index = -1;
    for (int i = 0; i < _floatingNodes.count; i++) {
        if (((SIFloatingNode*)_floatingNodes[i]).state == SIFloatingNodeStateTapped) {
            index = i;
            break;
        }
    }
    return index;
}

- (NSArray*) indexOfSelectedNodes {
    NSMutableArray *indexes = [[NSMutableArray alloc]init];
    for (int i = 0; i < _floatingNodes.count; i++) {
        if (((SIFloatingNode*)_floatingNodes[i]).state == SIFloatingNodeStateTapped) {
            [indexes addObject:[NSNumber numberWithInt:i]];
            break;
        }
    }
    return indexes;
}

- (SKNode *) nodeAtPoint:(CGPoint)p {
    SKNode *currentNode = [super nodeAtPoint:p];
    while (!([currentNode.parent isKindOfClass:SKScene.class]) && !([currentNode isKindOfClass:SIFloatingNode.class]) && !currentNode.userInteractionEnabled) {
        currentNode = currentNode.parent;
    }
    return currentNode;
}

- (void) removeFloatingNodeAtIndex: (int)index {
    if ([self shouldRemoveNodeAtIndex:index]) {
        SIFloatingNode *node = _floatingNodes[index];
        [_floatingNodes removeObjectAtIndex:index];
        [node removeFromParent];
        if (_floatingDelegate) {
            [_floatingDelegate floatingScene:self didRemoveFloatingNodeAtIndex:index];
        }
    }
}

- (void) startRemovingNode: (SIFloatingNode *)node {
    _mode = SIFloatingCollectionSceneModeEditing;
    node.physicsBody.dynamic = false;
    node.state = SIFloatingNodeStateRemoving;
    int index = (int)[_floatingNodes indexOfObject:node];
    if (_floatingDelegate) {
        [_floatingDelegate floatingScene:self startedRemovingOfFloatingNodeAtIndex:index];
    }
    
}

- (void) updateNodeState: (SIFloatingNode *)node {
    int index = (int)[_floatingNodes indexOfObject:node];
    switch (node.state) {
        case SIFloatingNodeStateNormal:
            if ([self shouldSelectNodeAtIndex:index]) {
                int selectedIndex = [self indexOfSelectedNode];
                if (!_allowMultipleSelection && selectedIndex != -1) {
                    [self updateNodeState:_floatingNodes[selectedIndex]];
                }
                node.state = SIFloatingNodeStateTapped;
                if (_floatingDelegate) {
                    [_floatingDelegate floatingScene:self didSelectFloatingNodeAtIndex:index];
                }
            }
            break;
        case SIFloatingNodeStateTapped:
            if ([self shouldDeselectNodeAtIndex:index]) {
                node.state = SIFloatingNodeStateNormal;
                if (_floatingDelegate) {
                    [_floatingDelegate floatingScene:self didDeselectFloatingNodeAtIndex:index];
                }
            }
            
            break;
        case SIFloatingNodeStateRemoving:
            [self cancelRemovingNode:node];
            break;
        default:
            break;
    }
}

- (void) addChild:(SKNode *)node {
    if ([node isKindOfClass:SIFloatingNode.class]) {
        [self configureNode:(SIFloatingNode *)node];
        [_floatingNodes addObject:(SIFloatingNode *)node];
    }
    [super addChild:node];
}

- (void) configureScene {
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    _magneticField = [SKFieldNode radialGravityField];
    _magneticField.region = [[SKRegion alloc]initWithRadius:10000];
    _magneticField.minimumRadius = 10000;
    _magneticField.strength = 8000;
    _magneticField.position = CGPointMake(self.size.width/2, self.size.height/2);
    [self addChild:_magneticField];
}

- (void) configureNode: (SIFloatingNode *)node {
    if (!node.physicsBody) {
        CGMutablePathRef path = CGPathCreateMutable();
        
        if (node.path) {
            path = node.path;
        }
        node.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
    }
    node.physicsBody.dynamic = true;
    node.physicsBody.affectedByGravity = false;
    node.physicsBody.allowsRotation = false;
    node.physicsBody.mass = 0.3;
    node.physicsBody.friction = 0;
    node.physicsBody.linearDamping = 3;
}

- (void) modeUpdated {
    switch (_mode) {
        case SIFloatingCollectionSceneModeNormal:
            _touchStartedTime = -1;
            _removingStartedTIme = -1;
            _touchPoint = CGPointMake(-1, -1);
            break;
        case SIFloatingCollectionSceneModeMoving:
            _touchStartedTime = -1;
            _removingStartedTIme = -1;
            _touchPoint = CGPointMake(-1, -1);
            break;
        default:
            break;
    }
}

- (BOOL) shouldRemoveNodeAtIndex:(int)index {
    if (index >= 0 && index <= _floatingNodes.count) {
        if (_floatingDelegate) {
            return [_floatingDelegate floatingScene:self shouldRemoveFloatingNodeAtIndex:index];
        }
        return true;
    }
    
    return false;
}

- (BOOL) shouldSelectNodeAtIndex:(int)index {
    if (_floatingDelegate) {
        return [_floatingDelegate floatingScene:self shouldSelectFloatingNodeAtIndex:index];
    }
    return true;
}

- (BOOL) shouldDeselectNodeAtIndex:(int)index {
    if (_floatingDelegate) {
        return [_floatingDelegate floatingScene:self shouldDeselectFloatingNodeAtIndex:index];
    }
    return true;
}

@end
