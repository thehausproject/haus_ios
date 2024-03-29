//
//  logicViewController.h
//  HAUS
//
//  Created by Daniel Avram on 2/12/14.
//  Copyright (c) 2014 HAUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HAUSWebServiceClient.h"

@interface LoginViewController : UIViewController <HAUSWebServiceClientDelegate, UITextFieldDelegate> {
    
    HAUSWebServiceClient *client;
    NSMutableDictionary *hausWebServiceCallbacks;
}

@property (strong, nonatomic) IBOutlet UITextField *userNameText;
@property (strong, nonatomic) IBOutlet UITextField *passwordText;
@property (strong, nonatomic) IBOutlet UITextField *signUp_userName;
@property (strong, nonatomic) IBOutlet UITextField *signUp_password;
@property (strong, nonatomic) IBOutlet UITextField *signUp_email;

@end
