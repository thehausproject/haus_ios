//
//  logicViewController.m
//  HAUS
//
//  Created by Daniel Avram on 2/12/14.
//  Copyright (c) 2014 Daniel Avram. All rights reserved.
//

#import "logicViewController.h"

@interface logicViewController ()

@end

@implementation logicViewController

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
    
    NSString* messageString = [NSString stringWithFormat:@"Username logging in: %@", self.userNameText.text];
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Logging in"
                                                      message:messageString
                                                     delegate:self
                                            cancelButtonTitle:@"ok"
                                            otherButtonTitles:nil];
    [message show];
    
    [self login];
    
    
    
}

- (NSString*)login{
    
    NSString *_userName = self.userNameText.text;
    NSString *_password = self.passwordText.text;
    
    NSString *post = @"username=";
    post = [post stringByAppendingString:_userName];
    post = [post stringByAppendingString:@"&password="];
    post = [post stringByAppendingString:_password];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://www.dylanboltz.com/haus/login.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];

    [conn start];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *response = nil;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
//    NSString *responseData;
//    
//    if ([response statusCode] >=200 && [response statusCode] <300)
//    {
//        responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
//        //NSLog(@"Response ==> %@", responseData);
//    } else {
//        if (error) NSLog(@"Error: %@", error);
//    }

    NSString *statusCode = [NSString stringWithFormat:@"status code: %d",response.statusCode];
    //responseData = format(@"status code: %d",response.statusCode);
    
    UIAlertView *message2 = [[UIAlertView alloc] initWithTitle:@"Response"
                                                      message:statusCode
                                                     delegate:self
                                            cancelButtonTitle:@"ok"
                                            otherButtonTitles:nil];
    [message2 show];

    
    return @"";
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
