//
//  AccessPermissionViewController.h
//  HAUS
//
//  Created by Russell Stephens on 2/16/14.
//  Copyright (c) 2014 HAUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HAUSWebServiceClient.h"

@interface AccessPermissionViewController : UITableViewController <HAUSWebServiceClientDelegate> {
    HAUSWebServiceClient *client;
    
    //cell layout
    int sections;
    NSMutableArray *rowsInSection;
    NSMutableArray *cellObjects;
    NSMutableArray *sectionHeaders;
}


@property (nonatomic, strong) NSString *permissionID;
@end
