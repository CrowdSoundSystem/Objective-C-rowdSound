//
//  CurrentQueueViewController.h
//  CrowdSoundApp
//
//  Created by Nishad Krishnan on 2016-01-18.
//  Copyright © 2016 CrowdSound. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSStickyParallaxHeaderViewController.h"


@interface NowPlayingViewController : CSStickyParallaxHeaderViewController

@property (strong, nonatomic) NSString *sessionName;
@property (strong, nonatomic) NSNumber *numberOfUsersInSession;
@property (strong, nonatomic) NSMutableDictionary *songsWithVotes;

- (void) voteOccurredOnSong: (NSString *)songName andArtist: (NSString *)artist withValue: (BOOL)value;

@end
