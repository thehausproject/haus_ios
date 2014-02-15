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
    CLAIM_DEVICE,
    GET_DEVICE_INFO,
    POST_DEVICE_STATE,
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
- (void) claimDeviceWithParameters:(NSDictionary *)parameters;
- (void) getDeviceInfoWithParameters:(NSDictionary *)parameters;
- (void) postDeviceStateWithParameters:(NSDictionary *)parameters;
@end
