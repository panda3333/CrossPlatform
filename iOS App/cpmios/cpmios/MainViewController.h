//
//  MainViewController.h
//  cpmios
//
//  Created by Brandon Shega on 7/9/14.
//  Copyright (c) 2014 Brandon Shega. All rights reserved.
//  Cross-Platform Mobile Development 1407
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MainViewController : UIViewController
{
    PFObject *userObject;
}

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *ageField;
@property (weak, nonatomic) IBOutlet UILabel *nameText;
@property (weak, nonatomic) IBOutlet UILabel *ageText;

- (IBAction)saveButton:(id)sender;
- (IBAction)logoutButton:(id)sender;


@end
