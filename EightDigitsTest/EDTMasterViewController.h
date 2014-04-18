//
//  EDTMasterViewController.h
//  EightDigitsTest
//
//  Created by Seyithan Teymur on 30/07/12.
//  Copyright (c) 2012 Verisun Bilişim Danışmanlık. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EDTDetailViewController;

@interface EDTMasterViewController : UITableViewController

@property (strong, nonatomic) EDTDetailViewController *detailViewController;

@end
