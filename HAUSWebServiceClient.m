//
//  HAUSWebServiceClient.m
//  HAUS
//
//  Created by Russell Stephens on 2/15/14.
//  Copyright (c) 2014 HAUS. All rights reserved.
//

#import "HAUSWebServiceClient.h"

@implementation HAUSWebServiceClient


#pragma mark - HAUSNSURLConnection Delegate Methods

-(void)connection:(HAUSNSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    // Begin server response -> reset response data
    responseData = nil;
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(HAUSNSURLConnection *)connection didReceiveData:(NSData *)data {
    
    // Append the data packets as they appear
    [responseData appendData:data];
}

-(NSCachedURLResponse *)connection:(HAUSNSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    
    // Avoid caching in a real-time system
    return nil;
}

#define PRINT_ERROR DLog(@"Error: %@", error)
-(void)connectionDidFinishLoading:(HAUSNSURLConnection *)connection {
    
    // Server response finished -> send response to callback
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
    
    if (error) {
        PRINT_ERROR;
        // what to do? call again?
    }
    
    [self.delegate hausWebServiceResponseForRequest:connection.tag withJSON:json];
}

-(void)connection:(HAUSNSURLConnection *)connection didFailWithError:(NSError *)error {
    
    //what to do here? call again?
    PRINT_ERROR;
}

#pragma mark - Helper Functions

- (NSData *) getHTTPBodyForParameter:(NSDictionary *)parameters {
    
    NSMutableString *bodyString = [NSMutableString new];
    for (NSString *key in [parameters allKeys]) {
        
        [bodyString appendString:[NSString stringWithFormat:@"%@=%@&",key, [parameters valueForKey:key]]];
    }
    //remove last &
    NSString *encodedBody = [bodyString substringToIndex:bodyString.length-1];
    
    return [encodedBody dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
}

- (NSMutableURLRequest *) getUrlRequestForHTTPMethod:(NSString *)httpMethod withParameters:(NSDictionary *)parameters {
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    NSData *postData = [self getHTTPBodyForParameter:parameters];
    
    [request setHTTPMethod:httpMethod];
    [request setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];

    return request;
}

- (void) sendRequest:(NSMutableURLRequest *)request {
    
    // Create url connection and fire request
    HAUSNSURLConnection *conn = [[HAUSNSURLConnection alloc] initWithRequest:request delegate:self];
    [conn setTag:SIGNIN_REQUEST];
    [conn start];
}
#pragma mark - HAUS Web Service Calls

-(void)signInWithParameters:(NSDictionary *)parameters {
    
    
    /*
     NSString *_userName = self.userNameText.text;
     NSString *_password = self.passwordText.text;
     
     NSString *post = @"username=";
     post = [post stringByAppendingString:_userName];
     post = [post stringByAppendingString:@"&password="];
     post = [post stringByAppendingString:_password];
     NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
     
     NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
     
     NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
     [request setURL:[NSURL URLWithString:@""]];
     [request setHTTPMethod:@"POST"];
     [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
     [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
     [request setHTTPBody:postData];
     
     NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
     
     [conn start];
     
     NSError *error = [[NSError alloc] init];
     NSHTTPURLResponse *response = nil;
     [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
     
     //
     if (response.statusCode == 200) {
     [self.welcomeMessage setText:@"Hello World"];
     //segue to next screen
     @try {
     [self performSegueWithIdentifier:@"showSecurity" sender:self];
     }
     @catch (NSException *exception) {
     NSLog(@"%@", exception);
     }
     @finally {
     NSLog(@"finally");
     }
     
     } else
     {
     
     NSString *errorLogin = [NSString stringWithFormat:@"Username %@ not valid.",_userName];
     UIAlertView *message2 = [[UIAlertView alloc] initWithTitle:@"Login Error"
     message:errorLogin
     delegate:self
     cancelButtonTitle:@"ok"
     otherButtonTitles:nil];
     [message2 show];
     
     }
     */
    //make the query string
    
    NSString *urlString = @"http://www.dylanboltz.com/haus/login.php";
    NSMutableURLRequest *request = [self getUrlRequestForHTTPMethod:@"POST" withParameters:parameters];
    [request setURL:[NSURL URLWithString:urlString]];
    
    [self sendRequest:request];

}

- (void) signUpWithParameters:(NSDictionary *)parameters {
    
    NSString *urlString = @"http://www.dylanboltz.com/haus/createuser.php";
    NSMutableURLRequest *request = [self getUrlRequestForHTTPMethod:@"POST" withParameters:parameters];
    [request setURL:[NSURL URLWithString:urlString]];
    
    [self sendRequest:request];
}
@end
