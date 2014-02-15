//
//  DeviceViewController.h
//  HAUS
//
//  Created by Russell Stephens on 2/15/14.
//  Copyright (c) 2014 HAUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HAUSWebServiceClient.h"
#import "DeviceViewDetailViewController.h"
#import "AppDelegate.h"

@interface DeviceViewController : UIViewController <HAUSWebServiceClientDelegate, UITableViewDataSource, UITableViewDelegate, DeviceViewDetailViewControllerDelegate> {
    
    HAUSWebServiceClient *client;
    NSMutableArray *devices;
    BOOL updateDetailViewDevice;
    AppDelegate *appDelegate;
    
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) DeviceViewDetailViewController *detailView;
@end
