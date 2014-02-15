//
//  DeviceViewController.h
//  HAUS
//
//  Created by Russell Stephens on 2/15/14.
//  Copyright (c) 2014 HAUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HAUSWebServiceClient.h"

@interface DeviceViewController : UIViewController <HAUSWebServiceClientDelegate, UITableViewDataSource, UITableViewDelegate> {
    HAUSWebServiceClient *client;
    NSMutableArray *devices;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end
