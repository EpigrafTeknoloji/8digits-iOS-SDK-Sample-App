//
//  EDTVisitorViewController.m
//  EightDigitsTest
//
//  Created by Seyithan Teymur on 30/07/12.
//  Copyright (c) 2012 Verisun Bilişim Danışmanlık. All rights reserved.
//

#import "EDTVisitorViewController.h"
#import "EightDigits.h"

@interface EDTVisitorViewController ()

@property (strong, nonatomic) IBOutlet	UILabel		*scoreLabel;
@property (strong, nonatomic) IBOutlet	UIView		*loadingView;

@property (nonatomic)					NSInteger	 visitorScore;

- (void)dismiss;

@end

@implementation EDTVisitorViewController

@synthesize scoreLabel		= _scoreLabel;
@synthesize loadingView		= _loadingView;

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

- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	/**
		Get the score
	 */
	self.visitorScore = [[EDVisitor currentVisitor] score];
		
	if (self.visitorScore == EDVisitorScoreNotLoaded) {
		
		/**
			Score has not been loaded yet.
			Load asynchronously
		 */
		[[EDVisitor currentVisitor] loadScoreWithCompletionHandler:^(NSInteger score, NSString *error) {

			self.visitorScore = score;
			self.loadingView.hidden = YES;
			self.scoreLabel.hidden = NO;
			self.scoreLabel.text = [NSString stringWithFormat:@"%i", self.visitorScore];
			
		}];
		
	}
	
	else {
		
		/**
			Score has been loaded.
			Update the interface.
		 */
		self.loadingView.hidden = YES;
		self.scoreLabel.hidden = NO;
		self.scoreLabel.text = [NSString stringWithFormat:@"%i", self.visitorScore];
		
	}

}

- (void)viewDidUnload {
	
    [super viewDidUnload];

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

@end
