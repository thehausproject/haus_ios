//
//  addDeviceControllerViewController.m
//  Ribbit
//
//  Created by Daniel Avram on 11/5/13.
//  Copyright (c) 2013 Daniel Avram. All rights reserved.
//

#import "addDeviceControllerViewController.h"

@interface addDeviceControllerViewController ()

@end

@implementation addDeviceControllerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	deviceTypes = [[NSArray alloc] initWithObjects:@"Lock", @"Access Code", @"Authorized User", @"Camera", @"Thermometer", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //one column
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return deviceTypes.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [deviceTypes objectAtIndex:row];
}



@end
