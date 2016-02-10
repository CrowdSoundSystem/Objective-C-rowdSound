//
//  NowPlayingCell.h
//  CrowdSoundApp
//
//  Created by Nishad Krishnan on 2016-02-08.
//  Copyright © 2016 CrowdSound. All rights reserved.
//

#import "CSCell.h"
#import "NowPlayingViewController.h"

@interface NowPlayingCell : CSCell

@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *dislikeButton;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) NowPlayingViewController *nowPlayingViewController;

- (IBAction)likeButtonPressed:(id)sender;
- (IBAction)dislikeButtonPressed:(id)sender;

@end
