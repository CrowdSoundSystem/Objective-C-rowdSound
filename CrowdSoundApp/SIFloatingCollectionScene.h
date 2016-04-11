
#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "SIFloatingNode.h"

typedef enum SIFloatingCollectionSceneMode {SIFloatingCollectionSceneModeNormal, SIFloatingCollectionSceneModeEditing, SIFloatingCollectionSceneModeMoving}SIFloatingCollectionSceneMode;

@class SIFloatingCollectionScene;

@protocol SIFloatingCollectionSceneDelegate <NSObject>
@optional
- (BOOL) floatingScene: (SIFloatingCollectionScene *)scene shouldTapFloatingNodeAtIndex: (int)index;
- (BOOL) floatingScene: (SIFloatingCollectionScene *)scene didTapFloatingNodeAtIndex: (int)index;
- (BOOL) floatingScene: (SIFloatingCollectionScene *)scene shouldLongPressFloatingNodeAtIndex: (int)index;
- (BOOL) floatingScene: (SIFloatingCollectionScene *)scene didLongPressFloatingNodeAtIndex: (int)index;
- (BOOL) floatingScene: (SIFloatingCollectionScene *)scene shouldNormalizeFloatingNodeAtIndex: (int)index;
- (BOOL) floatingScene: (SIFloatingCollectionScene *)scene didNormalizeFloatingNodeAtIndex: (int)index;
- (BOOL) floatingScene: (SIFloatingCollectionScene *)scene startedRemovingOfFloatingNodeAtIndex: (int)index;
- (BOOL) floatingScene: (SIFloatingCollectionScene *)scene canceledRemovingOfFloatingNodeAtIndex: (int)index;
- (BOOL) floatingScene: (SIFloatingCollectionScene *)scene shouldRemoveFloatingNodeAtIndex: (int)index;
- (BOOL) floatingScene: (SIFloatingCollectionScene *)scene didRemoveFloatingNodeAtIndex: (int)index;
@end

@interface SIFloatingCollectionScene : SKScene

@property(nonatomic) SKFieldNode *magneticField;
@property(nonatomic) SIFloatingCollectionSceneMode mode;
@property(nonatomic) NSMutableArray *floatingNodes;
@property(nonatomic) NSTimeInterval timeToStartRemove;
@property(nonatomic) NSTimeInterval timeToRemove;
@property(nonatomic) BOOL allowEditing;
@property(nonatomic) BOOL allowMultipleSelection;
@property(nonatomic) BOOL restrictedToBounds;
@property(nonatomic) CGFloat pushStrength;
@property(weak, nonatomic) id<SIFloatingCollectionSceneDelegate> floatingDelegate;

- (CGFloat)distanceBetweenFirstPoint: (CGPoint) firstPoint andSecondPoint: (CGPoint)secondPoint;
- (void) removeFloatingNodeAtIndex: (int)index;
- (NSArray*) indexOfSelectedNodes;
- (SIFloatingNode *) floatingNodeAtIndex: (int)index;

@end


