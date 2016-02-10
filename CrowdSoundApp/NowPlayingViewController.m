//
//  CurrentQueueViewController.m
//  CrowdSoundApp
//
//  Created by Nishad Krishnan on 2016-01-18.
//  Copyright © 2016 CrowdSound. All rights reserved.
//

#import "NowPlayingViewController.h"
#import "CSServiceInterface.h"
#import "MMMaterialDesignSpinner.h"
#import "NativeDataScraper.h"
#import "NowPlayingCell.h"
#import "CSAlwaysOnTopHeader.h"

@interface NowPlayingViewController ()

@property (strong) CSServiceInterface *csInterface;
@end

@implementation NowPlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*MMMaterialDesignSpinner *spinnerView = [[MMMaterialDesignSpinner alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 20, self.view.frame.size.height, 40, 40)];
    
    spinnerView.lineWidth = 3.0f;
    spinnerView.tintColor = [UIColor whiteColor];
    
    [self.view addSubview:spinnerView];
    [self.view bringSubviewToFront:spinnerView];
    [spinnerView startAnimating];*/
    
    _csInterface = [CSServiceInterface sharedInstance];
    
    [_csInterface getSessionData];
    
    NativeDataScraper *scraper = [[NativeDataScraper alloc]init];
    
    NSArray *songs = [scraper scrapeMusicData:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(updateQueueAndSessionData) userInfo:nil repeats:YES];
    
    [_csInterface sendSongs:songs]; /* continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (!task.error) {
            return [self getQueuePeriodically];
        }
        return nil;
    }];*/
    
    
    
    // Do any additional setup after loading the view.
}

- (void) updateQueueAndSessionData {
    [[_csInterface getSongQueue] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (!task.error) {
            self.sections = @[task.result];
            [self addSongsToVotesList:task.result];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
            
        }
        return nil;
    }];
    
    [[_csInterface getSessionData] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (!task.error) {
            SessionData *data =(SessionData *)task.result;
            _sessionName = data.sessionName;
            _numberOfUsersInSession = [[NSNumber alloc]initWithInt:data.numberOfUsers];
        }
        return nil;
    }];
    
}

- (void) addSongsToVotesList: (NSArray *)currentSongList {
    //Initialize songsWithVotes array with all songs voting abilities set to visible
    if (!_songsWithVotes) {
        NSMutableArray *valueArray = [[NSMutableArray alloc]init];
        NSMutableArray *keysArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < currentSongList.count; i ++) {
            NowPlayingSongItem *item = [currentSongList objectAtIndex:i];
            NSString *key = [self createKeyForSongsWithVotesWithSong:item.song.name andArtist:item.song.artist];
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
        NSString *key = [self createKeyForSongsWithVotesWithSong:item.song.name andArtist:item.song.artist];
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
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }
        return nil;
    }];
}


#pragma mark UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NowPlayingSongItem *item = self.sections[indexPath.section][indexPath.row];
    
    NowPlayingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                             forIndexPath:indexPath];
    if (!cell.nowPlayingViewController)
        cell.nowPlayingViewController = self;
    
    cell.textLabel.text = item.song.name;
    cell.artistLabel.text = item.song.artist;
    
    BOOL shouldBeEnabled = [(NSNumber *)[_songsWithVotes objectForKey:[self createKeyForSongsWithVotesWithSong:item.song.name andArtist:item.song.artist]] boolValue];
    
    cell.likeButton.enabled = shouldBeEnabled;
    cell.dislikeButton.enabled = shouldBeEnabled;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        CSSectionHeader *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                   withReuseIdentifier:@"sectionHeader"
                                                                          forIndexPath:indexPath];
        return cell;
        
    } else if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
        UICollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                            withReuseIdentifier:@"header"
                                                                                   forIndexPath:indexPath];
        CSAlwaysOnTopHeader *headerCell = (CSAlwaysOnTopHeader *)cell;
        
        headerCell.titleLabel.text = _sessionName;
        
        if ([_numberOfUsersInSession intValue] == 1) {
            headerCell.numUsers.text = [[_numberOfUsersInSession stringValue] stringByAppendingString:@" user in session"];
        } else {
            headerCell.numUsers.text = [[_numberOfUsersInSession stringValue] stringByAppendingString:@" users in session"];
        }
        
        
        return cell;
    }
    return nil;
}


@end
