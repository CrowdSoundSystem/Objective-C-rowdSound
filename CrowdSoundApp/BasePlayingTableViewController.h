
#import <UIKit/UIKit.h>
#import "CSServiceInterface.h"
#import "DRCellSlideGestureRecognizer.h"
#import "VotesCache.h"
#import "TWMessageBarManager.h"


@interface BasePlayingTableViewController : UITableViewController


@property (strong, nonatomic) CSServiceInterface *csInterface;
@property (strong, nonatomic) VotesCache *votesCache;
@property (strong, nonatomic) NSString *cellId;
@property (nonatomic) BOOL isVoteOccurring;
@property (strong, nonatomic) NSMutableArray *songsForTableView;

- (void) voteOccurredOnSong: (NSString *)songName andArtist: (NSString *)artist withValue: (BOOL)value;
- (UITableViewCell *)setAccessoryViewOfCell: (UITableViewCell *)cell withIndexPath: (NSIndexPath *)indexPath;
- (DRCellSlideAction*)configureUpvoteAction;
- (DRCellSlideAction*) configureDownvoteAction;
@end
