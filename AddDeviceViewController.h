//
//  AddDeviceViewController.h
//  HAUS
//
//  Created by Russell Stephens on 2/15/14.
//  Copyright (c) 2014 HAUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputCell.h"
#import "HAUSWebServiceClient.h"

@interface AddDeviceViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, InputCellDelegate, HAUSWebServiceClientDelegate> {
    
    NSMutableArray *cellInfo;
    HAUSWebServiceClient *client;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

- (IBAction)claimDevice:(id)sender;

@end
