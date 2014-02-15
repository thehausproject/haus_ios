//
//  DeviceStateCell.h
//  HAUS
//
//  Created by Russell Stephens on 2/15/14.
//  Copyright (c) 2014 HAUS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceStateCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *deviceState;
@property (weak, nonatomic) IBOutlet UIImageView *deviceStateImage;

@end
