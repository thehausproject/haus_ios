//
//  HAUSNSURLConnection.m
//  HAUS
//
//  Created by Russell Stephens on 2/15/14.
//  Copyright (c) 2014 Daniel Avram. All rights reserved.
//

#import "HAUSNSURLConnection.h"

@implementation HAUSNSURLConnection

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.delegate connection:(HAUSNSURLConnection*)connection didReceiveResponse:response];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.delegate connection:(HAUSNSURLConnection*)connection didReceiveData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    return [self.delegate connection:(HAUSNSURLConnection*)connection willCacheResponse:cachedResponse];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.delegate connectionDidFinishLoading:(HAUSNSURLConnection*)connection];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.delegate connection:(HAUSNSURLConnection*)connection didFailWithError:error];
}

@end
