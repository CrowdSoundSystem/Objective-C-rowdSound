
#import <Foundation/Foundation.h>
#import "NowPlayingSongItem.h"
#import "Bolts.h"

@interface CSServiceInterface : NSObject

+ (id)sharedInstance;
- (BFTask*) getSongQueue;

@end
