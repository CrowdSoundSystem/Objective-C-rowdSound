
#import "NowPlayingBarTableViewController.h"
#import "Helper.h"
#import "DRCellSlideGestureRecognizer.h"
#import "Song.h"
#import <QuartzCore/QuartzCore.h>

@interface NowPlayingBarTableViewController ()
@property(strong) NSTimer* timer;
@end

@implementation NowPlayingBarTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.cellId = @"nowPlayingCell";
    self.tableView.scrollEnabled = false;
    
    self.tableView.rowHeight = 80;
    
    [self updateSongAndArtist];

}

- (void)viewDidAppear:(BOOL)animated {
    _timer = [NSTimer scheduledTimerWithTimeInterval:[Helper randomBetweenMin:10.0 AndMax:15.0]target:self selector:@selector(updateSongAndArtist) userInfo:nil repeats:true];
}

- (void)viewDidDisappear:(BOOL)animated {
    [_timer invalidate];
}

- (void)updateSongAndArtist {
    if (self.isVoteOccurring) {
        NSLog(@"vote is occuring cant reload table view");
        return;
    }
    [[self.csInterface getIsPlaying]continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (!task.error) {
            NowPlayingSongItem *currentItem = task.result;
            if (currentItem) {
                [self.songsForTableView addObject:currentItem];
            }
            //[self.votesCache SyncVotesCacheWithCurrentQueue:self.songsForTableView];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        return nil;
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Now Playing";
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor darkGrayColor];
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellId forIndexPath:indexPath];
    
    DRCellSlideGestureRecognizer *slideGestureRecognizer = [DRCellSlideGestureRecognizer new];
    [slideGestureRecognizer addActions:@[[self configureUpvoteAction], [self configureDownvoteAction], [self configureSkipAction]]];
    [cell addGestureRecognizer:slideGestureRecognizer];
    
    if (self.songsForTableView.count != 0) {
        cell.textLabel.text = ((NowPlayingSongItem *)self.songsForTableView[0]).song.name;
        cell.detailTextLabel.text = ((NowPlayingSongItem *)self.songsForTableView[0]).song.artists[0];
    }
    
    cell.backgroundColor = [[UIColor alloc] initWithWhite:0.2 alpha:1.0];

    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    /*[cell.contentView.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [cell.contentView.layer setBorderWidth:1.0f];*/

    return [self setAccessoryViewOfCell:cell withIndexPath:indexPath];
}

#pragma mark DRCell Callbacks

- (DRCellSlideAction*)configureSkipAction {
    DRCellSlideAction *skipAction = [DRCellSlideAction actionForFraction:-0.5];
    skipAction.icon = [UIImage imageNamed:@"Fast Forward-30"];
    skipAction.activeBackgroundColor = [UIColor blueColor];
    skipAction.inactiveBackgroundColor = [UIColor blackColor];
    skipAction.elasticity = 40;
    skipAction.behavior = DRCellSlideActionPullBehavior;
    skipAction.didTriggerBlock = [self skipCallback];
    
    return skipAction;
}

- (DRCellSlideActionBlock)skipCallback {
    return ^(UITableView *tableView, NSIndexPath *indexPath) {
        [[self.csInterface voteToSkip] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
            if (!task.error) {
                [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Info" description:@"Vote has been placed for skipping" type:TWMessageBarMessageTypeInfo];
            } else {
                [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Error" description:@"Error with placing vote to skip." type:TWMessageBarMessageTypeError];
            }
            return nil;
        }];
    };
}

- (DRCellSlideActionBlock)upVoteCallback {
    return ^(UITableView *tableView, NSIndexPath *indexPath) {
        [self voteOccurredOnSong:((NowPlayingSongItem *)self.songsForTableView[0]).song.name andArtist:((NowPlayingSongItem *)self.songsForTableView[0]).song.artists[0] withValue:true];
    };
}

- (DRCellSlideActionBlock)downVoteCallback {
    return ^(UITableView *tableView, NSIndexPath *indexPath) {
        [self voteOccurredOnSong:((NowPlayingSongItem *)self.songsForTableView[0]).song.name andArtist:((NowPlayingSongItem *)self.songsForTableView[0]).song.artists[0] withValue:false];

    };
}





@end
