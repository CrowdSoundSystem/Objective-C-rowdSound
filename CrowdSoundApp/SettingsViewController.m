
#import "SettingsViewController.h"
#import "CSServiceInterface.h"

@interface SettingsViewController ()
@property (strong) CSServiceInterface *csInterface;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Settings"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
