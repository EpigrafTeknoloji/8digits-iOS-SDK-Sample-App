//
//  EDTMasterViewController.m
//  EightDigitsTest
//
//  Created by Seyithan Teymur on 30/07/12.
//  Copyright (c) 2012 Verisun Bilişim Danışmanlık. All rights reserved.
//

#import "EDTMasterViewController.h"

#import "EDTDetailViewController.h"
#import "EDTVisitorViewController.h"

@interface EDTMasterViewController () {
    NSMutableArray *_objects;
}

@property (strong, nonatomic)	NSArray	*products;

- (void)showVisitorInfo:(id)sender;

@end

@implementation EDTMasterViewController

@synthesize detailViewController	= _detailViewController;

@synthesize products				= _products;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		
		self.title = NSLocalizedString(@"Product List", @"Product list controller title");
		
		/**
			Product names generated with http://online-generator.com/name-generator/product-name-generator.php
		 */
		self.products = [NSArray arrayWithObjects:@"Alphawarm", @"Movetip", @"Blackflex", @"Treetough", @"Ecocore", @"Medcore", @"Superity", @"Freshsoft", @"Ranstring", @"Quadity", @"Movekix", @"Freeair", @"Saltstrong", @"Sanfresh", @"K-it", @"Unihold", @"Roundla", @"Geoair", @"Zoohome", @"Deepthought", nil];
		
		if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		    self.clearsSelectionOnViewWillAppear = NO;
		    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
		}
		
    }
    return self;
}
							
- (void)viewDidLoad {
	
    [super viewDidLoad];

	UIBarButtonItem *visitorButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Visitor" style:UIBarButtonItemStyleBordered target:self action:@selector(showVisitorInfo:)];
	self.navigationItem.leftBarButtonItem = visitorButtonItem;

	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
	self.navigationItem.rightBarButtonItem = addButton;
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	} else {
	    return YES;
	}
}

- (void)insertNewObject:(id)sender {
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
	
	id randomObject = [self.products objectAtIndex:arc4random() % (self.products.count - 1)];
    [_objects insertObject:randomObject atIndex:0];
	
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - 

- (void)showVisitorInfo:(id)sender {
	
	EDTVisitorViewController *visitorController = [[EDTVisitorViewController alloc] init];
	UINavigationController *visitorNavigationController = [[UINavigationController alloc] initWithRootViewController:visitorController];
	
	[visitorNavigationController setModalPresentationStyle:UIModalPresentationFormSheet];
	[self presentModalViewController:visitorNavigationController animated:YES];
	
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }


	NSDate *object = [_objects objectAtIndex:indexPath.row];
	cell.textLabel.text = [object description];
    return cell;
	
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDate *object = [_objects objectAtIndex:indexPath.row];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    if (!self.detailViewController) {
	        self.detailViewController = [[EDTDetailViewController alloc] initWithNibName:@"EDTDetailViewController_iPhone" bundle:nil];
	    }
	    self.detailViewController.detailItem = object;
        [self.navigationController pushViewController:self.detailViewController animated:YES];
    } else {
        self.detailViewController.detailItem = object;
    }
	
}

@end
