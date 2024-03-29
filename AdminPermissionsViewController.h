//
//  AdminPermissionsViewController.h
//  HAUS
//
//  Created by Russell Stephens on 2/15/14.
//  Copyright (c) 2014 HAUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HAUSWebServiceClient.h"
#import "AddPermissionViewController.h"

@interface AdminPermissionsViewController : UITableViewController <HAUSWebServiceClientDelegate, AddPermissionViewControllerDelegate> {
    HAUSWebServiceClient *client;
    NSArray *permissions;
    NSArray *rowKeys;
}

@property (strong, nonatomic) NSString *deviceID;
@end
