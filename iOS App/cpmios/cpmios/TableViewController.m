//
//  TableViewController.m
//  cpmios
//
//  Created by Brandon Shega on 7/16/14.
//  Copyright (c) 2014 Brandon Shega. All rights reserved.
//

#import "TableViewController.h"
#import "CustomCell.h"
#import "DetailViewController.h"
#import "Reachability.h"

@interface TableViewController ()

@end

@implementation TableViewController

@synthesize myTableView;

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
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        
        [[[UIAlertView alloc] initWithTitle:@"Error!"
                                    message:@"No Internet Connection.\nPlease connect to the internet."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        
        [self.navigationController popToRootViewControllerAnimated:true];
        
    } else {
     
        //queries parse to see if there is an object for the current user, if there is, display the information for the labels.
        PFQuery *query = [PFQuery queryWithClassName:@"Contact"];
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                contactList = [NSMutableArray arrayWithArray:objects];
                [self.tableView reloadData];
            } else {
                NSLog(@"Error: %@", error);
            }
        }];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if ([contactList count] == 0) {
        return 1;
    } else {
        return [contactList count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell != NULL) {
        
        if ([contactList count] == 0) {
            
            cell.nameLabel.text = @"No Contacts!";
            cell.phoneLabel.text = @"Click the + to add one.";
            
        } else {
         
            cell.nameLabel.text = [[contactList objectAtIndex:indexPath.row] objectForKey:@"name"];
            NSNumber *phoneNumber = [[contactList objectAtIndex:indexPath.row] objectForKey:@"phone"];
            cell.phoneLabel.text = [phoneNumber stringValue];
            
        }
        
    }
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //Remove object from Parse backend
        PFObject *object = [contactList objectAtIndex:indexPath.row];
        [object deleteInBackground];
        //remove object from array of queried objects
        [contactList removeObjectAtIndex:indexPath.row];
        
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"detailSegue"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetailViewController *dvc = segue.destinationViewController;
        dvc.currentObject = [contactList objectAtIndex:indexPath.row];
        
    }
    
    
}


@end
