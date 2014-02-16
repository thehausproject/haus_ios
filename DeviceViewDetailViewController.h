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

@protocol DeviceViewDetailViewControllerDelegate <NSObject>

- (void) fetchAndUpdateDetailViewDevice;

@end
@interface DeviceViewDetailViewController : UITableViewController <HAUSWebServiceClientDelegate>
{
    HAUSWebServiceClient *client;
    NSDictionary *deviceStateImages;
    NSDictionary *deviceStateOpposites;

    //cell layout
    int sections;
    NSMutableArray *rowsInSection;
    NSMutableArray *cellObjects;
    NSMutableArray *sectionHeaders;
    UIAlertView *expiredAlertView;
}

@property (strong, nonatomic) NSDictionary *device;
@property (strong, nonatomic) id <DeviceViewDetailViewControllerDelegate> masterDelegate;

@end
