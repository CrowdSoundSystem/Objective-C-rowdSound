
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
@property (strong) BubbleScene *scene;

@end

@implementation TrendingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _csInterface = [CSServiceInterface sharedInstance];
    
    [self setTitle:@"Trending Artists"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Vote" style:UIBarButtonItemStylePlain target:self action:@selector(performVote)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
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
    
    
    _scene = [[BubbleScene alloc]initWithSize:skView.bounds.size];
    _scene.topOffset = navBarHeight + statusBarHeight;
    _scene.bottomOffset = 200;
    [skView presentScene:_scene];
    
    [[_csInterface getTrendingArtists] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (!task.error) {
            NSArray* artists = task.result;
            
            int highestWeight = -1;
            
            for (int i = 0; i < artists.count; i++) {
                if (highestWeight < [[(TrendingArtist*)artists[i] weight] intValue]) {
                    highestWeight = [[(TrendingArtist*)artists[i] weight] intValue];
                }
            }
            
            if (highestWeight == 0) {
                for (int i = 0; i < artists.count; i++) {
                    BubbleNode *node = [BubbleNode instantiateWithText:[(TrendingArtist*)artists[i] name]andRadius:(highestWeight * (60 - 30) + 30)];
                    [_scene addChild:node];
                }
            } else if (highestWeight > 0){
                for (int i = 0; i < artists.count; i++) {
                    double multFactor = [[(TrendingArtist*)artists[i] weight] intValue]/highestWeight;
                    BubbleNode *node = [BubbleNode instantiateWithText:[(TrendingArtist*)artists[i] name]andRadius:(multFactor * (60 - 30) + 30)];
                    [_scene addChild:node];
                }
            } else {
                NSLog(@"Error: The highest weight in artist array was -1");
            }
        }
        return nil;
    }];
    
}

- (void) performVote {
    NSArray * indexArray = [_scene indexOfSelectedNodes];
    NSMutableArray *artistNameArray = [[NSMutableArray alloc]init];
    
    //[[_csInterface voteForSong:<#(NSString *)#> withArtist:<#(NSString *)#> withValue:<#(BOOL)#>]]
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Sorry" description:@"Shit hasn't been implemented yet." type:TWMessageBarMessageTypeInfo];
    });
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
