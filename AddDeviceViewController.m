//
//  AddDeviceViewController.m
//  HAUS
//
//  Created by Russell Stephens on 2/15/14.
//  Copyright (c) 2014 HAUS. All rights reserved.
//

#import "AddDeviceViewController.h"
#import "AddDeviceInputCell.h"

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
}

- (void) initCellInfo {
    
    if (!cellInfo) {
        cellInfo = [NSMutableArray arrayWithCapacity:0];
    }
    
    ;
    [cellInfo addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Passcode", @"title", @"passcode", @"parameter", @"", @"value", nil]];
    [cellInfo addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Nickname", @"title", @"nickname", @"parameter", @"", @"value", nil]];
}


#pragma mark - Table View Methods

#define NUMBER_OF_ROWS 2
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return NUMBER_OF_ROWS;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddDeviceInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inputCell" forIndexPath:indexPath];
    
    cell.tag = indexPath.row;
    [cell.cellTitle setText:[[cellInfo objectAtIndex:indexPath.row] valueForKey:@"title"]];
    cell.cellDelegate = self;
    return cell;
}

#pragma mark - Add Device Input Cell Delegate

-(void)cellInputText:(NSString *)text forRow:(int)row {
    
    NSMutableDictionary *cellData = (NSMutableDictionary *)[cellInfo objectAtIndex:row];
    [cellData setObject:text forKey:@"value"];
    
}
- (IBAction)claimDevice:(id)sender {
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    for (int index = 0; index < NUMBER_OF_ROWS; index++) {
        NSMutableDictionary *cellData = [cellInfo objectAtIndex:index];
        
        [parameters setObject:[cellData objectForKey:@"value"] forKey:[cellData objectForKey:@"parameter"]];
    }
    
    DLog(@"Printing parameters: %@", parameters);
}
@end
