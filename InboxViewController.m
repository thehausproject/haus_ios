//
//  InboxViewController.m
//  Ribbit
//
//  Created by Daniel Avram on 10/14/13.
//  Copyright (c) 2013 Daniel Avram. All rights reserved.
//

#import "InboxViewController.h"
#import "AppDelegate.h"

@interface InboxViewController ()

@end

@implementation InboxViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (!appDelegate) {
        appDelegate = [[UIApplication sharedApplication] delegate];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![appDelegate isLoggedIn]) {
        [self showLogin];
    }else {
        UIBarButtonItem *logOutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logOut)];
        self.navigationItem.leftBarButtonItem = logOutButton;
    }
    
}

- (void) logOut {
    
    [appDelegate.hausUserData setUserToken:@""];
    self.navigationItem.leftBarButtonItem = nil;
    [self showLogin];
}

- (void) showLogin {
    [self performSegueWithIdentifier:@"showLogin" sender:self];
}
@end
