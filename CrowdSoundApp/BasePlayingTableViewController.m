
#import "BasePlayingTableViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface BasePlayingTableViewController ()
@end

@implementation BasePlayingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.csInterface = [CSServiceInterface sharedInstance];
    
    self.tableView.allowsSelection = false;
    
    self.votesCache = [VotesCache sharedInstance];
    self.songsForTableView = [[NSMutableArray alloc]init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellId forIndexPath:indexPath];
    
    DRCellSlideGestureRecognizer *slideGestureRecognizer = [DRCellSlideGestureRecognizer new];
    [slideGestureRecognizer addActions:@[[self configureUpvoteAction], [self configureDownvoteAction]]];
    [cell addGestureRecognizer:slideGestureRecognizer];
    
    return [self setAccessoryViewOfCell:cell withIndexPath:indexPath];
}

#pragma mark Voting Methods


- (void) voteOccurredOnSong: (NSString *)songName andArtist: (NSString *)artist withValue: (BOOL)value {
    [[self.csInterface voteForSong:songName withArtist:artist withValue:value] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (!task.error) {
            [self.votesCache cacheVote:value forSongName:songName andArtist:artist];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        return nil;
    }];
}

- (UITableViewCell *)setAccessoryViewOfCell: (UITableViewCell *)cell withIndexPath: (NSIndexPath *)indexPath {
    if ([self.songsForTableView count] == 0) {
        return cell;
    }
    
    NowPlayingSongItem *item = (NowPlayingSongItem *)self.songsForTableView[indexPath.row];
    if (!item) {
        return cell;
    }
    int voteCacheResult = [_votesCache getVoteForSongName: item.song.name andArtist: item.song.artists[0]];
    
    if (voteCacheResult == 0) {
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dislike"]];
    } else if (voteCacheResult == 1){
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"like"]];
    } else {
        cell.accessoryView = nil;
    }
    [cell.accessoryView setFrame:CGRectMake(0,0,12,12)];
    return cell;
}

#pragma mark DRCell

- (DRCellSlideAction*)configureUpvoteAction {
    DRCellSlideAction *upVoteAction = [DRCellSlideAction actionForFraction:0.25];
    upVoteAction.icon = [UIImage imageNamed:@"Thumb Up-30"];
    upVoteAction.activeBackgroundColor = [UIColor greenColor];
    upVoteAction.inactiveBackgroundColor = [UIColor blackColor];
    upVoteAction.elasticity = 40;
    upVoteAction.behavior = DRCellSlideActionPushBehavior;
    upVoteAction.didTriggerBlock = [self upVoteCallback];
    
    return upVoteAction;
}

- (DRCellSlideAction*) configureDownvoteAction {
    DRCellSlideAction *downVoteAction = [DRCellSlideAction actionForFraction:0.5];
    downVoteAction.icon = [UIImage imageNamed:@"Thumbs Down-30"];
    downVoteAction.activeBackgroundColor = [UIColor redColor];
    downVoteAction.inactiveBackgroundColor = [UIColor blackColor];
    downVoteAction.elasticity = 40;
    downVoteAction.behavior = DRCellSlideActionPushBehavior;
    downVoteAction.didTriggerBlock = [self downVoteCallback];
    downVoteAction.willTriggerBlock = [self didChangeStateCallback];
    
    return downVoteAction;
}

- (DRCellSlideActionBlock)didChangeStateCallback {
    return ^(UITableView *tableView, NSIndexPath *indexPath) {
        self.isVoteOccurring = true;
    };
}

- (DRCellSlideActionBlock)upVoteCallback {
    return ^(UITableView *tableView, NSIndexPath *indexPath) {
        
        //[self voteOccurredOnSong:item.song.name andArtist:item.song.artists[0] withValue:true];
    };
}

- (DRCellSlideActionBlock)downVoteCallback {
    return ^(UITableView *tableView, NSIndexPath *indexPath) {
        //[self voteOccurredOnSong:item.song.name andArtist:item.song.artists[0] withValue:false];
    };
}

@end
