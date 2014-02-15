//
//  CallbackHelperMethods.m
//  Sot_Template
//
//  Created by Russell Stephens on 1/24/14.
//  Copyright (c) 2014 Russell Stephens. All rights reserved.
//

#import "CallbackHelperMethods.h"

@implementation CallbackHelperMethods

+(NSInvocation*) makeInvocationWithSEL:(SEL)selector forSender:(id)sender{
    const Class callbackClass = ((const Class)sender);
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[callbackClass methodSignatureForSelector:selector]];
    [inv setSelector:selector];
    [inv setTarget:callbackClass];
    return inv;
}

@end
