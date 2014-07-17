//
//  MainViewController.m
//  cpmios
//
//  Created by Brandon Shega on 7/9/14.
//  Copyright (c) 2014 Brandon Shega. All rights reserved.
//  Cross-Platform Mobile Development 1407
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize nameText,nameField,ageText,ageField;

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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    //queries parse to see if there is an object for the current user, if there is, display the information for the labels.
    PFQuery *query = [PFQuery queryWithClassName:@"Object"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            for (PFObject *currentObject in objects) {
                
                userObject = currentObject;
                //NSLog(@"%@", currentObject);
                
            }
            
            if (userObject != NULL) {
                
                nameText.text = [userObject objectForKey:@"name"];
                NSNumber *ageNumber = [userObject objectForKey:@"age"];
                ageText.text = [ageNumber stringValue];
                
            } else {
                
                nameText.text = @"Please type your Name";
                ageText.text = @"Please type your Age";
                
            }
            
            
            
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
    
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

//Button to save the current information to a parse object
- (IBAction)saveButton:(id)sender
{
    
    NSString *nameString = [nameField text];
    NSString *ageString = [ageField text];
    NSInteger ageValue = [ageString integerValue];
    NSNumber *age = [NSNumber numberWithInt:ageValue];
    
    //query on viewdidappear looks for object for current user, if found, update that object
    NSLog(@"%@", userObject);
    if (userObject != NULL) {
        
        userObject[@"name"] = nameString;
        userObject[@"age"] = age;
        [userObject saveInBackground];
        
        //hide keyboard when save button is pressed.
        [ageField resignFirstResponder];
        [nameField resignFirstResponder];
        
        //refresh the screen
        [self viewDidAppear:true];
        
    //else create a new object for the current user.
    } else {
        
        PFObject *object = [PFObject objectWithClassName:@"Object"];
        
        object[@"name"] = nameString;
        object[@"age"] = age;
        [object setObject:[PFUser currentUser] forKey:@"user"];
        
        [object saveInBackground];
        
        //hide keyboard when save button is pressed
        [ageField resignFirstResponder];
        [nameField resignFirstResponder];
        
        //refresh the screen
        [self viewDidAppear:true];
        
    }
    
}

//Button to log the user out.
- (IBAction)logoutButton:(id)sender
{
    
    [PFUser logOut];
    [self.navigationController popViewControllerAnimated:true];
    
}
@end
