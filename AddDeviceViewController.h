//
//  AddDeviceViewController.h
//  HAUS
//
//  Created by Russell Stephens on 2/15/14.
//  Copyright (c) 2014 HAUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddDeviceInputCell.h"

@interface AddDeviceViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, AddDeviceInputCellDelegate> {
    
    NSMutableArray *cellInfo;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

- (IBAction)claimDevice:(id)sender;

@end
