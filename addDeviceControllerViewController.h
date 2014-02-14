//
//  addDeviceControllerViewController.h
//  Ribbit
//
//  Created by Daniel Avram on 11/5/13.
//  Copyright (c) 2013 Daniel Avram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addDeviceControllerViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>{
    
    UIPickerView *deviceTypePicker;
    NSArray *deviceTypes;
    
}

@property (strong, nonatomic) IBOutlet UIPickerView *deviceTypePicker;



@end
