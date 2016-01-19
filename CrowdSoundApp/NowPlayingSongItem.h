//
//  NowPlayingSongItem.h
//  CrowdSoundApp
//
//  Created by Nishad Krishnan on 2016-01-18.
//  Copyright © 2016 CrowdSound. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NowPlayingSongItem : NSObject

@property NSString *name;
@property NSString *artist;
@property NSString *genre;
@property BOOL isPlaying;

@end
