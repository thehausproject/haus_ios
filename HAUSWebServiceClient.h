//
//  HAUSWebServiceClient.h
//  HAUS
//
//  Created by Russell Stephens on 2/15/14.
//  Copyright (c) 2014 HAUS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HAUSNSURLConnection.h"

#define CREATE_URL_STRING(s) [NSString stringWithFormat:@"http://www.dylanboltz.com/haus/%@.php", s]

typedef enum {
    SIGNIN_REQUEST,
    SIGNUP_REQUEST,
    CLAIM_DEVICE,
    GET_DEVICE_INFO,
    POST_DEVICE_STATE,
    GET_DEVICE_USER_INFO,
    GRANT_USER_PERMISSION,
    DEVICE_PERMISSION_ACCESS_INFO,
    GRANT_USER_ACCESS_TIME,
    EDIT_USER_ACCESS_TIME,
    CREATE_VIDEO_DEVICE,
    GET_VIDEO_DEVICE_INFO,
} kHAUSWebServiceRequestType;

@protocol HAUSWebServiceClientDelegate <NSObject>

- (void)hausWebServiceResponseForRequest:(kHAUSWebServiceRequestType)requestType withJSON:(NSDictionary*)json;

@end

@interface HAUSWebServiceClient : NSObject <HAUSNSURLConnectionDelegate> {
    NSMutableData *responseData;
}

@property (weak, nonatomic) id <HAUSWebServiceClientDelegate> delegate;

- (void) createPOSTRequestWithURL:(NSString*) urlString withParameters:(NSDictionary *)parameters withTag:(kHAUSWebServiceRequestType)requestType;
- (void) createGETRequestWithURL:(NSString*) urlString withParameters:(NSDictionary *)parameters withTag:(kHAUSWebServiceRequestType)requestType;

@end
