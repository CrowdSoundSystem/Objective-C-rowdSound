//
//  NowPlayingCell.h
//  CrowdSoundApp
//
//  Created by Nishad Krishnan on 2016-02-08.
//  Copyright © 2016 CrowdSound. All rights reserved.
//

#import "CSCell.h"

@interface NowPlayingCell : CSCell

@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *dislikeButton;

- (IBAction)likeButtonPressed:(id)sender;
- (IBAction)dislikeButtonPressed:(id)sender;

@end
