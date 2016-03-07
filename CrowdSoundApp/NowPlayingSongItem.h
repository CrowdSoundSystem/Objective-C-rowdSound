
#import <Foundation/Foundation.h>
#import "Song.h"

@interface NowPlayingSongItem : NSObject

@property Song *song;
@property BOOL isPlaying;
@property BOOL isBuffered;

@end
