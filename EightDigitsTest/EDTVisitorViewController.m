//
//  EDTVisitorViewController.m
//  EightDigitsTest
//
//  Created by Seyithan Teymur on 30/07/12.
//  Copyright (c) 2012 Verisun Bilişim Danışmanlık. All rights reserved.
//

#import "EDTVisitorViewController.h"
#import "EDTVisitorAddAttributeViewController.h"

#import "EightDigits.h"

@interface EDTVisitorViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet	UILabel         *scoreLabel;
@property (strong, nonatomic) IBOutlet	UIView          *loadingView;

@property (strong, nonatomic) IBOutlet  UITableView     *tableView;

@property (nonatomic)					NSInteger        visitorScore;

@property (nonatomic, readonly)         NSDictionary    *visitorAttributes;

- (void)dismiss;

@end

@implementation EDTVisitorViewController

@synthesize scoreLabel		= _scoreLabel;
@synthesize loadingView		= _loadingView;

@synthesize tableView       = _tableView;

@synthesize visitorScore	= _visitorScore;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
		
		NSString *visitorCode = [[EDVisitor currentVisitor] visitorCode];
		self.title = [NSString stringWithFormat:@"Visitor %@", visitorCode];
		
		UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss)];
		self.navigationItem.rightBarButtonItem = doneItem;
		
    }
    
    return self;
	
}

- (NSDictionary *)visitorAttributes {
    return [[EDVisitor currentVisitor] visitorAttributes];
}

- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	/**
		Get the score
	 */
	    
    self.scoreLabel.hidden = YES;
    self.loadingView.hidden = YES;
    
    /**
        Get visitor's age
     */
    NSInteger visitorAge = [[EDVisitor currentVisitor] age];
    
    if (visitorAge == 0) {
        
        /**
            Age has not been set
            Set asynchronously
         */
        [[EDVisitor currentVisitor] setAge:(arc4random() % 50) + 10];
        
    }
    
    EDVisitorGender gender = [[EDVisitor currentVisitor] gender];
    if (gender == EDVisitorGenderNotSpecified) {
        [[EDVisitor currentVisitor] setGender:(arc4random() % 100) > 42 ? EDVisitorGenderMale : EDVisitorGenderFemale];
    }
    
    [self.tableView reloadData];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView flashScrollIndicators];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		return YES;
	}
	
	return interfaceOrientation == UIInterfaceOrientationPortrait;
	
}

- (void)dismiss {
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.visitorAttributes.count ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : self.visitorAttributes.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"Existing attributes";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0) {

        [cell.textLabel setText:@"Add attribute"];
        [cell.detailTextLabel setText:nil];
        
        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        
    }
    
    else {
        
        NSString *key = [self.visitorAttributes.allKeys objectAtIndex:indexPath.row];
        NSString *value = [self.visitorAttributes objectForKey:key];
        
        [cell.textLabel setText:key];
        [cell.detailTextLabel setText:value];
        
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        EDTVisitorAddAttributeViewController *controller = [[EDTVisitorAddAttributeViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:controller animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
