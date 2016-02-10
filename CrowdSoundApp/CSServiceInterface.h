
#import <Foundation/Foundation.h>
#import "NowPlayingSongItem.h"
#import "SessionData.h"
#import "Bolts.h"

@interface CSServiceInterface : NSObject

+ (id)sharedInstance;
- (BFTask*) getSongQueue;
- (BFTask *) sendSongs:(NSArray *)songs;
- (BFTask *) voteForSong:(NSString *)songName withArtist:(NSString *)artist withValue:(BOOL)like;
- (BFTask *) getSessionData;

@end
