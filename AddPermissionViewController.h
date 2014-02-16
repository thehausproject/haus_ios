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

@protocol AddPermissionViewControllerDelegate <NSObject>

- (void) refreshPemissions;

@end
@interface AddPermissionViewController : UITableViewController <UITextFieldDelegate, InputCellDelegate, HAUSWebServiceClientDelegate, UIAlertViewDelegate> {
    NSMutableArray *cellInfo;
    HAUSWebServiceClient *client;
    BOOL popOnSuccess;
}

- (IBAction)grantPermission:(id)sender;
@property (strong, nonatomic) NSString *deviceID;
@property (strong, nonatomic) id <AddPermissionViewControllerDelegate> delegate;
@end
