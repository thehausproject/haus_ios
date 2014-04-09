//
//  VideoFeedTableViewCell.m
//  HAUS
//
//  Created by Russell Stephens on 4/8/14.
//  Copyright (c) 2014 HAUS. All rights reserved.
//

#import "VideoFeedTableViewCell.h"
#import "DejalActivityView.h"
#import "AppDelegate.h"

@implementation VideoFeedTableViewCell

-(void)setDeviceID:(NSString *)newDeviceID {
    
    if (newDeviceID != _deviceID) {
        _deviceID = newDeviceID;
        [self fetchVideoDeviceInfo];
    }
}

- (void) fetchVideoDeviceInfo {
    
    self.webView.delegate = self;
    
    if (!client) {
        client = [HAUSWebServiceClient new];
        client.delegate = self;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    //set user token
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [parameters setObject:[appDelegate.hausUserData userToken] forKey:@"user_token"];
    [parameters setObject:self.deviceID forKey:@"device_id"];
    
    [self showActivityView];
    [client createGETRequestWithURL:CREATE_URL_STRING(@"getvideodeviceinfo") withParameters:parameters withTag:GET_VIDEO_DEVICE_INFO];
    
}

#pragma mark - Web Service Helpers

- (void) showActivityView {
    [DejalBezelActivityView activityViewForView:self.webView withLabel:@""];
}

- (void) hideActivityView {
    [DejalBezelActivityView removeView];
}

#pragma mark - Haus Web Service Delegate

-(void)hausWebServiceResponseForRequest:(kHAUSWebServiceRequestType)requestType withJSON:(NSDictionary *)json {
    DLog(@"%@",json);
    
    if ([json valueForKey:@"error"]) {
        [self hideActivityView];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[json valueForKey:@"error"] delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles: nil ];
        [alert show];
        
    }else {
        
        cameraFeedURL = [NSString stringWithFormat:@"http://%@:%@@%@:%@/image.jpg", [json objectForKey:@"username"], [json objectForKey:@"password"], [json objectForKey:@"ip_address"], [json objectForKey:@"port"]];
        DLog(@"%@", cameraFeedURL);
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:cameraFeedURL]]];
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(updateWeb) userInfo:nil repeats:YES];
    }
    
    
}

#pragma mark - Web View Helper

-(void)updateWeb
{
    [self.webView reload];
}

#pragma mark - Web View Delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideActivityView];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Could not load %@", cameraFeedURL] delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles: nil ];
    [alert show];
    [self hideActivityView];
}
@end
