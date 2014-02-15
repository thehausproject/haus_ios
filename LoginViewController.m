//
//  logicViewController.m
//  HAUS
//
//  Created by Daniel Avram on 2/12/14.
//  Copyright (c) 2014 HAUS. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "CallbackHelperMethods.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
	// Do any additional setup after loading the view.
    
    if (!client) {
        client = [HAUSWebServiceClient new];
        client.delegate = self;
    }
    
    [self initWebServiceCallbacks];
}

- (void) initWebServiceCallbacks {
    
    if (!hausWebServiceCallbacks) {
        hausWebServiceCallbacks = [NSMutableArray new];
    }
    
    //add the callback at its tag type
    [hausWebServiceCallbacks insertObject:[CallbackHelperMethods makeInvocationWithSEL:@selector(signInResponse:) forSender:self] atIndex:SIGNIN_REQUEST];
    
}
- (BOOL)usernameReturn:(UITextField *)textField
{
    NSLog(@"You entered %@",self.userNameText.text);
    [self.userNameText resignFirstResponder];
    return YES;
}

- (BOOL)passwordReturn:(UITextField *)textField
{
    NSLog(@"You entered %@",self.passwordText.text);
    [self.passwordText resignFirstResponder];
    return YES;
}

- (IBAction)hitLogin:(id)sender {
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:self.userNameText.text forKey:@"username"];
    [parameters setObject:self.passwordText.text forKey:@"password"];
    
    [client signInWithParameters:parameters];
    
    
    
}


- (IBAction)hitSignUp:(id)sender {
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setObject:self.signUp_userName.text forKey:@"username"];
    [parameters setObject:self.signUp_password forKey:@"password"];
    [parameters setObject:self.signUp_email forKey:@"email"];
    
    
    [client signUpWithParameters:parameters];
    
}


#pragma mark - HAUS Web Service Delegate

#define JSON_ARG_INDEX 2
- (void) hausWebServiceResponseForRequest:(kHAUSWebServiceRequestType)requestType withJSON:(NSDictionary *)json {
    
    NSInvocation *invocation = [hausWebServiceCallbacks objectAtIndex:requestType];
    [invocation setArgument:&(json) atIndex:JSON_ARG_INDEX];
    [invocation invoke];
    
}

#pragma mark - Define Specific Callback Functions
- (void) signInResponse:(NSDictionary *)json {
    if ([json valueForKey:@"error"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[json valueForKey:@"error"] delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles: nil ];
        [alert show];
        [self.passwordText setText:@""];
    }else {
        
        //set user token in the app delegate
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate.hausUserData setUserToken:[json valueForKey:@"user_token"]];
    }
}


@end
