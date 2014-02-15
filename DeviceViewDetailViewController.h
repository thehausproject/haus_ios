//
//  DeviceViewDetailViewController.h
//  HAUS
//
//  Created by Russell Stephens on 2/15/14.
//  Copyright (c) 2014 HAUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceStateCell.h"
#import "HAUSWebServiceClient.h"

@interface DeviceViewDetailViewController : UITableViewController <HAUSWebServiceClientDelegate>
{
    HAUSWebServiceClient *client;
    NSDictionary *deviceStateImages;
    NSDictionary *deviceStateOpposites;
}

@property (strong, nonatomic) NSDictionary *device;

@end