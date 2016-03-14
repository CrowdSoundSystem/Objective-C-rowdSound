
#import <Foundation/Foundation.h>

@interface VotesCache : NSObject

@property (strong, nonatomic) NSMutableDictionary *songsWithVotes;

+ (id)sharedInstance;
- (void) SyncVotesCacheWithCurrentQueue: (NSArray *)currentSongList;
- (void) cacheVote: (BOOL)voteValue forSongName: (NSString*)songName andArtist: (NSString*)artist;
- (int) getVoteForSongName:(NSString *)songName andArtist:(NSString *)artist;

@end
