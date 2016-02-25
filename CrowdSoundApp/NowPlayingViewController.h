//
//  CurrentQueueViewController.h
//  CrowdSoundApp
//
//  Created by Nishad Krishnan on 2016-01-18.
//  Copyright © 2016 CrowdSound. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSStickyParallaxHeaderViewController.h"
#import "cZPickerView.h"


@interface NowPlayingViewController : CSStickyParallaxHeaderViewController<CZPickerViewDataSource, CZPickerViewDelegate>

@property (strong, nonatomic) NSString *sessionName;
@property (strong, nonatomic) NSNumber *numberOfUsersInSession;
@property (strong, nonatomic) NSMutableDictionary *songsWithVotes;
@property (strong, nonatomic) NSTimer *timer;

- (void) voteOccurredOnSong: (NSString *)songName andArtist: (NSString *)artist withValue: (BOOL)value;

- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView;
- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemsAtRows:(NSArray *)rows;
- (void)czpickerViewDidClickCancelButton:(CZPickerView *)pickerView;
- (UIImage *)czpickerView:(CZPickerView *)pickerView imageForRow:(NSInteger)row;

@end
