//
//  AddPermissionViewController.h
//  HAUS
//
//  Created by Russell Stephens on 2/16/14.
//  Copyright (c) 2014 HAUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputCell.h"
#import "HAUSWebServiceClient.h"

@interface AddPermissionViewController : UITableViewController <UITextFieldDelegate,InputCellDelegate,HAUSWebServiceClientDelegate> {
    NSMutableArray *cellInfo;
    HAUSWebServiceClient *client;
}

- (IBAction)grantPermission:(id)sender;
@property (strong, nonatomic) NSString *deviceID;
@end
