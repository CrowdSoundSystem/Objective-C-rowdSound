//
//  ViewController.h
//  CrowdSoundIOS
//
//  Created by Nishad Krishnan on 2015-07-12.
//  Copyright (c) 2015 CrowdSound. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionManager.h"
#import "WordCloudViewController.h"
#import "ThriftHeader.h"
#import "test.h"
#import "TableViewController.h"


@interface ViewController : UIViewController <NSStreamDelegate, ConnectionDelegate>

@property (strong)ConnectionManager* connManager;

@end

