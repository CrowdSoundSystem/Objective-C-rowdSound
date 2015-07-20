//
//  TableViewController.h
//  CrowdSoundIOS
//
//  Created by Nishad Krishnan on 2015-07-17.
//  Copyright (c) 2015 CrowdSound. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionManager.h"
#import "NativeDataScraper.h"


@interface TableViewController : UITableViewController <ConnectionDelegate>


@property (weak)ConnectionManager* connManager;
@property (strong)NativeDataScraper* scraper;
@end
