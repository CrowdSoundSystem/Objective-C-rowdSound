
#import "TrendingViewController.h"
#import <GRPCClient/GRPCCall+Tests.h>
#import <CrowdsoundService.pbrpc.h>
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
    
    CGFloat navBarHeight = CGRectGetHeight(self.navigationController.navigationBar.frame);
    CGFloat statusBarHeight = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
    
    self.view.backgroundColor = [Helper getCloudGrey];
    
    SKView *skView = [[SKView alloc]initWithFrame:self.view.bounds];
    skView.backgroundColor = [SKColor blackColor];
    [self.view addSubview:skView];
    
    
    _scene = [[BubbleScene alloc]initWithSize:skView.bounds.size];
    _scene.floatingDelegate = self;
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
                    if (multFactor < 0)
                        continue;
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

- (void) viewDidDisappear:(BOOL)animated {
    [_scene removeAllChildren];
    _scene = nil;
}

- (void) performVoteForNodeAtIndex: (int)index withValue: (BOOL)value {
    
    BubbleNode *node = (BubbleNode *)_scene.floatingNodes[index];
    NSString *artist = node.labelNode.text;
    
    if (node.cachedLabel) {
        artist = node.cachedLabel;
    }
    
    [[_csInterface voteForArtist:artist withValue:value] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (task.error) {
            [[TWMessageBarManager sharedInstance]showMessageWithTitle:@"Error" description:@"Vote could not be sent" type:TWMessageBarMessageTypeError];
        }
        return nil;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) floatingScene: (SIFloatingCollectionScene *)scene didTapFloatingNodeAtIndex: (int)index {
    [self performVoteForNodeAtIndex:index withValue:true];
    return true;
}

- (BOOL) floatingScene: (SIFloatingCollectionScene *)scene didLongPressFloatingNodeAtIndex: (int)index {
    [self performVoteForNodeAtIndex:index withValue:false];
    return true;
}
@end
