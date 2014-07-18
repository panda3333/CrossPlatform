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
    if (networkStatus == NotReachable) {
        [[[UIAlertView alloc] initWithTitle:@"Error!"
                                    message:@"No Internet Connection.\nPlease connect to the internet."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        
        [self.navigationController popToRootViewControllerAnimated:true];
    } else {
    
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
            
        }
    }
}
@end
