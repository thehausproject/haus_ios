//
//  HAUSNSURLConnection.h
//  HAUS
//
//  Created by Russell Stephens on 2/15/14.
//  Copyright (c) 2014 HAUS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HAUSNSURLConnection;

@protocol HAUSNSURLConnectionDelegate
- (void)connection:(HAUSNSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(HAUSNSURLConnection *)connection didReceiveData:(NSData *)data;
- (NSCachedURLResponse *)connection:(HAUSNSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse;
- (void)connectionDidFinishLoading:(HAUSNSURLConnection *)connection;
- (void)connection:(HAUSNSURLConnection *)connection didFailWithError:(NSError *)error;
@end

@interface HAUSNSURLConnection : NSURLConnection <NSURLConnectionDelegate>

@property (readwrite) int tag;
@property (weak,nonatomic) id <HAUSNSURLConnectionDelegate> delegate;

@end
