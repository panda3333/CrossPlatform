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
                                    message:@"No Internet Connection.\nData will update when connection is restored."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        
        NSUserDefaults *contacts = [NSUserDefaults standardUserDefaults];
        NSArray *archive = [contacts objectForKey:@"contacts"];
        
        contactList = [[NSMutableArray alloc] init];
        
        for (NSData *archivedContact in archive) {
            PFObject *contact = [NSKeyedUnarchiver unarchiveObjectWithData:archivedContact];
            [contactList addObject:contact];
        }
        
        [myTableView reloadData];
        
        //[self.navigationController popToRootViewControllerAnimated:true];
        
    } else {
        
        NSTimer *queryTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(queryData) userInfo:nil repeats:TRUE];
    
        [self queryData];
        
    }
}

- (void)queryData
{
    //queries parse to see if there is an object for the current user, if there is, display the information for the labels.
    PFQuery *query = [PFQuery queryWithClassName:@"Contact"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:TRUE];
            objects = [objects sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
            
            contactList = [NSMutableArray arrayWithArray:objects];
            
            NSUserDefaults *contacts = [NSUserDefaults standardUserDefaults];
            
            NSMutableArray *archiveArray = [NSMutableArray arrayWithCapacity:contactList.count];
            
            for (PFObject *contact in contactList) {
                NSData *archivedContact = [NSKeyedArchiver archivedDataWithRootObject:contact];
                [archiveArray addObject:archivedContact];
            }
            
            [contacts setObject:archiveArray forKey:@"contacts"];
            [contacts synchronize];
            
            [myTableView reloadData];
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
    
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
        
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        
        //Remove object from Parse backend
        PFObject *object = [contactList objectAtIndex:indexPath.row];
        
        //remove object from array of queried objects
        [contactList removeObjectAtIndex:indexPath.row];
        
        if (networkStatus != NotReachable) {
            
            [object deleteInBackground];
            
        } else {
            
            [object deleteEventually];
            
        }
        
        NSUserDefaults *contacts = [NSUserDefaults standardUserDefaults];
        
        NSMutableArray *archiveArray = [NSMutableArray arrayWithCapacity:contactList.count];
        
        for (PFObject *contact in contactList) {
            NSData *archivedContact = [NSKeyedArchiver archivedDataWithRootObject:contact];
            [archiveArray addObject:archivedContact];
        }
        
        [contacts setObject:archiveArray forKey:@"contacts"];
        [contacts synchronize];
        
        
        
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
