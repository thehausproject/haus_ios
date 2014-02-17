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

- (NSString *) getParametersAsQueryString:(NSDictionary *)parameters {
    
    NSMutableString *bodyString = [NSMutableString new];
    for (NSString *key in [parameters allKeys]) {
        
        [bodyString appendString:[NSString stringWithFormat:@"%@=%@&",key, [parameters valueForKey:key]]];
    }
    //remove last &
   return [bodyString substringToIndex:bodyString.length-1];
}

- (NSData *) getHTTPBodyForParameter:(NSDictionary *)parameters {
    
    
    NSString *encodedBody = [self getParametersAsQueryString:parameters];
    return [encodedBody dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
}

- (NSMutableURLRequest *) getUrlRequestForHTTPMethod:(NSString *)httpMethod withParameters:(NSDictionary *)parameters {
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    NSData *postData = [self getHTTPBodyForParameter:parameters];
    
    [request setHTTPMethod:httpMethod];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postData length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];

    return request;
}

- (void) sendRequest:(NSMutableURLRequest *)request withTag:(kHAUSWebServiceRequestType)requestType {
    
    // Create url connection and fire request
    HAUSNSURLConnection *conn = [[HAUSNSURLConnection alloc] initWithRequest:request delegate:self];
    [conn setTag:requestType];
    [conn start];
}
#pragma mark - HAUS Web Service Calls

-(void)signInWithParameters:(NSDictionary *)parameters {
    
    NSString *urlString = @"http://www.dylanboltz.com/haus/login.php";
    NSMutableURLRequest *request = [self getUrlRequestForHTTPMethod:@"POST" withParameters:parameters];
    [request setURL:[NSURL URLWithString:urlString]];
    
    [self sendRequest:request withTag:SIGNIN_REQUEST];

}

- (void) signUpWithParameters:(NSDictionary *)parameters {
    
    NSString *urlString = @"http://www.dylanboltz.com/haus/createuser.php";
    NSMutableURLRequest *request = [self getUrlRequestForHTTPMethod:@"POST" withParameters:parameters];
    [request setURL:[NSURL URLWithString:urlString]];
    
    [self sendRequest:request withTag:SIGNUP_REQUEST];
}

- (void) claimDeviceWithParameters:(NSDictionary *)parameters {
    
    NSString *urlString = @"http://www.dylanboltz.com/haus/claimdevice.php";
    NSMutableURLRequest *request = [self getUrlRequestForHTTPMethod:@"POST" withParameters:parameters];
    [request setURL:[NSURL URLWithString:urlString]];
    
    [self sendRequest:request withTag:CLAIM_DEVICE];
    
}

-(void)getDeviceInfoWithParameters:(NSDictionary *)parameters {
    
    NSString *urlString = @"http://www.dylanboltz.com/haus/getdeviceinfo.php";
    
    NSString *queryString = [NSString stringWithFormat:@"%@?%@",urlString,[self getParametersAsQueryString:parameters]];
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:[NSURL URLWithString:queryString]];
    [request setHTTPMethod:@"GET"];
    
    [self sendRequest:request withTag:GET_DEVICE_INFO];
}

- (void)postDeviceStateWithParameters:(NSDictionary *)parameters {
    
    NSString *urlString = @"http://www.dylanboltz.com/haus/postdevicestate.php";
    NSMutableURLRequest *request = [self getUrlRequestForHTTPMethod:@"POST" withParameters:parameters];
    [request setURL:[NSURL URLWithString:urlString]];
    
    [self sendRequest:request withTag:POST_DEVICE_STATE];
}

-(void)getDeviceUserInfoWithParameters:(NSDictionary *)parameters {
    
    NSString *urlString = @"http://www.dylanboltz.com/haus/getdeviceuserinfo.php";
    
    NSString *queryString = [NSString stringWithFormat:@"%@?%@",urlString,[self getParametersAsQueryString:parameters]];
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:[NSURL URLWithString:queryString]];
    [request setHTTPMethod:@"GET"];
    
    [self sendRequest:request withTag:GET_DEVICE_USER_INFO];
}

- (void) grantUserPermissionWithParameters:(NSDictionary *)parameters {
    
    
    NSString *urlString = @"http://www.dylanboltz.com/haus/grantuserpermission.php";
    NSMutableURLRequest *request = [self getUrlRequestForHTTPMethod:@"POST" withParameters:parameters];
    [request setURL:[NSURL URLWithString:urlString]];
    
    [self sendRequest:request withTag:GRANT_USER_PERMISSION];
}

-(void)getDevicePermissionAccessInfoWithParameters:(NSDictionary *)parameters {
    
    NSString *urlString = @"http://www.dylanboltz.com/haus/getdevicepermissionaccessinfo.php";
    
    NSString *queryString = [NSString stringWithFormat:@"%@?%@",urlString,[self getParametersAsQueryString:parameters]];
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:[NSURL URLWithString:queryString]];
    [request setHTTPMethod:@"GET"];
    
    [self sendRequest:request withTag:DEVICE_PERMISSION_ACCESS_INFO];
}

-(void)grantUserAccessTimeWithParameters:(NSDictionary *)parameters {
    
    NSString *urlString = @"http://www.dylanboltz.com/haus/grantuseraccesstime.php";
    NSMutableURLRequest *request = [self getUrlRequestForHTTPMethod:@"POST" withParameters:parameters];
    [request setURL:[NSURL URLWithString:urlString]];
    
    [self sendRequest:request withTag:GRANT_USER_PERMISSION];
}

-(void)editUserAccessTimeWithParameters:(NSDictionary *)parameters {
    
    NSString *urlString = @"http://www.dylanboltz.com/haus/edituseraccesstime.php";
    NSMutableURLRequest *request = [self getUrlRequestForHTTPMethod:@"POST" withParameters:parameters];
    [request setURL:[NSURL URLWithString:urlString]];
    
    [self sendRequest:request withTag:EDIT_USER_ACCESS_TIME];

}
@end
