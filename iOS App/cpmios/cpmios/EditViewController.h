//
//  EditViewController.h
//  cpmios
//
//  Created by Brandon Shega on 7/17/14.
//  Copyright (c) 2014 Brandon Shega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EditViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;

- (IBAction)updateButton:(id)sender;

@property (weak, nonatomic) PFObject *editObject;

@end
