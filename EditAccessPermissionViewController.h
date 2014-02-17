//
//  EditAccessPermissionViewController.h
//  HAUS
//
//  Created by Russell Stephens on 2/16/14.
//  Copyright (c) 2014 HAUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HAUSWebServiceClient.h"
#import "InputCell.h"

@interface EditAccessPermissionViewController : UITableViewController <HAUSWebServiceClientDelegate, InputCellDelegate> {
    HAUSWebServiceClient *client;
    NSMutableArray *cellInfo;
}

@property (nonatomic, strong) NSString *permissionID;
- (IBAction)savePermission:(id)sender;

@end
