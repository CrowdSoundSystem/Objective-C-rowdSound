
#import "BubbleNode.h"


@implementation BubbleNode

static int const maxTextLength = 8;

+ (BubbleNode *) instantiateWithText: (NSString*)text andRadius: (int)radius {
    BubbleNode *node = [BubbleNode shapeNodeWithCircleOfRadius:radius];
    [self configureNode:node withText:text];
    return node;
}

+ (void) configureNode: (BubbleNode *)node withText: (NSString*)text {
    CGRect boundingBox = CGPathGetBoundingBox(node.path);
    CGFloat radius = boundingBox.size.width/2.0;
    node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:radius + 1.5];
    node.fillColor = [SKColor whiteColor];
    node.strokeColor = node.fillColor;
    NSMutableString *shortenedString  = [[NSMutableString alloc]initWithString:text];
    
    if (text.length > maxTextLength) {
        shortenedString = [[NSMutableString alloc]initWithString:[text substringToIndex:maxTextLength]];
        [shortenedString appendString:@"..."];
    }
    
    node.labelNode.text = shortenedString;
    node.labelNode.position = CGPointZero;
    node.labelNode.fontColor = [SKColor blackColor];
    node.labelNode.fontName = @"AvenirNext-Bold";
    node.labelNode.fontSize = 10;
    node.labelNode.userInteractionEnabled = false;
    node.labelNode.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    node.labelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [node addChild:node.labelNode];
}

- (id) init {
    if ([super init]) {
        _labelNode = [SKLabelNode labelNodeWithText:@""];
    }
    return self;
}

- (SKAction *) tappingAnimation {
    [self removeActionForKey:self.removingKey];
    return [SKAction scaleTo:1.3 duration:0.2];
}

- (SKAction *) normalizeAnimation {
    [self removeActionForKey:self.removingKey];
    return [SKAction scaleTo:1 duration:0.2];
}

- (SKAction *) removeAnimation {
    [self removeActionForKey:self.removingKey];
    return [SKAction fadeOutWithDuration:0.2];
}

- (SKAction *) removingAnimation {
    SKAction *pulseUp = [SKAction scaleTo:self.xScale + 0.13 duration:0];
    SKAction *pulseDown = [SKAction scaleTo:self.xScale duration:0.3];
    SKAction *pulse = [SKAction sequence:@[pulseUp, pulseDown]];
    SKAction *repeatPulse = [SKAction repeatActionForever:pulse];
    return repeatPulse;
}

@end
