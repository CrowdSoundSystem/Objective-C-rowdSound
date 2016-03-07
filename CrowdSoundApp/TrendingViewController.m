
#import "TrendingViewController.h"
#import <GRPCClient/GRPCCall+Tests.h>
#import <CrowdsoundService.pbrpc.h>
#import "BubbleScene.h"
#import "CSServiceInterface.h"

@interface TrendingViewController ()
@property(nonatomic) NSString * kHostAddress;
@end

@interface TrendingViewController()

@property (strong) CSServiceInterface *csInterface;

@end

@implementation TrendingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _csInterface = [CSServiceInterface sharedInstance];
    
    CGFloat navBarHeight = CGRectGetHeight(self.navigationController.navigationBar.frame);
    CGFloat statusBarHeight = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
    
    NSArray *artists = @[@"Adele", @"Armin Van Burren", @"Drake", @"Martin Garrix", @"Jay Z", @"Rihanna",
                         @"Wiz Khalifa", @"Beyonce", @"Schoolboy Q", @"Kygo", @"David Guetta", @"Autograf",
                         @"Kendrink Lamar", @"Taylor Swift", @"Kanye West"];
    NSMutableArray *weights = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < artists.count; i++) {
        weights[i] = [NSNumber numberWithFloat:[Helper randomBetweenMin:0.0 AndMax:1.0]];
    }
    
    SKView *skView = [[SKView alloc]initWithFrame:self.view.bounds];
    skView.backgroundColor = [SKColor blackColor];
    [self.view addSubview:skView];
    
    
    BubbleScene *scene = [[BubbleScene alloc]initWithSize:skView.bounds.size];
    scene.topOffset = navBarHeight + statusBarHeight;
    scene.bottomOffset = 200;
    [skView presentScene:scene];
    
    [[_csInterface getTrendingArtists] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (!task.error) {
            NSArray* artists = task.result;
            NSNumber *highestWeight = [(TrendingArtist*)artists[1] weight];
            
            for (int i = 0; i < artists.count; i++) {
                BubbleNode *node = [BubbleNode instantiateWithText:[(TrendingArtist*)artists[1] name]andRadius:([[(TrendingArtist*)artists[i] weight] intValue]/[highestWeight intValue] * (60 - 30) + 30)];
                [scene addChild:node];
            }
        }
        return nil;
    }];
    
    /*MMMaterialDesignSpinner *spinnerView = [[MMMaterialDesignSpinner alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 40, 40)];
    
    spinnerView.lineWidth = 1.5f;
    spinnerView.tintColor = [UIColor blueColor];
    
    [self.view addSubview:spinnerView];
    [self.view bringSubviewToFront:spinnerView];
    [spinnerView startAnimating];*/
    /*dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // This runs in a background thread
        
        // dictionary of tags
        NSDictionary *tagDict = @{@"tag1": @3,
                                  @"tag2": @5,
                                  @"tag3": @7,
                                  @"tag4": @2};
        
        
        HPLTagCloudGenerator *tagGenerator = [[HPLTagCloudGenerator alloc] init];
        tagGenerator.size = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
        tagGenerator.tagDict = tagDict;
        
        NSArray *views = [tagGenerator generateTagViews];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            // This runs in the UI Thread
            
            for(UIView *v in views) {
                // Add tags to the view we created it for
                [self.view addSubview:v];
                [self.view bringSubviewToFront:v];
            }
            
        });
    });*/
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
