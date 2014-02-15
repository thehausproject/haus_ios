//
//  CallbackHelperMethods.h
//  Sot_Template
//
//  Created by Russell Stephens on 1/24/14.
//  Copyright (c) 2014 Russell Stephens. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CallbackHelperMethods : NSObject

+(NSInvocation*) makeInvocationWithSEL:(SEL)selector forSender:(id)sender;
@end
