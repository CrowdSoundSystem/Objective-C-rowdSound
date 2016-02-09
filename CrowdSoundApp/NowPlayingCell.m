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
        NSString *buttonId = button.accessibilityIdentifier;
        NSString *like = @"like";
        NSString *id = [buttonId substringFromIndex:like.length];
        NSLog(@"ID: %d", [id intValue]);
        
        [[CSServiceInterface sharedInstance] voteForSong:self.textLabel.text withArtist:nil withValue:true];
        
        button.enabled = false;
        
    }
}

- (IBAction)dislikeButtonPressed:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button) {
        NSString *buttonId = button.accessibilityIdentifier;
        NSString *like = @"dislike";
        NSString *id = [buttonId substringFromIndex:like.length];
        NSLog(@"ID: %d", [id intValue]);
        
        [[CSServiceInterface sharedInstance] voteForSong:self.textLabel.text withArtist:nil withValue:true];
        
        button.enabled = false;
        
    }
}
@end
