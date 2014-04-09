//
//  VideoFeedTableViewCell.h
//  HAUS
//
//  Created by Russell Stephens on 4/8/14.
//  Copyright (c) 2014 HAUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HAUSWebServiceClient.h"

@interface VideoFeedTableViewCell : UITableViewCell <HAUSWebServiceClientDelegate, UIWebViewDelegate> {
    
    HAUSWebServiceClient *client;
    NSString *cameraFeedURL;
}

@property (strong, nonatomic) NSString *deviceID;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
