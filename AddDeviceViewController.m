//
//  AddDeviceViewController.m
//  HAUS
//
//  Created by Russell Stephens on 2/15/14.
//  Copyright (c) 2014 HAUS. All rights reserved.
//

#import "AddDeviceViewController.h"
#import "InputCell.h"
#import "AppDelegate.h"
#import "DejalActivityView.h"

@interface AddDeviceViewController ()

@end

@implementation AddDeviceViewController

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
    
    ;
    [cellInfo addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Passcode", @"title", @"passcode", @"parameter", @"", @"value", nil]];
    [cellInfo addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Nickname", @"title", @"nickname", @"parameter", @"", @"value", nil]];
}

- (void) showActivityView {
    [DejalBezelActivityView activityViewForView:self.view withLabel:@""];
}

#pragma mark - Table View Methods

#define NUMBER_OF_ROWS 2
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
- (IBAction)claimDevice:(id)sender {
    
    [self.view endEditing:YES];
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    for (int index = 0; index < NUMBER_OF_ROWS; index++) {
        NSMutableDictionary *cellData = [cellInfo objectAtIndex:index];
        
        [parameters setObject:[cellData objectForKey:@"value"] forKey:[cellData objectForKey:@"parameter"]];
    }
    //set user token
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [parameters setObject:[appDelegate.hausUserData userToken] forKey:@"user_token"];
    
    DLog(@"%@",parameters);
    [self showActivityView];
    popOnSuccess = false;
    [client claimDeviceWithParameters:parameters];
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
        message = @"You have claimed this device";
        popOnSuccess = true;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles: nil ];
    alert.delegate = self;
    [alert show];
}

#pragma mark - Alert View Delegate

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (popOnSuccess) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
