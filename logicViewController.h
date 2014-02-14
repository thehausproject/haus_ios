//
//  logicViewController.h
//  HAUS
//
//  Created by Daniel Avram on 2/12/14.
//  Copyright (c) 2014 Daniel Avram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface logicViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *userNameText;
@property (strong, nonatomic) IBOutlet UITextField *passwordText;
@property (strong, nonatomic) IBOutlet UITextField *signUp_userName;
@property (strong, nonatomic) IBOutlet UITextField *signUp_password;
@property (strong, nonatomic) IBOutlet UITextField *signUp_email;
@property (strong, nonatomic) IBOutlet UILabel *dateField;
@property (strong, nonatomic) IBOutlet UILabel *welcomeMessage;

@end
