//
//  EDTDetailViewController.h
//  EightDigitsTest
//
//  Created by Seyithan Teymur on 30/07/12.
//  Copyright (c) 2012 Verisun Bilişim Danışmanlık. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EDTDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
