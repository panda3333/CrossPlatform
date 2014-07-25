//
//  EditViewController.m
//  cpmios
//
//  Created by Brandon Shega on 7/17/14.
//  Copyright (c) 2014 Brandon Shega. All rights reserved.
//

#import "EditViewController.h"
#import "Reachability.h"

@interface EditViewController ()

@end

@implementation EditViewController

@synthesize editObject, nameField, phoneField;

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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    nameField.text = editObject[@"name"];
    NSNumber *phoneNumber = editObject[@"phone"];
    NSString *phoneString = [phoneNumber stringValue];
    phoneField.text = phoneString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([nameField isFirstResponder] && [touch view] != nameField) {
        [nameField resignFirstResponder];
    } else if ([phoneField isFirstResponder] && [touch view] != phoneField) {
        [phoneField resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
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

- (IBAction)updateButton:(id)sender
{
    
    [nameField resignFirstResponder];
    [phoneField resignFirstResponder];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    
    //Validation
    if ([[nameField text]  isEqual: @""] || [[phoneField text]  isEqual: @""]) {
        
        [[[UIAlertView alloc] initWithTitle:@"Error!"
                                    message:@"Please complete all fields"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        
    } else if ([[phoneField text] length] > 10 || [[phoneField text] length] < 10) {
    
        [[[UIAlertView alloc] initWithTitle:@"Error!"
                                    message:@"Phone Number must be 10 digits."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        
    } else {
        
        if (networkStatus != NotReachable) {
            
            editObject[@"name"] = [nameField text];
            NSInteger phoneInt = [[phoneField text] integerValue];
            NSNumber *phoneNumber = [NSNumber numberWithInt:phoneInt];
            editObject[@"phone"] = phoneNumber;
            
            [editObject saveInBackground];
            [self.navigationController popViewControllerAnimated:true];
            
            [[[UIAlertView alloc] initWithTitle:@"Success!"
                                        message:@"Contact Updated Successfully."
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        } else {
            
            NSLog(@"%@", editObject[@"name"]);
            
            NSMutableArray *contactList = [[NSMutableArray alloc] init];
            
            NSUserDefaults *contacts = [NSUserDefaults standardUserDefaults];
            
            NSArray *archive = [contacts objectForKey:@"contacts"];
            
            for (NSData *archivedContact in archive) {
                
                PFObject *object = [NSKeyedUnarchiver unarchiveObjectWithData:archivedContact];
                
                [contactList addObject:object];
                
            }
            
            int index = 0;
            int arrayIndex = 0;
            
            for (PFObject *contact in contactList) {
                
                if ([contact[@"name"] isEqualToString:editObject[@"name"]]) {
                    
                    editObject[@"name"] = [nameField text];
                    NSInteger phoneInt = [[phoneField text] integerValue];
                    NSNumber *phoneNumber = [NSNumber numberWithInt:phoneInt];
                    editObject[@"phone"] = phoneNumber;
                    
                    arrayIndex = index;
                }
                
                index++;
                
            }
            
            [contactList replaceObjectAtIndex:arrayIndex withObject:editObject];
            
            NSMutableArray *archiveArray = [NSMutableArray arrayWithCapacity:contactList.count];
            
            for (PFObject *contact in contactList) {
                NSData *archivedContact = [NSKeyedArchiver archivedDataWithRootObject:contact];
                [archiveArray addObject:archivedContact];
            }
            
            NSLog(@"%@", editObject);
            
            PFObject *tempObject = [PFObject objectWithClassName:@"Contact"];
            tempObject.objectId = editObject.objectId;
            tempObject[@"name"] = editObject[@"name"];
            tempObject[@"phone"] = editObject[@"phone"];
            tempObject[@"user"] = editObject[@"user"];
            
            [tempObject saveEventually];
            
            [contacts setObject:archiveArray forKey:@"contacts"];
            [contacts synchronize];
            
            [self.navigationController popViewControllerAnimated:true];
            
            [[[UIAlertView alloc] initWithTitle:@"Pending"
                                        message:@"Connection not found, contact will be updated when connection is restored."
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            
        }
    }
}
@end
