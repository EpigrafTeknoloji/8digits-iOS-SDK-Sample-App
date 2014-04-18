//
//  EDTDetailViewController.m
//  EightDigitsTest
//
//  Created by Seyithan Teymur on 30/07/12.
//  Copyright (c) 2012 Verisun Bilişim Danışmanlık. All rights reserved.
//

#import "EDTDetailViewController.h"

#import "EightDigits.h"

@interface EDTDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic)			UIPopoverController	*masterPopoverController;
@property (strong, nonatomic) IBOutlet	UITableView			*tableView;

@property (strong, nonatomic)			NSArray				*cellTitles;
@property (strong, nonatomic)			NSArray				*cellDescriptions;

- (void)configureView;

@end

@implementation EDTDetailViewController

@synthesize detailItem				= _detailItem;

@synthesize masterPopoverController = _masterPopoverController;
@synthesize tableView				= _tableView;

@synthesize cellTitles				= _cellTitles;
@synthesize cellDescriptions		= _cellDescriptions;

#pragma mark - View appear/disappear

/**
	We know that in the iPad version of this app, the EDTDetailViewController will almost never disappear or reappear. But we want every EDTDetailViewController screen with a different detailItem property to be counted as a different screen. That's why we don't use automatic monitoring for this class. We will start/stop the hit on viewWillAppear: and viewWillDisappear: only if the current device is an iPhone.
 */
- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];

	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
		[self.hit start];
	}
	
}

- (void)viewWillDisappear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
		[self.hit end];
	}
	
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        [self configureView];
		
		/**
			Check if the device is an iPad. If yes, end the previous hit and start a new one. Don't worry if the hit you're trying to end hasn't started yet. 8digits API takes care of it.
		 */
		if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
			[self.hit end];
			[self.hit start];
		}

		
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView {
	
	if (self.detailItem) {
		self.title = self.detailItem;
		[self.tableView reloadData];
	}
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self configureView];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	} else {
	    return YES;
	}
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.title = NSLocalizedString(@"Product Detail", @"Product detail controller title");
    }
    return self;
}
							
#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController {
    barButtonItem.title = NSLocalizedString(@"Product List", @"Product list controller title");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.detailItem ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return section == 0 ? 3 : 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section == 0) {
		return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 56 : 76;
	}
	
	return 56;
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		
		if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
			[cell.detailTextLabel setNumberOfLines:2];
		}
		
    }
	
	if (indexPath.section == 0) {
		if (self.cellTitles == nil) {
			self.cellTitles = [NSArray arrayWithObjects:@"Controller event", @"Custom event", @"Anonymous event", nil];
			self.cellDescriptions = [NSArray arrayWithObjects:@"Triggered by calling [self triggerEventWithValue:forKey:]", @"Triggered by creating an EDEvent object and calling -trigger", @"Triggered by calling  [[EDVisit currentVisit] triggerEventWithValue:forKey:", nil];
		}
		
		[cell.textLabel setText:[self.cellTitles objectAtIndex:indexPath.row]];
		[cell.detailTextLabel setText:[self.cellDescriptions objectAtIndex:indexPath.row]];
	}
	
	else {
		NSString *titleString = [NSString stringWithFormat:indexPath.row == 0 ? @"Buy %@" : @"Return %@", [self.detailItem lowercaseString]];
		[cell.textLabel setText:titleString];
		[cell.detailTextLabel setText:indexPath.row == 0 ? @"Increases visitor score by 2" : @"Decreases visitor score by 1"];
	}
	
    return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	/**
		Events
	 */
	if (indexPath.section == 0) {
		
		if (indexPath.row == 0) {
			
			/**
			 Trigger an event right from inside UIViewController classes.
			 */
			[self triggerEventWithValue:@"controller-event" forKey:@"test-event"];
		}
		
		else if (indexPath.row == 1) {
			
			/**
			 Create a custom EDEvent object, set it's properties and trigger manually.
			 */
			EDEvent *customEvent = [[EDEvent alloc] initWithValue:@"custom-event" forKey:@"test-event" hit:self.hit];
			[customEvent trigger];
			
		}
		
		else {
			
			/**
			 Trigger events that are not associated with any hits.
			 */
			[[EDVisit currentVisit] triggerEventWithValue:@"anonymous-event" forKey:@"test-event"];
			
		}
		
	}
	
	/**
		Score increase/decrease
	 */
		
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
}

@end
