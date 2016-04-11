
#import "BaseViewController.h"
#import "UIViewController+RESideMenu.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Configure hamburger menu
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(showMenuViewController)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBar.barTintColor = [Helper getCloudGrey];
    
    // Specifically so the status bar is white
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
}

- (void) showMenuViewController {
    [self presentLeftMenuViewController:@"MenuTableViewController"];
    
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont boldSystemFontOfSize:20.0];
        titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        
        // This colour determines the title colour
        titleView.textColor = [UIColor whiteColor];
        
        self.navigationItem.titleView = titleView;
    }
    titleView.text = title;
    [titleView sizeToFit];
}



@end

@interface BaseTableViewController()

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Configure hamburger menu icon
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(showMenuViewController)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBar.barTintColor = [Helper getCloudGrey];

    // Specifically for keeping Status bar white
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
}

- (void) showMenuViewController {
    [self presentLeftMenuViewController:@"MenuTableViewController"];
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont boldSystemFontOfSize:20.0];
        titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        
        // This colour determines the title colour
        titleView.textColor = [UIColor whiteColor];
        
        self.navigationItem.titleView = titleView;
    }
    titleView.text = title;
    [titleView sizeToFit];
}

@end
