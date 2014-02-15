//
//  HAUSWebServiceClient.h
//  HAUS
//
//  Created by Russell Stephens on 2/15/14.
//  Copyright (c) 2014 HAUS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HAUSNSURLConnection.h"

typedef enum {
    SIGNIN_REQUEST,
    SIGNUP_REQUEST,
} kHAUSWebServiceRequestType;

@protocol HAUSWebServiceClientDelegate <NSObject>

- (void)hausWebServiceResponseForRequest:(kHAUSWebServiceRequestType)requestType withJSON:(NSDictionary*)json;

@end

@interface HAUSWebServiceClient : NSObject <HAUSNSURLConnectionDelegate> {
    NSMutableData *responseData;
}

@property (weak, nonatomic) id <HAUSWebServiceClientDelegate> delegate;

#pragma mark - Define Calls below

- (void) signInWithParameters:(NSDictionary *)parameters;
- (void) signUpWithParameters:(NSDictionary *)parameters;

@end
