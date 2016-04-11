

#import "NowPlayingTableViewController.h"
#import "TWMessageBarManager.h"
#import "DRCellSlideGestureRecognizer.h"

@interface NowPlayingTableViewController ()
@property (strong) NSMutableArray* bufferedSongsArray;
@end

@implementation NowPlayingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cellId = @"queueCell";
    
    self.view.backgroundColor = [Helper getCloudGrey];
    [self setTitle:@"Current Playlist"];
    _bufferedSongsArray = [[NSMutableArray alloc]init];
    
    [self updateQueueData];
        
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.backgroundColor = [Helper getCloudGrey];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(refreshQueueData) forControlEvents:UIControlEventValueChanged];
    
    self.tableView.rowHeight = 80;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateQueueData) name:@"RefreshQueue" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"RefreshQueue" object:nil];
}

- (BFTask *) updateQueueData {
    return [[self.csInterface getSongQueue] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (!task.error) {
            NSMutableArray *queueWithBuffered = task.result;

            if (_bufferedSongsArray.count > 0)
                [_bufferedSongsArray removeAllObjects];
            
            // Add all the songs that have been buffered to buffered array
            for (int i = 0; i < queueWithBuffered.count; i++) {
                if ([(NowPlayingSongItem*)queueWithBuffered[i] isBuffered]) {
                    [_bufferedSongsArray addObject:queueWithBuffered[i]];
                }
            }
            
            // Remove all buffered songs from suggested array
            [queueWithBuffered removeObjectsInArray:_bufferedSongsArray];
            
            // Songs for tableView is suggested array
            self.songsForTableView = queueWithBuffered;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        return nil;
    }];
    
}

- (void) refreshQueueData {
    // Format date to be date of last refresh
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                forKey:NSForegroundColorAttributeName];
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title
                                                                          attributes:attrsDictionary];
    self.refreshControl.attributedTitle = attributedTitle;
    
    // Update queue data and then stop refresh control
    [[self updateQueueData] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.refreshControl.isRefreshing) {
                [self.refreshControl endRefreshing];
            }
        });
        return nil;
    }];
    
}
//TODO: figure out a way to use this
- (BFTask *) updateSessionData {
    return [[self.csInterface getSessionData] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (!task.error) {
            SessionData *data =(SessionData *)task.result;
            _sessionName = data.sessionName;
            _numberOfUsersInSession = [[NSNumber alloc]initWithInt:data.numberOfUsers];
        }
        return nil;
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Up Next";
    } else {
        return @"Suggested";
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section {
    view.tintColor = [Helper getBurntOrange];
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _bufferedSongsArray.count;
    } else {
        return self.songsForTableView.count;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    NowPlayingSongItem *item;
    
    // Use buffered Array for "Up Next" section and songsForTableView for "Suggested"
    if (indexPath.section == 0) {
        item = _bufferedSongsArray[indexPath.row];
        
    }
    if (indexPath.section == 1){
        item = self.songsForTableView[indexPath.row];
    }
    
    cell.textLabel.text = item.song.name;
    cell.detailTextLabel.text = item.song.artists[0];
    
    cell.backgroundColor = [Helper getCloudGrey];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

/* This must be overriden because of the 2 arrays being used for the data source. */
- (UITableViewCell *)setAccessoryViewOfCell: (UITableViewCell *)cell withIndexPath: (NSIndexPath *)indexPath {
    if ([self.songsForTableView count] == 0) {
        return cell;
    }
    
    NowPlayingSongItem *item;
    
    if (indexPath.section == 0) {
        item = (NowPlayingSongItem *)_bufferedSongsArray[indexPath.row];
    } else {
        item = (NowPlayingSongItem *)self.songsForTableView[indexPath.row];
    }
    
    if (!item) {
        return cell;
    }
    
    // Check if vote has been made on song and if so set acc. view accordingly
    int voteCacheResult = [self.votesCache getVoteForSongName: item.song.name andArtist: item.song.artists[0]];
    
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


#pragma mark DRCell Callbacks

- (DRCellSlideActionBlock)upVoteCallback {
    return ^(UITableView *tableView, NSIndexPath *indexPath) {
        NowPlayingSongItem *item;
        
        // Get item based on section
        if (indexPath.section == 0)
            item = _bufferedSongsArray[indexPath.row];
        else
            item = self.songsForTableView[indexPath.row];
        
        // Cache vote with value and then reload it
        [self.votesCache cacheVote:true
                       forSongName:item.song.name
                         andArtist:item.song.artists[0]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
        // Call vote for song API
        [self voteOccurredOnSong:item.song.name
                       andArtist:item.song.artists[0]
                       withValue:true];
    };
}

- (DRCellSlideActionBlock)downVoteCallback {
    return ^(UITableView *tableView, NSIndexPath *indexPath) {
        NowPlayingSongItem *item;
        
        // Get item based on section
        if (indexPath.section == 0)
            item = _bufferedSongsArray[indexPath.row];
        else
            item = self.songsForTableView[indexPath.row];
        
        // Cache vote with value and then reload UI
        [self.votesCache cacheVote:false
                       forSongName:item.song.name
                         andArtist:item.song.artists[0]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
        // Call vote for song API
        [self voteOccurredOnSong:item.song.name
                       andArtist:item.song.artists[0]
                       withValue:false];
    };
}


@end
