//
//  DetailViewController.h
//  cpmios
//
//  Created by Brandon Shega on 7/17/14.
//  Copyright (c) 2014 Brandon Shega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface DetailViewController : UIViewController

@property (nonatomic, weak) PFObject *currentObject;
@property (weak, nonatomic) IBOutlet UILabel *nameText;
@property (weak, nonatomic) IBOutlet UILabel *numberText;



@end
