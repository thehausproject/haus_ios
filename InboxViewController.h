//
//  InboxViewController.h
//  Ribbit
//
//  Created by Daniel Avram on 10/14/13.
//  Copyright (c) 2013 Daniel Avram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface InboxViewController : UIViewController {
    
    AppDelegate *appDelegate;
}

@property (strong, nonatomic) IBOutlet UILabel *dateField;
@property (strong, nonatomic) IBOutlet UILabel *welcomeMessage;

@end
