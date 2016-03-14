
#import <UIKit/UIKit.h>
#import "TSValidatedTextField.h"

@interface IPAddressViewController : UIViewController
@property (weak, nonatomic) IBOutlet TSValidatedTextField *ipField;
@property (weak, nonatomic) IBOutlet TSValidatedTextField *portField;

@end
