//
//  EditAccessPermissionViewController.m
//  HAUS
//
//  Created by Russell Stephens on 2/16/14.
//  Copyright (c) 2014 HAUS. All rights reserved.
//

#import "EditAccessPermissionViewController.h"
#import "AppDelegate.h"
#import "DejalActivityView.h"

@interface EditAccessPermissionViewController ()

@end

@implementation EditAccessPermissionViewController

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
     user_token
     permission_id
     days
     starttime
     endtime
     */
    [cellInfo addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Days", @"title", @"days", @"parameter", @"", @"value", nil]];
    [cellInfo addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Start Time", @"title", @"starttime", @"parameter", @"", @"value", nil]];
    [cellInfo addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"End Time", @"title", @"endtime", @"parameter", @"", @"value", nil]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

#define NUMBER_OF_ROWS 3
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return NUMBER_OF_ROWS;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inputCell" forIndexPath:indexPath];
    
    cell.tag = indexPath.row;
    [cell.cellTitle setText:[[cellInfo objectAtIndex:indexPath.row] valueForKey:@"title"]];
    cell.cellDelegate = self;
    
    return cell;
}

#pragma mark - Input Cell Delegate
-(void)cellInputText:(NSString *)text forRow:(NSInteger)row {
    
    NSMutableDictionary *cellData = (NSMutableDictionary *)[cellInfo objectAtIndex:row];
    [cellData setObject:text forKey:@"value"];
    
}

#pragma mark - HAUS Web Service Delegate Helper

- (IBAction)savePermission:(id)sender {
    
    [self.view endEditing:YES];
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    for (int index = 0; index < NUMBER_OF_ROWS; index++) {
        NSMutableDictionary *cellData = [cellInfo objectAtIndex:index];
        
        [parameters setObject:[cellData objectForKey:@"value"] forKey:[cellData objectForKey:@"parameter"]];
    }
    //set user token
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [parameters setObject:[appDelegate.hausUserData userToken] forKey:@"user_token"];
    [parameters setObject:self.permissionID forKey:@"permission_id"];
    DLog(@"%@",parameters);
    [self showActivityView];
    
    [client grantUserAccessTimeWithParameters:parameters];
}

- (void) showActivityView {
    [DejalBezelActivityView activityViewForView:self.view withLabel:@""];
}

- (void) hideActivityView {
    [DejalBezelActivityView removeView];
}
#pragma mark - HAUS Web Service Delegate
-(void)hausWebServiceResponseForRequest:(kHAUSWebServiceRequestType)requestType withJSON:(NSDictionary *)json {
    
    DLog(@"%@",json);
    [DejalBezelActivityView removeView];
    
    NSString *title = @"";
    NSString *message = @"";
    
    if ([json valueForKey:@"error"]) {
        title = @"Error";
        message = [json valueForKey:@"error"];
        
    }else {
        title = @"Success";
        message = @"Access Time Updated";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles: nil ];
    alert.delegate = self;
    [alert show];
}
@end
