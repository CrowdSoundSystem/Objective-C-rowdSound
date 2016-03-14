

#import "NowPlayingTableViewController.h"
#import "NativeDataScraper.h"
#import "SpotifyDataScraper.h"
#import "UIView+RNActivityView.h"
#import "TWMessageBarManager.h"
#import "DRCellSlideGestureRecognizer.h"

@interface NowPlayingTableViewController ()
@property (strong) NSArray* typesOfScrapers;
@end

@implementation NowPlayingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cellId = @"queueCell";
    
    self.view.backgroundColor = [UIColor blackColor];
    [self setTitle:@"Current Playlist"];
    _typesOfScrapers = @[@"Phone Music App", @"Spotify Favourites"];
    
    [self updateQueueData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrapeAndSendSpotifyData) name:@"AuthenticatedSpotify" object:nil];
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.backgroundColor = [UIColor blackColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(refreshQueueData) forControlEvents:UIControlEventValueChanged];
    
    
    /*// Set up scraper types view
    
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
    
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:picker selector:@selector(show) userInfo:nil repeats:NO];*/
    
    self.tableView.rowHeight = 80;
    
}

- (void) viewDidAppear:(BOOL)animated {
    //_timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(updateQueueAndSessionData) userInfo:nil repeats:YES];
}

- (void) viewDidDisappear:(BOOL)animated {
    [_timer invalidate];
}

- (BFTask *) updateQueueData {
    return [[self.csInterface getSongQueue] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (!task.error) {
            NSMutableArray *queueWithPlaying = task.result;
            int index = -1;
            
            for (int i = 0; i < queueWithPlaying.count; i++) {
                if ([(NowPlayingSongItem*)queueWithPlaying[i] isPlaying]) {
                    index = i;
                }
            }
            
            // Remove song that is currently playing
            if (index != -1) {
                [queueWithPlaying removeObjectAtIndex:(NSUInteger)index];
            }
            self.songsForTableView = queueWithPlaying;
            //[self.votesCache SyncVotesCacheWithCurrentQueue:self.songsForTableView];
            
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
    return [[self.csInterface getSessionData] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
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
    
    [[self.csInterface sendSongs:songs] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
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

/*- (void) authenticateWithSpotify {
    SpotifyDataScraper *scraper = [[SpotifyDataScraper alloc]init];
    [self.view showActivityViewWithLabel:@"Loading"];
    [scraper authenticateSpotify];
    [self.view hideActivityView];
}

- (void) scrapeAndSendSpotifyData {
    SpotifyDataScraper *scraper = [[SpotifyDataScraper alloc]init];
    [[[scraper scrapeAllSpotifyFavourites] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (!task.error) {
            return [self.csInterface sendSongs:task.result];
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
}*/

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.songsForTableView.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    NowPlayingSongItem *item = self.songsForTableView[indexPath.row];
    
    cell.textLabel.text = item.song.name;
    cell.detailTextLabel.text = item.song.artists[0];
    cell.backgroundColor = [UIColor blackColor];
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
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
                //[self authenticateWithSpotify];
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

#pragma mark DRCell Callbacks

- (DRCellSlideActionBlock)upVoteCallback {
    return ^(UITableView *tableView, NSIndexPath *indexPath) {
        NowPlayingSongItem *item = self.songsForTableView[indexPath.row];
        [self voteOccurredOnSong:item.song.name andArtist:item.song.artists[0] withValue:true];
    };
}

- (DRCellSlideActionBlock)downVoteCallback {
    return ^(UITableView *tableView, NSIndexPath *indexPath) {
        NowPlayingSongItem *item = self.songsForTableView[indexPath.row];
        [self voteOccurredOnSong:item.song.name andArtist:item.song.artists[0] withValue:false];
    };
}


@end
