//
//  DeviceViewDetailViewController.m
//  HAUS
//
//  Created by Russell Stephens on 2/15/14.
//  Copyright (c) 2014 HAUS. All rights reserved.
//

#import "DeviceViewDetailViewController.h"
#import "DejalActivityView.h"
#import "AppDelegate.h"

@interface DeviceViewDetailViewController ()

@end

@implementation DeviceViewDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (!deviceStateImages) {
        deviceStateImages = [NSDictionary dictionaryWithObjectsAndKeys:@"unlock.png", @"UNLOCKED", @"locked.png", @"LOCKED", nil];
    }
    
    if (!deviceStateOpposites) {
        deviceStateOpposites = [NSDictionary dictionaryWithObjectsAndKeys:@"UNLOCKED", @"LOCKED", @"LOCKED", @"UNLOCKED", nil];
    }
    if (!client) {
        client = [HAUSWebServiceClient new];
        client.delegate = self;
    }
}

#pragma mark - Web Service Helpers

- (void) showActivityView {
    [DejalBezelActivityView activityViewForView:self.view withLabel:@""];
}

- (void) hideActivityView {
    [DejalBezelActivityView removeView];
}
#pragma mark - Table View Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DeviceStateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"deviceStateCell"];
    
    NSString *deviceState = [self.device objectForKey:@"state"];
    cell.deviceState.text = deviceState;
    cell.deviceStateImage.image = [UIImage imageNamed:[deviceStateImages objectForKey:deviceState]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self showActivityView];
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    //set user token
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [parameters setObject:[appDelegate.hausUserData userToken] forKey:@"user_token"];
    [parameters setObject:[self.device objectForKey:@"id"] forKey:@"device_id"];
    [parameters setObject:[deviceStateOpposites objectForKey:[self.device objectForKey:@"state"]] forKey:@"state"];
    
    [client postDeviceStateWithParameters:parameters];
    
}

#pragma mark - Haus Web Service Delegate

-(void)hausWebServiceResponseForRequest:(kHAUSWebServiceRequestType)requestType withJSON:(NSDictionary *)json {
    
    if ([json valueForKey:@"error"]) {
        [self hideActivityView];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[json valueForKey:@"error"] delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles: nil ];
        [alert show];
        
    }else {
        
        DLog(@"%@",json);
    }
    
    
}
@end
