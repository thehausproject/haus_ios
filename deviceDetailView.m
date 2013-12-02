//
//  deviceDetailView.m
//  HAUS
//
//  Created by Daniel Avram on 12/1/13.
//  Copyright (c) 2013 Daniel Avram. All rights reserved.
//

#import "deviceDetailView.h"

@implementation deviceDetailView
//- (IBAction)unlockButton:(id)sender {
//    deboltLock();
//}



// Functions
-(void)deboltLock
{
    
    
//    NSString *post = @"user_token=348e021c5cf5dabc1c531c00d628633a42074e0defe1e239e42b5c91e5637a96&device_id=5&state=UNLOCKED";
//    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//    
//    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
//    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:@"http://www.dylanboltz.com/haus/postdevicestate.php"]];
//    [request setHTTPMethod:@"GET"];
//    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    [request setHTTPBody:postData];
    
    
    NSURL *url = [NSURL URLWithString:@"http://www.dylanboltz.com/haus/postdevicestate.php?user_token=348e021c5cf5dabc1c531c00d628633a42074e0defe1e239e42b5c91e5637a96&device_id=5&state=UNLOCKED"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"ret=%@", ret);
    
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Front Door Lock"
                                                      message:@"Bolt is unlocked for 3 seconds."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
    
    
    return;
}


- (IBAction)unlockButton:(id)sender {
    
    [self deboltLock];
}

@end
