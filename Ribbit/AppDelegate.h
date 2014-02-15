//
//  AppDelegate.h
//  Ribbit
//
//  Created by Daniel Avram on 10/14/13.
//  Copyright (c) 2013 Daniel Avram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HAUSWebServiceUserData.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) HAUSWebServiceUserData *hausUserData;

@end
