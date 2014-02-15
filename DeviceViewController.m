//
//  DeviceViewController.m
//  HAUS
//
//  Created by Russell Stephens on 2/15/14.
//  Copyright (c) 2014 HAUS. All rights reserved.
//

#import "DeviceViewController.h"
#import "DejalActivityView.h"
#import "AppDelegate.h"

@interface DeviceViewController ()

@end

@implementation DeviceViewController


- (void) showActivityView {
    [DejalBezelActivityView activityViewForView:self.view withLabel:@""];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (!client) {
        client = [HAUSWebServiceClient new];
        client.delegate = self;
    }
    if (!devices) {
        devices = [NSMutableArray new];
    }
    
    if (!appDelegate) {
        appDelegate = [[UIApplication sharedApplication] delegate];
    }
    updateDetailViewDevice = NO;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![appDelegate isLoggedIn]) {
        [self showLogin];
    }else {
        UIBarButtonItem *logOutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logOut)];
        self.navigationItem.leftBarButtonItem = logOutButton;
        
        [self getDeviceInfo];
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

#pragma mark - Tableview Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [devices count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSDictionary *deviceInfo = [devices objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [deviceInfo valueForKey:@"nickname"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Permission: %@",[deviceInfo valueForKey:@"permission"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}

#pragma mark - Prepare for segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        DeviceViewDetailViewController *detailVC = [segue destinationViewController];
        
        detailVC.device = [devices objectAtIndex:self.myTableView.indexPathForSelectedRow.row];
        self.detailView = detailVC;
        self.detailView.masterDelegate = self;
    }
}
#pragma mark - Web Service Helpers
- (void) getDeviceInfo {
    
    [self showActivityView];
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    //set user token
    [parameters setObject:[appDelegate.hausUserData userToken] forKey:@"user_token"];
    
    [client getDeviceInfoWithParameters:parameters];
}
#pragma mark - Haus Web Service Client Delegate
- (void)hausWebServiceResponseForRequest:(kHAUSWebServiceRequestType)requestType withJSON:(NSDictionary *)json {
  
    [DejalBezelActivityView removeView];
    DLog(@"%@",json);
    
    if ([json valueForKey:@"error"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[json valueForKey:@"error"] delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles: nil ];
        [alert show];
        
    }else {
        devices = [json valueForKey:@"devices"];
        
        if (updateDetailViewDevice) {
            updateDetailViewDevice = NO;
            self.detailView.device = [devices objectAtIndex:self.myTableView.indexPathForSelectedRow.row];
        }else {
            [self.myTableView reloadData];
        }
        
    }
    
    
}

#pragma mark - DeviceViewDetailViewController Delegate

-(void)fetchAndUpdateDetailViewDevice {
    
    updateDetailViewDevice = YES;
    [self getDeviceInfo];
}
@end
