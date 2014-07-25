//
//  AddContactViewController.m
//  cpmios
//
//  Created by Brandon Shega on 7/16/14.
//  Copyright (c) 2014 Brandon Shega. All rights reserved.
//

#import "AddContactViewController.h"
#import "Reachability.h"

@interface AddContactViewController ()

@end

@implementation AddContactViewController

@synthesize nameText, phoneText;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([nameText isFirstResponder] && [touch view] != nameText) {
        [nameText resignFirstResponder];
    } else if ([phoneText isFirstResponder] && [touch view] != phoneText) {
        [phoneText resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)addContactButton:(id)sender
{
    
    [nameText resignFirstResponder];
    [phoneText resignFirstResponder];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
        
    //Validation
    if ([[nameText text]  isEqual: @""] || [[phoneText text]  isEqual: @""]) {
        
        [[[UIAlertView alloc] initWithTitle:@"Error!"
                                    message:@"Please complete all fields"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        
    } else if ([[phoneText text] length] > 10 || [[phoneText text] length] < 10) {
        
        [[[UIAlertView alloc] initWithTitle:@"Error!"
                                    message:@"Phone Number must be 10 digits."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    } else {
        
        PFObject *contact = [PFObject objectWithClassName:@"Contact"];
        
        contact[@"name"] = [nameText text];
        NSInteger phoneInt = [[phoneText text] integerValue];
        NSNumber *phoneNumber = [NSNumber numberWithInt:phoneInt];
        contact[@"phone"] = phoneNumber;
        contact[@"user"] = [PFUser currentUser];
        
        if (networkStatus == ReachableViaWiFi || networkStatus == ReachableViaWWAN) {
            
            [contact saveInBackground];
            
            [self dismissViewControllerAnimated:true completion:nil];
            
            [[[UIAlertView alloc] initWithTitle:@"Success!"
                                        message:@"Contact Added Successfully."
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            
        } else {
            
            [contact saveEventually];
            
            NSMutableArray *contactList = [[NSMutableArray alloc] init];
            
            NSUserDefaults *contacts = [NSUserDefaults standardUserDefaults];
            
            NSArray *archive = [contacts objectForKey:@"contacts"];
            
            for (NSData *archivedContact in archive) {
                PFObject *object = [NSKeyedUnarchiver unarchiveObjectWithData:archivedContact];
                [contactList addObject:object];
            }
            
            [contactList addObject:contact];
            
            NSMutableArray *archiveArray = [NSMutableArray arrayWithCapacity:contactList.count];
            
            for (PFObject *contact in contactList) {
                NSData *archivedContact = [NSKeyedArchiver archivedDataWithRootObject:contact];
                [archiveArray addObject:archivedContact];
            }
            
            [contacts setObject:archiveArray forKey:@"contacts"];
            [contacts synchronize];
            
            [self dismissViewControllerAnimated:true completion:nil];
            
            [[[UIAlertView alloc] initWithTitle:@"Pending"
                                        message:@"Connection not found, contact will be added when connection is restored."
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            
        }
            
    }
    
}

- (IBAction)cancelButton:(id)sender
{
    
    [self dismissViewControllerAnimated:true completion:nil];
    
}
@end
