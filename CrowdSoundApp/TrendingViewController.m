//
//  TrendingViewController.m
//  CrowdSoundApp
//
//  Created by Nishad Krishnan on 2015-12-27.
//  Copyright © 2015 CrowdSound. All rights reserved.
//

#import "TrendingViewController.h"
#import "HPLTagCloudGenerator.h"

@interface TrendingViewController ()

@end

@implementation TrendingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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
    });
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
