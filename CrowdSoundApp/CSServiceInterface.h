
#import <Foundation/Foundation.h>
#import "NowPlayingSongItem.h"
#import "SessionData.h"
#import "TrendingArtist.h"
#import "Bolts.h"

@interface CSServiceInterface : NSObject

+ (id)sharedInstance;
+ (id)sharedInstanceWithDynamicHostAddr: (NSString *) hostAddr;
- (BFTask*) getSongQueue;
- (BFTask *) getIsPlaying;
- (BFTask *) sendSongs:(NSArray *)songs;
- (BFTask *) voteForSong:(NSString *)songName withArtist:(NSString *)artist withValue:(BOOL)like;
- (BFTask *)voteToSkip;
- (BFTask *) getSessionData;
- (BFTask *) getTrendingArtists;

@end
