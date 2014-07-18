//
//  TableViewController.h
//  cpmios
//
//  Created by Brandon Shega on 7/16/14.
//  Copyright (c) 2014 Brandon Shega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface TableViewController : UITableViewController
{
    NSMutableArray *contactList;
}

@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end
