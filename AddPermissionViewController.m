//
//  AddPermissionViewController.m
//  HAUS
//
//  Created by Russell Stephens on 2/16/14.
//  Copyright (c) 2014 HAUS. All rights reserved.
//

#import "AddPermissionViewController.h"
#import "DejalActivityView.h"
#import "AppDelegate.h"

@interface AddPermissionViewController ()

@end

@implementation AddPermissionViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self initCellInfo];
    
    if (!client) {
        client = [HAUSWebServiceClient new];
        client.delegate = self;
    }
}

- (void) initCellInfo {
    
    if (!cellInfo) {
        cellInfo = [NSMutableArray arrayWithCapacity:0];
    }
    
    /*
     username
     device_id
     permission_level
     expiration_date
     access_code
     */
    [cellInfo addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Username",          @"title", @"username",          @"parameter", @"", @"value", nil]];
    [cellInfo addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Permission Level",  @"title", @"permission_level",  @"parameter", @"", @"value", nil]];
    [cellInfo addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Expiration Date",   @"title", @"expiration_date",   @"parameter", @"", @"value", nil]];
    [cellInfo addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Access Code",       @"title", @"access_code",       @"parameter", @"", @"value", nil]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 

- (void) showActivityView {
    [DejalBezelActivityView activityViewForView:self.view withLabel:@""];
}

#pragma mark - Table View Methods

#define NUMBER_OF_ROWS 4
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return NUMBER_OF_ROWS;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inputCell" forIndexPath:indexPath];
    
    cell.tag = indexPath.row;
    [cell.cellTitle setText:[[cellInfo objectAtIndex:indexPath.row] valueForKey:@"title"]];
    cell.cellDelegate = self;
    return cell;
}

#pragma mark - Add Device Input Cell Delegate

-(void)cellInputText:(NSString *)text forRow:(NSInteger)row {
    
    NSMutableDictionary *cellData = (NSMutableDictionary *)[cellInfo objectAtIndex:row];
    [cellData setObject:text forKey:@"value"];
    
}
- (IBAction)grantPermission:(id)sender {
    
    [self.view endEditing:YES];
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    for (int index = 0; index < NUMBER_OF_ROWS; index++) {
        NSMutableDictionary *cellData = [cellInfo objectAtIndex:index];
        
        [parameters setObject:[cellData objectForKey:@"value"] forKey:[cellData objectForKey:@"parameter"]];
    }
    //set user token
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [parameters setObject:[appDelegate.hausUserData userToken] forKey:@"user_token"];
    [parameters setObject:self.deviceID forKey:@"device_id"];
    DLog(@"%@",parameters);
    [self showActivityView];
    popOnSuccess = false;
    [client grantUserPermissionWithParameters:parameters];
    
}


#pragma mark - Haus Web Service Delegate Methods

-(void)hausWebServiceResponseForRequest:(kHAUSWebServiceRequestType)requestType withJSON:(NSDictionary *)json {
    
    [DejalBezelActivityView removeView];
    
    NSString *title = @"";
    NSString *message = @"";
    
    if ([json valueForKey:@"error"]) {
        title = @"Error";
        message = [json valueForKey:@"error"];
        
    }else {
        title = @"Success";
        message = @"Permission Granted";
        popOnSuccess = true;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles: nil ];
    alert.delegate = self;
    [alert show];
}

#pragma mark - Alert View Delegate

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (popOnSuccess) {
        if (self.delegate) {
            [self.delegate refreshPemissions];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
