
#import <UIKit/UIKit.h>
#import "cZPickerView.h"
#import "BaseViewController.h"

@interface NowPlayingTableViewController : BaseTableViewController<CZPickerViewDelegate, CZPickerViewDataSource>

@property (strong, nonatomic) NSString *sessionName;
@property (strong, nonatomic) NSNumber *numberOfUsersInSession;
@property (strong, nonatomic) NSTimer *timer;

- (void) voteOccurredOnSong: (NSString *)songName andArtist: (NSString *)artist withValue: (BOOL)value;

- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView;
- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemsAtRows:(NSArray *)rows;
- (void)czpickerViewDidClickCancelButton:(CZPickerView *)pickerView;
- (UIImage *)czpickerView:(CZPickerView *)pickerView imageForRow:(NSInteger)row;

@end
