
#import "VotesCache.h"
#import "NowPlayingSongItem.h"

@implementation VotesCache

+ (id)sharedInstance {
    static VotesCache *sharedVotesCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedVotesCache = [[self alloc] init];
    });
    return sharedVotesCache;
}

- (id)init {
    self = [super init];
    if (self) {
        _songsWithVotes = [[NSMutableDictionary alloc]init];
    }
    return self;
}


/*- (void) SyncVotesCacheWithCurrentQueue: (NSArray *)currentSongList {
    //Initialize songsWithVotes array with all songs voting abilities set to visible
    if (!_songsWithVotes) {
        NSMutableArray *valueArray = [[NSMutableArray alloc]init];
        NSMutableArray *keysArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < currentSongList.count; i ++) {
            NowPlayingSongItem *item = [currentSongList objectAtIndex:i];
            NSString *key = [self createKeyForSongsWithVotesWithSong:item.song.name andArtist:(NSString *)item.song.artists[0]];
            [keysArray addObject:key];
            [valueArray addObject:[NSNumber numberWithInt:-1]];
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
            NSLog(@"Key: %@",key);
            [_songsWithVotes setObject:[NSNumber numberWithInt:-1] forKey:key];
        }
    }
    
    // Second delete the songs that are in the songsWithVotes list but not in the current queue anymore.
    
    NSArray *keysArray = _songsWithVotes.allKeys;
    NSMutableArray *keysToDelete = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < keysArray.count; i++) {
        if (![songSet containsObject:[keysArray objectAtIndex:i]]) {
            [keysToDelete addObject:keysArray[i]];
        }
    }
    [_songsWithVotes removeObjectsForKeys:keysToDelete];
}*/

//Returns -1 if not in cache, 1 if vote up, 0 if vote down

- (int) getVoteForSongName:(NSString *)songName andArtist:(NSString *)artist {
    NSString *key = [self createKeyForSongsWithVotesWithSong:songName andArtist:artist];
    
    if ([_songsWithVotes objectForKey:key] == nil) {
        return -1;
    } else {
        int value = [[_songsWithVotes objectForKey:key] intValue];
        return value;
    }
}


- (void) cacheVote: (BOOL)voteValue forSongName: (NSString*)songName andArtist: (NSString*)artist {
    [_songsWithVotes setObject:[NSNumber numberWithBool:voteValue] forKey:[self createKeyForSongsWithVotesWithSong:songName andArtist:artist]];
    
}

- (NSString *) createKeyForSongsWithVotesWithSong: (NSString *)songName andArtist: (NSString *) artist {
    //Comma is the current delimiter clearly
    return [songName stringByAppendingString:[@"," stringByAppendingString:artist]];
}

@end
