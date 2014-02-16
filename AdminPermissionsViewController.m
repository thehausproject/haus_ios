//
//  AdminPermissionsViewController.m
//  HAUS
//
//  Created by Russell Stephens on 2/15/14.
//  Copyright (c) 2014 HAUS. All rights reserved.
//

#import "AdminPermissionsViewController.h"
#import "DejalActivityView.h"
#import "AppDelegate.h"
#import "AddPermissionViewController.h"

@interface AdminPermissionsViewController ()

@end

@implementation AdminPermissionsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - device id
-(void)setDeviceID:(NSString *)deviceID {
    
    if (_deviceID != deviceID) {
        _deviceID = deviceID;
        [self getUserDeviceInfo];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(dismissView)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if (!client) {
        client = [HAUSWebServiceClient new];
        client.delegate = self;
    }
    
    if (!rowKeys) {
        rowKeys = [NSArray arrayWithObjects:@"access_expiration_date", @"access_granted_by", @"date_authorized", @"permission", @"user", nil];
    }

}

- (void) dismissView {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Prepare For Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"addPermission"]) {
        AddPermissionViewController *vc = [segue destinationViewController];
        vc.deviceID = self.deviceID;
    }
}
#pragma mark - Table view data source

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Permission %li",section+1];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [permissions count];
}

#define ROWS_PER_SECTION 5
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return ROWS_PER_SECTION;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"detailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *rowKey = [rowKeys objectAtIndex:indexPath.row];
    cell.textLabel.text = rowKey;
    
    NSString *value = ([[permissions objectAtIndex:indexPath.section] valueForKey:rowKey] == [NSNull null])? @"0000-00-00":[[permissions objectAtIndex:indexPath.section] valueForKey:rowKey];
    cell.detailTextLabel.text = value;
    
    return cell;
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

#pragma mark - Haus Web Service Delegate Helpers

- (void) showActivityView {
    [DejalBezelActivityView activityViewForView:self.view withLabel:@""];
}

- (void) hideActivityView {
    [DejalBezelActivityView removeView];
}

- (void) getUserDeviceInfo {
    
    [self showActivityView];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setObject:self.deviceID forKey:@"device_id"];
    [parameters setObject:[appDelegate.hausUserData userToken] forKey:@"user_token"];
    
    [client getDeviceUserInfoWithParameters:parameters];
    
    
}
#pragma mark - Haus Web Service Delegate Methods

-(void)hausWebServiceResponseForRequest:(kHAUSWebServiceRequestType)requestType withJSON:(NSDictionary *)json {
    DLog(@"%@",json);
    [self hideActivityView];
    
    if ([json valueForKey:@"error"]) {
        [self hideActivityView];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[json valueForKey:@"error"] delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles: nil ];
        [alert show];
        
    }else {
        
        permissions = [json valueForKey:@"permissions"];
        [self.tableView reloadData];
    }
}

- (IBAction)addNewPermission:(id)sender {
}
@end
