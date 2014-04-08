//
//  AccessPermissionViewController.m
//  HAUS
//
//  Created by Russell Stephens on 2/16/14.
//  Copyright (c) 2014 HAUS. All rights reserved.
//

#import "AccessPermissionViewController.h"
#import "DejalActivityView.h"
#import "AppDelegate.h"
#import "EditAccessPermissionViewController.h"

@interface AccessPermissionViewController ()

@end

@implementation AccessPermissionViewController

#pragma mark - detail item
-(void)setPermissionID:(NSString *)permissionID {
    if (_permissionID != permissionID) {
        
        _permissionID = permissionID;
        [self getAccessPermissions];
    }
}

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if (!client) {
        client = [HAUSWebServiceClient new];
        client.delegate = self;
    }
    [self initCellsWithJSON:nil];
}

#pragma mark - Cell Setup
- (void) initCellsWithJSON:(NSDictionary *)json
{
    
//    [cellObjects removeAllObjects];
    
//    if (!cellObjects) {
    cellObjects = nil;
    cellObjects = [NSMutableArray new];
//    }
    
//    if (!rowsInSection) {
    rowsInSection = nil;
    rowsInSection = [NSMutableArray new];
//    }
    if (!json) {
        sections = 0;
        [rowsInSection addObject:[NSNumber numberWithInt:0]];
        
        return;
    }
    
    //check first for full access
    if ([json valueForKey:@"all_access"]) {
        
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"detailCell"];
        sections = 1;
        [rowsInSection addObject:[NSNumber numberWithInt:1]];
        
        cell.textLabel.text = @"Access Level";
        cell.detailTextLabel.text = @"All Access";
        
        [cellObjects addObject:cell];
    }
    
   
}

#pragma mark - Prepare For Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"editAccessPermission"]) {
        EditAccessPermissionViewController *vc = [segue destinationViewController];
        vc.permissionID = self.permissionID;
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([rowsInSection count] < 1) {
        return 0;
    }
    return [[rowsInSection objectAtIndex:section] integerValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [cellObjects objectAtIndex:indexPath.row];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */


#pragma mark - HAUS Web Service Helper
- (void) getAccessPermissions {
    
    [self showActivityView];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setObject:self.permissionID forKey:@"permission_id"];
    [parameters setObject:[appDelegate.hausUserData userToken] forKey:@"user_token"];
    
    [client createGETRequestWithURL:CREATE_URL_STRING(@"getdevicepermissionaccessinfo") withParameters:parameters withTag:DEVICE_PERMISSION_ACCESS_INFO];
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
    [self hideActivityView];
    
    if ([json valueForKey:@"error"]) {
        [self hideActivityView];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[json valueForKey:@"error"] delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles: nil ];
        [alert show];
        
    }else {
        [self initCellsWithJSON:json];
        [self.tableView reloadData];
    }
}
@end
