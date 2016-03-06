//
//  NowPlayingCell.m
//  CrowdSoundApp
//
//  Created by Nishad Krishnan on 2016-02-08.
//  Copyright © 2016 CrowdSound. All rights reserved.
//

#import "NowPlayingCell.h"
#import "CSServiceInterface.h"

@implementation NowPlayingCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)likeButtonPressed:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button) {
        
        [_nowPlayingViewController voteOccurredOnSong:self.textLabel.text andArtist:self.artistLabel.text withValue:YES];
        
        /*button.transform = CGAffineTransformMakeScale(0.1, 0.1);
        
        [UIView animateWithDuration:1.5 delay:0 usingSpringWithDamping:2.0 initialSpringVelocity:6.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            button.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if (finished) {
                [_nowPlayingViewController voteOccurredOnSong:self.textLabel.text andArtist:self.artistLabel.text withValue:YES];
            }
        }];*/
        
    }
}

- (IBAction)dislikeButtonPressed:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button) {
        
        [_nowPlayingViewController voteOccurredOnSong:self.textLabel.text andArtist:self.artistLabel.text withValue:NO];
        
        /*button.transform = CGAffineTransformMakeScale(0.1, 0.1);
        
        [UIView animateWithDuration:1.5 delay:0 usingSpringWithDamping:2.0 initialSpringVelocity:6.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            button.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if (finished) {
                
            }
        }];*/
        
    }
}
@end
