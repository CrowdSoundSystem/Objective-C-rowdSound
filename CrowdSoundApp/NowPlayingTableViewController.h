
#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface NowPlayingTableViewController : BaseTableViewController

@property (strong, nonatomic) NSString *sessionName;
@property (strong, nonatomic) NSNumber *numberOfUsersInSession;
@property (strong, nonatomic) NSTimer *timer;

@end
