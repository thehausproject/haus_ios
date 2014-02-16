//
//  AddDeviceInputCell.m
//  HAUS
//
//  Created by Russell Stephens on 2/15/14.
//  Copyright (c) 2014 HAUS. All rights reserved.
//

#import "InputCell.h"

@implementation InputCell

#pragma mark - Text Field Delegate Methods
-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.cellDelegate) {
        [self.cellDelegate cellInputText:self.inputText.text forRow:self.tag];
    }
}

@end
