
#import "IPAddressViewController.h"
#import "CSServiceInterface.h"
#import "TWMessageBarManager.h"


@interface IPAddressViewController ()

@end

@implementation IPAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _ipField.regexpPattern = @"^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$";
    _ipField.regexpValidColor = [UIColor blackColor];
    _ipField.regexpInvalidColor = [UIColor redColor];
    _portField.regexpPattern = @"^([0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$";
    _portField.regexpValidColor = [UIColor blackColor];
    _portField.regexpInvalidColor = [UIColor redColor];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"lastIP"]) {
        _ipField.text = [defaults objectForKey:@"lastIP"];
    }
    if ([defaults objectForKey:@"lastPort"]) {
        _portField.text = [defaults objectForKey:@"lastPort"];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)nextButtonPressed:(id)sender {
    if (_ipField.isValid && _portField.isValid) {
        
        //Cache port and IP for use next time the app opens to this screen
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:_ipField.text forKey:@"lastIP"];
        [defaults setObject:_portField.text forKey:@"lastPort"];
        
        NSString *fullString = [_ipField.text stringByAppendingString:[@":" stringByAppendingString:_portField.text]];
        
        //Using default for now
        [CSServiceInterface sharedInstance];
        //[CSServiceInterface sharedInstanceWithDynamicHostAddr:fullString];
        [self performSegueWithIdentifier:@"nextSegue" sender:self];
    } else {
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Error" description:@"One or more fields are not valid." type:TWMessageBarMessageTypeError];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
