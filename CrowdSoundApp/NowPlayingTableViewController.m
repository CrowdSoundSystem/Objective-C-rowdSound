

#import "NowPlayingTableViewController.h"
#import "CSServiceInterface.h"
#import "NativeDataScraper.h"
#import "SpotifyDataScraper.h"
#import "UIView+RNActivityView.h"
#import "TWMessageBarManager.h"
#import "DRCellSlideGestureRecognizer.h"

@interface NowPlayingTableViewController ()
@property (strong) CSServiceInterface *csInterface;
@property (strong) NSArray* typesOfScrapers;
@property (strong) NSArray* currentQueue;
@end

@implementation NowPlayingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    [self setTitle:@"Current Playlist"];
    _typesOfScrapers = @[@"Phone Music App", @"Spotify Favourites"];
    
    _csInterface = [CSServiceInterface sharedInstance];
    
    [self updateQueueData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrapeAndSendSpotifyData) name:@"AuthenticatedSpotify" object:nil];
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.backgroundColor = [UIColor blackColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(refreshQueueData) forControlEvents:UIControlEventValueChanged];
    
    
    // Set up scraper types view
    
    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"Send Music Data From..."
                                                   cancelButtonTitle:@"Cancel"
                                                  confirmButtonTitle:@"Confirm"];
    picker.needFooterView = YES;
    picker.tapBackgroundToDismiss = NO;
    picker.allowMultipleSelection = YES;
    picker.headerBackgroundColor = [UIColor grayColor];
    picker.confirmButtonBackgroundColor = [UIColor grayColor];
    
    picker.delegate = self;
    picker.dataSource = self;
    
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:picker selector:@selector(show) userInfo:nil repeats:NO];
    
    self.tableView.rowHeight = 80;
    
}

- (void) viewDidAppear:(BOOL)animated {
    //_timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(updateQueueAndSessionData) userInfo:nil repeats:YES];
}

- (void) viewDidDisappear:(BOOL)animated {
    [_timer invalidate];
}

- (BFTask *) updateQueueData {
    return [[_csInterface getSongQueue] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (!task.error) {
            self.currentQueue = task.result;
            [self addSongsToVotesList:task.result];
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        return nil;
    }];
    
}

- (void) refreshQueueData {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                forKey:NSForegroundColorAttributeName];
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
    self.refreshControl.attributedTitle = attributedTitle;
    
    [[self updateQueueData] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.refreshControl.isRefreshing) {
                [self.refreshControl endRefreshing];
            }
        });
        return nil;
    }];
    
}

- (BFTask *) updateSessionData {
    return [[_csInterface getSessionData] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (!task.error) {
            SessionData *data =(SessionData *)task.result;
            _sessionName = data.sessionName;
            _numberOfUsersInSession = [[NSNumber alloc]initWithInt:data.numberOfUsers];
        }
        return nil;
    }];
}

#pragma mark Scraping Methods

- (void) scrapeAndSendNativeMusicData {
    NativeDataScraper *scraper = [[NativeDataScraper alloc]init];
    NSArray *songs = [scraper scrapeMusicDataWithRealData:YES];
    
    [[_csInterface sendSongs:songs] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (task.error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Error" description:@"Error sending phone music data" type:TWMessageBarMessageTypeError];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Success" description:@"Sent phone music data" type:TWMessageBarMessageTypeSuccess];
            });
        }
        return nil;
    }];
}

- (void) authenticateWithSpotify {
    SpotifyDataScraper *scraper = [[SpotifyDataScraper alloc]init];
    [self.view showActivityViewWithLabel:@"Loading"];
    [scraper authenticateSpotify];
    [self.view hideActivityView];
}

- (void) scrapeAndSendSpotifyData {
    SpotifyDataScraper *scraper = [[SpotifyDataScraper alloc]init];
    [[[scraper scrapeAllSpotifyFavourites] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (!task.error) {
            return [_csInterface sendSongs:task.result];
        }
        return task;
    }] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (task.error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Error" description:@"Error sending spotify music data" type:TWMessageBarMessageTypeError];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Success" description:@"Sent spotify music data" type:TWMessageBarMessageTypeSuccess];
            });
        }
        return nil;
    }];
}

#pragma mark Voting Methods

- (void) addSongsToVotesList: (NSArray *)currentSongList {
    //Initialize songsWithVotes array with all songs voting abilities set to visible
    if (!_songsWithVotes) {
        NSMutableArray *valueArray = [[NSMutableArray alloc]init];
        NSMutableArray *keysArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < currentSongList.count; i ++) {
            NowPlayingSongItem *item = [currentSongList objectAtIndex:i];
            NSString *key = [self createKeyForSongsWithVotesWithSong:item.song.name andArtist:(NSString *)item.song.artists[0]];
            [keysArray addObject:key];
            [valueArray addObject:[NSNumber numberWithBool:YES]];
        }
        _songsWithVotes = [[NSMutableDictionary alloc]initWithObjects:valueArray forKeys:keysArray];
        
        return;
    }
    
    // First add the songs that aren't in the songsWithVotes list
    NSMutableSet *songSet = [[NSMutableSet alloc]init];
    
    for (int i = 0; i < currentSongList.count; i++) {
        NowPlayingSongItem *item = [currentSongList objectAtIndex:i];
        NSString *key = [self createKeyForSongsWithVotesWithSong:item.song.name andArtist:(NSString *)item.song.artists[0]];
        [songSet addObject:key];
        if (![_songsWithVotes objectForKey:key]) {
            [_songsWithVotes setObject:[NSNumber numberWithBool:YES] forKey:key];
        }
    }
    
    // Second delete the songs that are in the songsWithVotes list but not in the current queue anymore.
    
    NSArray *keysArray = _songsWithVotes.allKeys;
    NSString *keyToDelete;
    
    for (int i = 0; i < keysArray.count; i++) {
        if (![songSet containsObject:[keysArray objectAtIndex:i]]) {
            keyToDelete = [keysArray objectAtIndex:i];
            break;
        }
    }
    [_songsWithVotes removeObjectForKey:keyToDelete];
}

