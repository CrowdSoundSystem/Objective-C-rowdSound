
#import "BubbleNode.h"


@implementation BubbleNode

static int const maxTextLength30 = 8;
static int const maxTextLength50 = 10;
static int const maxTextLength60 = 16;

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
    
    if (radius < 40) {
        if (text.length > maxTextLength30) {
            node.cachedLabel = text;
            shortenedString = [[NSMutableString alloc]initWithString:[text substringToIndex:maxTextLength30]];
            [shortenedString appendString:@"..."];
        }
    } else if (radius < 50) {
        if (text.length > maxTextLength50) {
            node.cachedLabel = text;
            shortenedString = [[NSMutableString alloc]initWithString:[text substringToIndex:maxTextLength50]];
            [shortenedString appendString:@"..."];
        }
    } else {
        if (text.length > maxTextLength60) {
            node.cachedLabel = text;
            shortenedString = [[NSMutableString alloc]initWithString:[text substringToIndex:maxTextLength60]];
            [shortenedString appendString:@"..."];
        }
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
    CGFloat singleActionDuration = 0.3;
    SKAction *fadeToGreen = [self fadeToColour:[SKColor greenColor] fromColour:[SKColor whiteColor] andDuration:singleActionDuration];
    SKAction *fadeToWhite = [self fadeToColour:[SKColor whiteColor] fromColour:[SKColor greenColor] andDuration:singleActionDuration];
    SKAction *pulseUp = [SKAction scaleTo:self.xScale + 0.13 duration:0];
    SKAction *pulseDown = [SKAction scaleTo:self.xScale duration:singleActionDuration];
    SKAction *pulse = [SKAction sequence:@[pulseUp, pulseDown]];
    SKAction *pulseWithGreen = [SKAction group:@[pulse, fadeToGreen]];
    SKAction *pulseWithWhite = [SKAction group:@[pulse, fadeToWhite]];
    SKAction *pulseSequence = [SKAction sequence:@[pulseWithGreen, pulseWithWhite]];
    SKAction *fadeStrokeToGreen = [self fadeToStrokeColour:[SKColor greenColor] fromColour:[SKColor whiteColor] andDuration:singleActionDuration*2];
    SKAction *pulseWithFadeStroke = [SKAction group:@[pulseSequence, fadeStrokeToGreen]];
    
    return pulseWithFadeStroke;
}

- (SKAction *) longPressingAnimation {
    [self removeActionForKey:self.removingKey];
    CGFloat singleActionDuration = 0.3;
    SKAction *fadeToRed = [self fadeToColour:[SKColor redColor] fromColour:[SKColor whiteColor] andDuration:singleActionDuration];
    SKAction *fadeToWhite = [self fadeToColour:[SKColor whiteColor] fromColour:[SKColor redColor] andDuration:singleActionDuration];
    SKAction *pulseUp = [SKAction scaleTo:self.xScale + 0.13 duration:0];
    SKAction *pulseDown = [SKAction scaleTo:self.xScale duration:singleActionDuration];
    SKAction *pulse = [SKAction sequence:@[pulseUp, pulseDown]];
    SKAction *pulseWithRed = [SKAction group:@[pulse, fadeToRed]];
    SKAction *pulseWithWhite = [SKAction group:@[pulse, fadeToWhite]];
    SKAction *pulseSequence = [SKAction sequence:@[pulseWithRed, pulseWithWhite]];
    SKAction *fadeStrokeToRed = [self fadeToStrokeColour:[SKColor redColor] fromColour:[SKColor whiteColor] andDuration:singleActionDuration*2];
    SKAction *pulseWithFadeStroke = [SKAction group:@[pulseSequence, fadeStrokeToRed]];
    return pulseWithFadeStroke;
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

- (SKAction *) fadeToColour: (SKColor*)finalColour fromColour:(SKColor*)originalColour andDuration: (CGFloat) duration {
    CGFloat red1 = 0.0, green1 = 0.0, blue1 = 0.0, alpha1 = 0.0;
    [originalColour getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
    
    CGFloat red2 = 0.0, green2 = 0.0, blue2 = 0.0, alpha2 = 0.0;
    [finalColour getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
    
    SKAction *changeGroundColor = [SKAction customActionWithDuration:duration actionBlock:^(SKNode *node, CGFloat elapsedTime) {
        CGFloat step = elapsedTime/duration;
        
        CGFloat red3 = 0.0, green3 = 0.0, blue3 = 0.0;
        red3 = red1-(red1-red2)*step;
        green3 = green1-(green1-green2)*step;
        blue3 = blue1-(blue1-blue2)*step;
        
        [(SKShapeNode*)node setFillColor:[SKColor colorWithRed:red3 green:green3 blue:blue3 alpha:1.0]];
    }];
    return changeGroundColor;
}

- (SKAction *) fadeToStrokeColour: (SKColor*)finalColour fromColour:(SKColor*)originalColour andDuration: (CGFloat) duration {
    CGFloat red1 = 0.0, green1 = 0.0, blue1 = 0.0, alpha1 = 0.0;
    [originalColour getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
    
    CGFloat red2 = 0.0, green2 = 0.0, blue2 = 0.0, alpha2 = 0.0;
    [finalColour getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
    
    SKAction *changeGroundColor = [SKAction customActionWithDuration:duration actionBlock:^(SKNode *node, CGFloat elapsedTime) {
        CGFloat step = elapsedTime/duration;
        
        CGFloat red3 = 0.0, green3 = 0.0, blue3 = 0.0;
        red3 = red1-(red1-red2)*step;
        green3 = green1-(green1-green2)*step;
        blue3 = blue1-(blue1-blue2)*step;
        
        [(SKShapeNode*)node setStrokeColor:[SKColor colorWithRed:red3 green:green3 blue:blue3 alpha:1.0]];
    }];
    return changeGroundColor;
}

@end
