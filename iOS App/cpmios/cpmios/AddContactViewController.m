//
//  AddContactViewController.m
//  cpmios
//
//  Created by Brandon Shega on 7/16/14.
//  Copyright (c) 2014 Brandon Shega. All rights reserved.
//

#import "AddContactViewController.h"

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
    
    PFObject *contact = [PFObject objectWithClassName:@"Contact"];
    
    contact[@"name"] = [nameText text];
    NSInteger phoneInt = [[phoneText text] integerValue];
    NSNumber *phoneNumber = [NSNumber numberWithInt:phoneInt];
    contact[@"phone"] = phoneNumber;
    contact[@"user"] = [PFUser currentUser];
    
    [contact saveInBackground];
    
    [self dismissViewControllerAnimated:true completion:nil];
    
    [[[UIAlertView alloc] initWithTitle:@"Success!"
                                message:@"Contact Added Successfully."
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
    
}
@end