- (NSString *) createKeyForSongsWithVotesWithSong: (NSString *)songName andArtist: (NSString *) artist {
    //Comma is the current delimiter clearly
    return [songName stringByAppendingString:[@"," stringByAppendingString:artist]];
}


- (void) voteOccurredOnSong: (NSString *)songName andArtist: (NSString *)artist withValue: (BOOL)value {
    [[_csInterface voteForSong:songName withArtist:artist withValue:value] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (!task.error) {
            [_songsWithVotes setObject:[NSNumber numberWithBool:NO] forKey:[self createKeyForSongsWithVotesWithSong:songName andArtist:artist]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        return nil;
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _currentQueue.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"queueCell" forIndexPath:indexPath];
    
    DRCellSlideGestureRecognizer *slideGestureRecognizer = [DRCellSlideGestureRecognizer new];
    
    DRCellSlideAction *upVoteAction = [DRCellSlideAction actionForFraction:0.25];
    upVoteAction.icon = [UIImage imageNamed:@"Thumb Up-30"];
    upVoteAction.activeBackgroundColor = [UIColor greenColor];
    upVoteAction.inactiveBackgroundColor = [UIColor blackColor];
    upVoteAction.elasticity = 40;
    
    DRCellSlideAction *downVoteAction = [DRCellSlideAction actionForFraction:0.5];
    downVoteAction.icon = [UIImage imageNamed:@"Thumbs Down-30"];
    downVoteAction.activeBackgroundColor = [UIColor redColor];
    downVoteAction.inactiveBackgroundColor = [UIColor blackColor];
    downVoteAction.elasticity = 40;
    
    upVoteAction.behavior = DRCellSlideActionPushBehavior;
    upVoteAction.didTriggerBlock = [self upVoteCallback];
    
    downVoteAction.behavior = DRCellSlideActionPushBehavior;
    downVoteAction.didTriggerBlock = [self downVoteCallback];
    
    [slideGestureRecognizer addActions:@[upVoteAction, downVoteAction]];
    
    [cell addGestureRecognizer:slideGestureRecognizer];
    
    NowPlayingSongItem *item = _currentQueue[indexPath.row];
    
    cell.textLabel.text = item.song.name;
    cell.detailTextLabel.text = item.song.artists[0];
    cell.backgroundColor = [UIColor blackColor];
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    // Configure the cell...
    
    return cell;
}


#pragma mark CZPickerViewSource

/* number of items for picker */
- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView {
    return _typesOfScrapers.count;
}


/* picker item title for each row */
- (NSString *)czpickerView:(CZPickerView *)pickerView
               titleForRow:(NSInteger)row {
    return [_typesOfScrapers objectAtIndex:row];
}

#pragma mark CZPickerViewDelegate

- (void)czpickerView:(CZPickerView *)pickerView
didConfirmWithItemsAtRows:(NSArray *)rows {
    
    for (int i = 0; i < rows.count; i++) {
        int currentRow = [(NSNumber*)[rows objectAtIndex:i] intValue];
        
        switch (currentRow) {
            case 0:
                [self scrapeAndSendNativeMusicData];
                break;
            case 1:
                [self authenticateWithSpotify];
                break;
            default:
                break;
        }
    }
}

/** delegate method for canceling */
- (void)czpickerViewDidClickCancelButton:(CZPickerView *)pickerView {
    
}

- (UIImage *)czpickerView:(CZPickerView *)pickerView imageForRow:(NSInteger)row {
    UIImage* image;
    
    switch (row) {
        case 0:
            image = [UIImage imageNamed:@"ipod"];
            break;
        case 1:
            image = [UIImage imageNamed:@"spotify"];
            break;
        default:
            break;
    }
    
    return image;
}

#pragma mark YMTableView Delegates

- (DRCellSlideActionBlock)upVoteCallback {
    return ^(UITableView *tableView, NSIndexPath *indexPath) {
        NowPlayingSongItem *item = _currentQueue[indexPath.row];
        [self voteOccurredOnSong:item.song.name andArtist:item.song.artists[0] withValue:true];
    };
}

- (DRCellSlideActionBlock)downVoteCallback {
    return ^(UITableView *tableView, NSIndexPath *indexPath) {
        NowPlayingSongItem *item = _currentQueue[indexPath.row];
        [self voteOccurredOnSong:item.song.name andArtist:item.song.artists[0] withValue:false];
    };
}


@end
