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
#import "AdminPermissionsViewController.h"

@interface DeviceViewDetailViewController ()

@end

@implementation DeviceViewDetailViewController

#pragma mark - Detail Item

-(void)setDevice:(NSDictionary *)device {
    
    if (_device != device) {
        _device = device;
        [self configureCells];
        [self.tableView reloadData];
        [self checkStateForUnlocked];
        [self adminSetup];
    }
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (expiredAlertView) {
        [expiredAlertView show];
    }
}

#pragma mark - Admin Setup

- (void) adminSetup {
    
    if ([[self.device objectForKey:@"permission"] isEqualToString:@"A"]) {
        
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit Permissions" style:UIBarButtonItemStyleBordered target:self action:@selector(showPermissions)];
        self.navigationItem.rightBarButtonItem = rightBarButton;
    }else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void) showPermissions {
    
    [self performSegueWithIdentifier:@"showPermissions" sender:self];
}

#pragma mark - Prepare for segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showPermissions"]) {
        AdminPermissionsViewController *destinationVC = (AdminPermissionsViewController *)[[[segue destinationViewController] viewControllers] objectAtIndex:0];
        destinationVC.deviceID = [self.device objectForKey:@"id"];
    }
}
#pragma mark - Cell Setup
- (void) configureCells {
    cellObjects = nil;
    cellObjects = [NSMutableArray new];
    sectionHeaders = [NSMutableArray new];
    rowsInSection = [NSMutableArray new];
    sections = 0;
    
    if ([[self.device objectForKey:@"permission"] isEqualToString:@"A"] || [[self.device objectForKey:@"permission"] isEqualToString:@"W"]) {
        DeviceStateCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"deviceStateCell"];
        
        NSString *deviceState = [self.device objectForKey:@"state"];
        cell.deviceState.text = deviceState;
        cell.deviceStateImage.image = [UIImage imageNamed:[deviceStateImages objectForKey:deviceState]];
        [sectionHeaders addObject:@"Actions"];
        
        sections++;
        [cellObjects addObject:cell];
        [rowsInSection addObject:[NSNumber numberWithInt:1]];
        
        [cellObjects addObject:[self dequeueReusableRightDetailCellWithText:@"Type" withDetailKey:@"type"]];
        [cellObjects addObject:[self dequeueReusableRightDetailCellWithText:@"Status" withDetailKey:@"status"]];
        [cellObjects addObject:[self dequeueReusableRightDetailCellWithText:@"Nickname" withDetailKey:@"nickname"]];
        [cellObjects addObject:[self dequeueReusableRightDetailCellWithText:@"Permission" withDetailKey:@"permission"]];
        [cellObjects addObject:[self dequeueReusableRightDetailCellWithText:@"Access Code" withDetailKey:@"access_code"]];
        [cellObjects addObject:[self dequeueReusableRightDetailCellWithText:@"Owner" withDetailKey:@"owner"]];
        
        sections++;
        [sectionHeaders addObject:@"Info"];
        [rowsInSection addObject:[NSNumber numberWithInt:6]];
        
    }else if ([[self.device objectForKey:@"permission"] isEqualToString:@"E"]) {
        
        sections++;
        [sectionHeaders addObject:@"Expired"];
        [rowsInSection addObject:[NSNumber numberWithInt:2]];
        [cellObjects addObject:[self dequeueReusableRightDetailCellWithText:@"Permission" withDetailKey:@"permission"]];
        [cellObjects addObject:[self dequeueReusableRightDetailCellWithText:@"Owner" withDetailKey:@"owner"]];
        
        expiredAlertView = [[UIAlertView alloc] initWithTitle:@"Expired Permission" message:@"Contact the device owner, to update your permission" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    
    
    
    
}

- (UITableViewCell *) dequeueReusableRightDetailCellWithText:(NSString *)text withDetailKey:(NSString *)detailKey {
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"displayInfo"];
    cell.textLabel.text = text;
    cell.detailTextLabel.text = [self.device valueForKey:detailKey];
    
    return cell;
    
}

#pragma mark - SDS Specific Stuff

- (void) checkStateForUnlocked {
    //after 5 seconds relock the state
    //its actually relocked immediately, but the arduino has a 5 second delay
    // we will mock that here
    if ([[self.device objectForKey:@"state"] isEqualToString:@"UNLOCKED"]) {
        [self performSelector:@selector(relockDevice) withObject:nil afterDelay:5];
    }
}

- (void) relockDevice {
    
    NSMutableDictionary *editDevice = [NSMutableDictionary dictionaryWithDictionary:self.device];
    [editDevice setValue:@"LOCKED" forKey:@"state"];
    self.device = editDevice;
    [self.tableView reloadData];
    
}
#pragma mark - Web Service Helpers

- (void) showActivityView {
    [DejalBezelActivityView activityViewForView:self.view withLabel:@""];
}

- (void) hideActivityView {
    [DejalBezelActivityView removeView];
}
#pragma mark - Table View Delegate Methods

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [sectionHeaders objectAtIndex:section];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sections;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[rowsInSection objectAtIndex:section] integerValue];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    long cellObjectIndex = indexPath.row + indexPath.section;
    return [cellObjects objectAtIndex:cellObjectIndex];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([[cell class] isSubclassOfClass:[DeviceStateCell class]]) {
        [self showActivityView];
        
        NSMutableDictionary *parameters = [NSMutableDictionary new];
        //set user token
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [parameters setObject:[appDelegate.hausUserData userToken] forKey:@"user_token"];
        [parameters setObject:[self.device objectForKey:@"id"] forKey:@"device_id"];
        [parameters setObject:[deviceStateOpposites objectForKey:[self.device objectForKey:@"state"]] forKey:@"state"];
        
        [client postDeviceStateWithParameters:parameters];
    }
    
    
}

#pragma mark - Haus Web Service Delegate

-(void)hausWebServiceResponseForRequest:(kHAUSWebServiceRequestType)requestType withJSON:(NSDictionary *)json {
    
    if ([json valueForKey:@"error"]) {
        [self hideActivityView];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[json valueForKey:@"error"] delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles: nil ];
        [alert show];
        
    }else {
        
        if (self.masterDelegate) {
            [self.masterDelegate fetchAndUpdateDetailViewDevice];
        }
    }
    
    
}
@end
