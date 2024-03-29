//
//  AddDeviceInputCell.h
//  HAUS
//
//  Created by Russell Stephens on 2/15/14.
//  Copyright (c) 2014 HAUS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InputCellDelegate <NSObject>

- (void) cellInputText:(NSString *)text forRow:(NSInteger)row;

@end
@interface InputCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UITextField *inputText;

@property (weak, nonatomic) id <InputCellDelegate> cellDelegate;
@end
