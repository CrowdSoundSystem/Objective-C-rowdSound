
#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "SIFloatingNode.h"

typedef enum SIFloatingCollectionSceneMode {SIFloatingCollectionSceneModeNormal, SIFloatingCollectionSceneModeEditing, SIFloatingCollectionSceneModeMoving}SIFloatingCollectionSceneMode;

@class SIFloatingCollectionScene;

@protocol SIFloatingCollectionSceneDelegate <NSObject>
@optional
- (BOOL) floatingScene: (SIFloatingCollectionScene *)scene shouldSelectFloatingNodeAtIndex: (int)index;
- (BOOL) floatingScene: (SIFloatingCollectionScene *)scene didSelectFloatingNodeAtIndex: (int)index;
- (BOOL) floatingScene: (SIFloatingCollectionScene *)scene shouldDeselectFloatingNodeAtIndex: (int)index;
- (BOOL) floatingScene: (SIFloatingCollectionScene *)scene didDeselectFloatingNodeAtIndex: (int)index;
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


