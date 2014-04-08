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
#import "DejalActivityView.h"

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
        hausWebServiceCallbacks = [NSMutableDictionary new];
    }
    //add the callback at its tag type
    [hausWebServiceCallbacks setObject:[CallbackHelperMethods makeInvocationWithSEL:@selector(signInResponse:) forSender:self] forKey:[[NSNumber numberWithInt:SIGNIN_REQUEST] stringValue]];
    [hausWebServiceCallbacks setObject:[CallbackHelperMethods makeInvocationWithSEL:@selector(signUpResponse:) forSender:self] forKey:[[NSNumber numberWithInt:SIGNUP_REQUEST] stringValue]];
    
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

- (void) showActivityView {
    [DejalBezelActivityView activityViewForView:self.view withLabel:@""];
}
- (IBAction)hitLogin:(id)sender {
    
    [self showActivityView];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:self.userNameText.text forKey:@"username"];
    [parameters setObject:self.passwordText.text forKey:@"password"];
    
    [client createPOSTRequestWithURL:CREATE_URL_STRING(@"login") withParameters:parameters withTag:SIGNIN_REQUEST];
    
    
    
}


- (IBAction)hitSignUp:(id)sender {
    
    [self showActivityView];
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setObject:self.signUp_userName.text forKey:@"username"];
    [parameters setObject:self.signUp_password.text forKey:@"password"];
    [parameters setObject:self.signUp_email.text forKey:@"email"];
    
    [client createPOSTRequestWithURL:CREATE_URL_STRING(@"createuser") withParameters:parameters withTag:SIGNUP_REQUEST];
    
}


#pragma mark - HAUS Web Service Delegate

#define JSON_ARG_INDEX 2
- (void) hausWebServiceResponseForRequest:(kHAUSWebServiceRequestType)requestType withJSON:(NSDictionary *)json {
    
    DLog(@"Received");
    DLog(@"%@", json);
    
    [DejalBezelActivityView removeView];
    
    NSInvocation *invocation = [hausWebServiceCallbacks valueForKey:[[NSNumber numberWithInt:requestType] stringValue]];
    if(invocation) {
        [invocation setArgument:&(json) atIndex:JSON_ARG_INDEX];
        [invocation invoke];
    }else {
        DLog(@"Unimplemented response callback for Request type: %i",requestType);
        DLog(@"With json: %@", json);   
    }
    
    
}

#pragma mark - Web Service Helpers

- (void) setUserTokenFromJSON:(NSDictionary *)json {
    
    if ([json valueForKey:@"user_token"]) {
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate.hausUserData setUserToken:[json valueForKey:@"user_token"]];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Define Specific Callback Functions
- (void) signInResponse:(NSDictionary *)json {
    if ([json valueForKey:@"error"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[json valueForKey:@"error"] delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles: nil ];
        [alert show];
        [self.passwordText setText:@""];
    }else {
        
        [self setUserTokenFromJSON:json];
    }
}

- (void) signUpResponse:(NSDictionary *)json {
    
    [self setUserTokenFromJSON:json];
    
}

#define LOGIN_KEYBOARD 1
#define SIGNUP_KEYBOARD 2
#pragma mark - Text Field Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if (textField.tag == LOGIN_KEYBOARD) {
        [self hitLogin:self];
    }else if (textField.tag == SIGNUP_KEYBOARD){
        [self hitSignUp:self];
    }
    return YES;
}

@end
