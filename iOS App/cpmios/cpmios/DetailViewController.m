//
//  DetailViewController.m
//  cpmios
//
//  Created by Brandon Shega on 7/17/14.
//  Copyright (c) 2014 Brandon Shega. All rights reserved.
//

#import "DetailViewController.h"
#import "EditViewController.h"
#import "Reachability.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize currentObject, nameText, numberText;

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
    
//    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
//    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
//    if (networkStatus == NotReachable) {
//        [[[UIAlertView alloc] initWithTitle:@"Error!"
//                                    message:@"No Internet Connection.\nPlease connect to the internet."
//                                   delegate:nil
//                          cancelButtonTitle:@"OK"
//                          otherButtonTitles:nil] show];
//        
//        [self.navigationController popToRootViewControllerAnimated:true];
//    } else {
    
        nameText.text = currentObject[@"name"];
        NSNumber *phoneNumber = currentObject[@"phone"];
        NSString *phoneString = [phoneNumber stringValue];
        numberText.text = phoneString;
        
   // }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"editSegue"]) {
        
        EditViewController *evc = segue.destinationViewController;
        evc.editObject = currentObject;
        
    }
    
}


@end
